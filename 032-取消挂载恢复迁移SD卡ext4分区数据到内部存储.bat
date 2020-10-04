@echo off
chcp 65001 > NUL
mode con cols=80 lines=30
title=Unmount SD ext4 partition
color B0
::color 1F
echo Starting ... 启动中 ...
.\ConSetBuffer.exe /Y=9999


echo ============================================================
echo + 本bat脚本的运行需要RP2已成功安装BusyBox！                +
echo +                                 -------                  +
echo + 确认请继续， 不确定请直接关闭！                          +
echo ============================================================
echo.

pause

:menu

echo.
echo.
echo -------------------------------------------------------
echo + 选择恢复的挂载点                                    +
echo +                                                     +
echo +  1. /data/app     ^<===   /dev/block/mmcblk1p4 分区  +
echo +  2. /data/data    ^<===   /dev/block/mmcblk1p3 分区  +
echo +  3. /data/media   ^<===   /dev/block/mmcblk1p2 分区  +
echo +  9. 重启RP2                                         +
echo +                                                     +
echo + 输入数字后回车： （直接关闭窗口可以退出）           +
echo -------------------------------------------------------
set userinput1=NA
set /p userinput1=

if "%userinput1%"=="1" (
set IMG_FILE=/dev/block/mmcblk1p4
set MOUNT_POINT=/data/app
goto start
)

if "%userinput1%"=="2" (
set IMG_FILE=/dev/block/mmcblk1p3
set MOUNT_POINT=/data/data
goto start
)

if "%userinput1%"=="3" (
set IMG_FILE=/dev/block/mmcblk1p2
set MOUNT_POINT=/data/media
goto start
)

if "%userinput1%"=="9" (
echo [[[ 即将重启RP2！ ]]]
adb shell sync
adb reboot
goto exit
)

goto exit

:start

echo.
echo.
echo ============================================================
echo + 恢复迁移SD卡ext4分区数据到内部存储脚本 V1.2     20200930 +
echo ============================================================
echo +   本bat脚本用来取消挂载SD卡ext4分区，并迁移 ext4 分区中  +
echo + 的数据到到内部存储 %MOUNT_POINT% 。                      +
echo + 取消挂载前， 挂载到 %MOUNT_POINT% 的是 %IMG_FILE% 分区。 +
echo ============================================================
echo.

pause

echo.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !【注意】                                                !
echo !                                                        !
echo !   因为脚本执行整个过程有损坏数据的风险，               !
echo ! 请一定提前备份机器及SD卡中重要数据！                   !
echo !                                                        !
echo !   脚本运行过程中，RP2会自动重启，请耐心按照            !
echo ! 文字提示操作。                                         !
echo !                                                        !
echo !   运行本脚本前，RP2必须已成功安装BusyBox工具箱！       ! 
echo !                                                        !
echo !   请保证内部存储的剩余空间充足，剩余空间要大于         !
echo ! 取消挂载前 %MOUNT_POINT% 目录下数据所占用的空间。      !
echo ! 内部存储的剩余空间不足会造成不可预计的错误！           !
echo !                                                        !
echo !   同一个挂载点【不可以】重复恢复，重复恢复会丢失数据！ !
echo !                                                        !
echo !   本脚本最好不要重复运行！                             !
echo !                                                        !
echo !   脚本作者不承担脚本运行所造成的任何损失！             !
echo !                                                        !
echo ! 按任意键继续，表示接受！                               !
echo ! 不接受可以 直接关闭本窗口 退出。                       !
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo.

pause

CALL :adb_init

echo.
echo.
echo -------------------------------------------------
echo +   即将修改 /system/bin/boot.sh 文件，取消     +
echo + 挂载 %IMG_FILE% 分区到 %MOUNT_POINT% 目录下， +
echo -------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo -------------------------------------------------
echo +   修改 /system/bin/boot.sh 文件，取消         +
echo + 挂载 %IMG_FILE% 分区到 %MOUNT_POINT% 目录下， +
echo -------------------------------------------------
echo.
echo.

::备份/system/bin/boot.sh
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak"
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.`date +%%y%%m%%d_%%H%%M`"

