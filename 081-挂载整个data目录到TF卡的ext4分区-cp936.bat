@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=Mount data dir to 2nd ext4 part on tf

echo Starting ... 启动中 ...
bin\ConSetBuffer.exe /Y=9999

set BIN_DIR=bin
set DATA_DIR=data

set EXT4_DEVICE=/dev/block/mmcblk1p2
set TEMP_MNT_DIR=/storage/temp6

set BB_FILENAME=busybox-armv7l
set BOOT_SH_FILENAME=boot.sh

set FLAG_FILE=/rsdcard/VIRTUAL_INTERNAL_STORAGE_EXT4.FLG

TIMEOUT /T 2 /NOBREAK > NUL

echo ============================================================
echo .  本bat将                                                 .
echo .    1. 安装Busybox工具箱                                  .
echo .    2. 格式化TF卡第二个分区为ext4格式                     .
echo .    3. 复制内置存储的/data到TF卡第2个分区                 .
echo .    4. 更新/system/bin/boot.sh文件增加挂载命令            .
echo .    5. 在TF卡exfat分区产生挂载标志文件                    .
echo .    6. 重启                                               .
echo ============================================================
echo .  【后面需要调用ADB，请确定已配置好ADB运行环境】          .
pause

echo.
echo.
echo ------------------------------------------------------------
echo . 尝试列出安卓设备 ...                                     .
echo ------------------------------------------------------------
echo.

adb devices

echo.
echo ------------------------------------------------------------
echo . 如果上面没有成功列出正确的安卓设备，                     .
echo . 请一定 不要继续， 可 直接关闭本窗口 退出！               .
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo . 将执行 adb root ...                                      .
echo ------------------------------------------------------------
echo.
echo.

TIMEOUT /T 2 /NOBREAK > NUL
adb root
TIMEOUT /T 2 /NOBREAK > NUL
adb remount

echo.
echo ------------------------------------------------------------
echo . 如果上面adb root或adb remount没有成功，                  .
echo . 请一定 不要继续 ！                                       .
echo ------------------------------------------------------------
echo.
echo.

pause


echo ------------------------------------------------------------
echo *** 安装Busybox工具箱 ...
adb push %BIN_DIR%\%BB_FILENAME% /system/xbin/busybox
adb shell chmod a+x /system/xbin/busybox
echo ### 安装成功
echo.

echo ------------------------------------------------------------
echo ### 即将格式化TF卡的第2个分区，并挂载 ...
echo.

pause

echo.

adb shell mke2fs -t ext4 -F %EXT4_DEVICE%
adb shell mkdir %TEMP_MNT_DIR%
adb shell mount -o rw -t ext4 %EXT4_DEVICE% %TEMP_MNT_DIR%

echo.
echo ------------------------------------------------------------
echo .  上面如果报错，请不要继续！！！          .
echo ------------------------------------------------------------
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo . 拷贝系统 /data 目录下的数据 到 TF卡第 2 分区 ...
echo . /data 目录占用的空间为：                                 .

adb shell "du -h -d 1 /data | grep $'\t/data$'"

echo . 此过程需要一点时间，请耐心等待 ...                   
echo ------------------------------------------------------------
echo.
echo.

adb shell "(cd /data/; busybox tar -cf - . ) | busybox tar -xf - -C %TEMP_MNT_DIR%/"
adb shell umount %TEMP_MNT_DIR%
adb shell rmdir %TEMP_MNT_DIR%

echo.
echo ------------------------------------------------------------
echo . 拷贝完成，检查上面的过程是否有出错信息。                 .
echo . 如果出现 “socket ignored” 错误，可以忽略。               .
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo *** 更新 /system/bin/boot.sh 文件
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak`date +%%y%%m%%d_%%H%%M`"
adb push %DATA_DIR%\%BOOT_SH_FILENAME% /system/bin/boot.sh
echo ### 更新完成 .
echo.
echo.

echo ------------------------------------------------------------
echo *** 在TF卡exfat分区产生挂载标志文件 %FLAG_FILE% .
adb shell touch %FLAG_FILE%
echo.
echo.

echo ------------------------------------------

TIMEOUT /T 2 /NOBREAK > NUL
adb shell mount -o ro,remount /system
TIMEOUT /T 2 /NOBREAK > NUL
adb unroot

echo ------------------------------------------
echo ### 所有工作已完成 .
echo ### 按任意键将自动重启RP2，使得挂载生效 .
echo ------------------------------------------

pause

adb shell sync
adb reboot

::EOF