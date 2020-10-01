@echo off
chcp 65001 > NUL
mode con cols=80 lines=85
title=Mount ext4 image for data_app
::color B0
color 2F
echo Starting ... 启动中 ...
.\ConSetBuffer.exe /Y=9999


::挂载到/data/app的镜像文件的文件名
set APP_FILE=image_data_app.img
::下面一行是挂载到 /data/app 的镜像文件预设大小，单位MB
set APP_FILE_SIZE=8192

echo.
echo ==================================================
echo + 挂载APP脚本 V1.1                      20200930 +
echo ==================================================
echo + 本批处理脚本用来挂载SD卡镜像文件到 /data/app ，+
echo + 可以同挂载/data/media和/data/data的脚本一起    +
echo + 配合使用，理论上也可以独立使用。               +
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo +【注意】                                        +
echo +                                                +
echo +   因为脚本执行整个过程有损坏数据的风险，       +
echo + 请一定提前备份机器及SD卡中重要数据！           +
echo +                                                +
echo +   运行脚本前最好重启一次。                     +
echo +                                                +
echo +   请保证外置SD卡剩余空间充足，剩余空间要大于   +
echo + ( %APP_FILE_SIZE% + 500 ) MB ！                +
echo + 空间不足会造成后续脚本运行失败！               +
echo +                                                +
echo +   本脚本不可以重复运行，第一次运行后，         +
echo + 第二次运行可能会造成数据丢失！                 +
echo +                                                +
echo +   脚本作者不承担脚本运行所造成的任何损失！     +
echo +                                                +
echo + 按任意键继续，表示接受！                       +
echo + 不接受可以 直接关闭本窗口 退出。               +
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo ==================================================
echo.
pause

echo.
echo.
echo --------------------------------------------
echo + 尝试列出安卓设备 ...                     +
echo --------------------------------------------

adb devices

echo --------------------------------------------
echo + 如果上面没有成功列出正确的安卓设备，     +
echo + 请一定 直接关闭本窗口 退出！             +
echo --------------------------------------------
echo.
echo.
pause

echo.
echo.
echo --------------------------------------------
echo + 将执行 adb root ...                      +
echo --------------------------------------------
echo.
echo.

adb root
adb remount

echo --------------------------------------------
echo + 如果上面adb root或adb remount没有成功，  +
echo + 请一定 直接关闭本窗口 退出！             +
echo --------------------------------------------
echo.
echo.
pause

echo.
echo.
echo ------------------------------------------------
echo + 生成空镜像文件用于挂载到 /data/app           +
echo + 文件名：   %APP_FILE%                        +
echo + 文件大小： %APP_FILE_SIZE% MB                +
echo + 文件位于外置SD卡根目录， 请务必保证空间充足！+
echo + 此过程需要一点时间，请耐心等待 ...           +
echo ------------------------------------------------
echo.
echo.

adb shell dd if=/dev/zero of=/rsdcard/%APP_FILE% bs=1m count=%APP_FILE_SIZE%
adb shell mke2fs -t ext4 -F /rsdcard/%APP_FILE%

echo.
echo.
echo --------------------------------------------
echo + 拷贝 /data/app 目录下的数据到镜像文件中  +
echo + 此过程需要一点时间，请耐心等待 ...       +
echo --------------------------------------------
echo.
echo.

adb shell mkdir /data/temp3
adb shell losetup /dev/block/loop3 /rsdcard/%APP_FILE%
adb shell mount -o rw -t ext4 /dev/block/loop3 /data/temp3
adb shell cp -ar /data/app/* /data/temp3/
adb shell umount /data/temp3
adb shell rmdir /data/temp3

echo.
echo.
echo ----------------------------------------------------
echo +   是否删除原 /data/app 目录下的数据 (有风险!!!!) +
echo + 以释放内部存储空间？                             +
echo +   如果需要删除请输入大写的 YES 并回车。          +
echo + 否则直接回车继续。                               +
echo ----------------------------------------------------
echo.
echo.
set userinput=NA
set /p userinput=

if "%userinput%"=="YES" (
echo.
echo.
echo --------------------------------------------
echo + 删除原 /data/app 目录下的数据 ...        +
echo --------------------------------------------

adb shell rm -rf /data/app/*

echo.
echo.
)


echo.
echo.
echo --------------------------------------------
echo + 更新 /system/bin/boot.sh 文件 ...        +
echo --------------------------------------------
echo.
echo.

::备份/system/bin/boot.sh
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak"
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.`date +%%y%%m%%d_%%H%%M`"

::开始修改
adb shell "echo >> /system/bin/boot.sh"
adb shell "echo >> /system/bin/boot.sh"

adb shell "echo 'losetup /dev/block/loop3 /rsdcard/%APP_FILE%' >> /system/bin/boot.sh"
adb shell "echo 'mount -o rw -t ext4 /dev/block/loop3 /data/app' >> /system/bin/boot.sh"

echo.
echo.
echo ==================================================
echo + 所有工作已完成，可以回滚屏幕检查有无错误信息。 +
echo + 按任意键将重启机器使得自动挂载生效；           +
echo + 如果不想重启，现在 直接关闭本窗口 退出 ...     +
echo ==================================================
echo.
echo.
pause
adb reboot

::EOF