if "%MOUNT_POINT%"=="/data/app" (
adb shell "sed -i '/mmcblk1p4 \/data\/app$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

if "%MOUNT_POINT%"=="/data/data" (
adb shell "sed -i '/mmcblk1p3 \/data\/data$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

if "%MOUNT_POINT%"=="/data/media" (
adb shell "sed -i '/mmcblk1p2 \/data\/media$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

:boot_mod_fin

echo.
echo.
echo -------------------------------------------------
echo +   完成修改 /system/bin/boot.sh 文件，取消     +
echo + 挂载 %IMG_FILE% 分区到 %MOUNT_POINT% 目录下。 +
echo + 按任意键自动重启 RP2 。                       +
echo -------------------------------------------------
echo.
echo.

pause

adb shell sync
adb reboot

echo.
echo.
echo ----------------------------------------------------
echo +   重启 RP2 ...                                   +
echo +                                                  +
echo + 在重启完成之前，请不要继续，耐心等待RP2完成      +
echo + 启动。                                           +
echo +                                                  +
echo +   请不要断开RP2的USB连接！                       +
echo +                                                  +
echo +   RP2完全启动后，此时不要操作RP2，按任意键继续。 +
echo ----------------------------------------------------
echo.
echo.

pause

CALL :adb_init

echo.
echo.
echo --------------------------------------------
echo +   即将拷贝 %IMG_FILE% 中的数据迁移       +
echo + 到 %MOUNT_POINT% 目录下，                +
echo +  %MOUNT_POINT% 目录下的文件将会被清空！  +
echo --------------------------------------------
echo.
echo.
echo  即将挂载 %IMG_FILE% 分区 ...
echo.

pause

adb shell mkdir /data/temp4
::adb shell mount -o rw -t ext4 %IMG_FILE% /data/temp4
adb shell mount -o ro -t ext4 %IMG_FILE% /data/temp4

echo --------------------------------------------
echo +  上面如果报错，请不要继续！！！          +
echo --------------------------------------------
echo.

pause

echo.
echo --------------------------------------------
echo + 即将拷贝 %IMG_FILE% 分区中的数据到 %MOUNT_POINT% 目录下 ... +
echo + 原 %MOUNT_POINT% 目录下的数据将被删除！  +
echo + 此过程需要一点时间，请耐心等待 ...       +
echo --------------------------------------------
echo.

pause

echo.
echo --------------------------------------------
echo + 开始拷贝 %IMG_FILE% 分区中的数据到 %MOUNT_POINT% 目录下 ... +
echo + 原 %MOUNT_POINT% 目录下的数据将被删除！  +
echo + 此过程需要一点时间，请耐心等待 ...       +
echo --------------------------------------------
echo.

adb shell rm -rf %MOUNT_POINT%/*
::adb shell cp -ar /data/temp4/* %MOUNT_POINT%/
adb shell "(cd /data/temp4; busybox tar -cf - . ) | busybox tar -xf - -C %MOUNT_POINT%"
adb shell umount /data/temp4
adb shell rmdir /data/temp4

echo.
echo --------------------------------------------
echo + 拷贝完成 ！                              +
echo --------------------------------------------
echo.
echo.
echo ==================================================
echo + 所有工作已完成，可以回滚屏幕检查有无错误信息。 +
echo + 按任意键将自动重启RP2，并返回菜单。            +
echo + 返回菜单后，等待RP2完全重启后，可选择迁移      +
echo + 其他数据。                                     +
echo +   注意，同一个挂载点不可二次恢复，二次恢复     +
echo + 会导致数据丢失！请一定小心选择，不要选错！     +
echo ==================================================
echo.
echo.

pause

adb shell sync
adb reboot

echo.
echo.
echo --------------------------------------------
echo +   重启 RP2 ...                           +
echo --------------------------------------------
echo.
echo.

pause

goto menu


:exit
pause
:: 退出主程序
EXIT /B %ERRORLEVEL%


:adb_init
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo.
echo.
echo --------------------------------------------
echo + 尝试列出安卓设备 ...                     +
echo --------------------------------------------

adb devices

echo --------------------------------------------
echo + 如果上面没有成功列出正确的安卓设备，     +
echo + 请一定 不要继续 ！                       +
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

TIMEOUT /T 2 /NOBREAK > NUL
adb root
TIMEOUT /T 2 /NOBREAK > NUL
adb remount

echo --------------------------------------------
echo + 如果上面adb root或adb remount没有成功，  +
echo + 请一定 不要继续 ！                       +
echo --------------------------------------------
echo.
echo.

pause
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
EXIT /B 0

::EOF