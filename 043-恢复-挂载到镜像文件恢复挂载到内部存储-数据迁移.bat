@echo off
chcp 65001 > NUL
mode con cols=80 lines=30
title=Unmount ext4 image
color B0
::color 2F
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
echo -----------------------------------------------
echo + 选择恢复的挂载点                            +
echo +                                             +
echo +  1. /data/app     =   image_data_app.img    +
echo +  2. /data/data    =   image_data_data.img   +
echo +  3. /data/media   =   image_data_media.img  +
echo +  4. 重启RP2                                 +
echo +                                             +
echo + 输入数字后回车：                            +
echo -----------------------------------------------
set userinput1=NA
set /p userinput1=

if "%userinput1%"=="1" (
set IMG_FILE=image_data_app.img
set MOUNT_POINT=/data/app
goto start
)

if "%userinput1%"=="2" (
set IMG_FILE=image_data_data.img
set MOUNT_POINT=/data/data
goto start
)

if "%userinput1%"=="3" (
set IMG_FILE=image_data_media.img
set MOUNT_POINT=/data/media
goto start
)

if "%userinput1%"=="4" (
echo [[[ 即将重启RP2！ ]]]
adb shell sync
adb reboot
goto exit
)

goto exit

:start

echo.
echo =====================================================
echo + 迁移镜像文件数据到内部存储脚本 V1.3      20201001 +
echo =====================================================
echo +   本bat脚本可取消挂载虚拟分区，并用来迁移(恢复)   +
echo + 镜像文件中的数据到到内部存储 %MOUNT_POINT% 。 +
echo + 取消挂载前， 挂载到 %MOUNT_POINT% 的              +
echo + 是 %IMG_FILE% 文件                                +
echo =====================================================

pause

echo.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !【注意】                                               !
echo !                                                       !
echo !   因为脚本执行整个过程有损坏数据的风险，              !
echo ! 请一定提前备份机器及SD卡中重要数据！                  !
echo !                                                       !
echo !   运行脚本前，请确认已移除/system/bin/boot.sh文件中   !
echo ! %MOUNT_POINT% 以及 %IMG_FILE% 文件的相关挂载命令，    !
echo ! 并重启。                                              !
echo !                                                       !
echo !   请保证内部存储的剩余空间充足，剩余空间要大于        !
echo ! 取消挂载前 %MOUNT_POINT% 目录下数据所占用的空间。     !
echo ! 内部存储的剩余空间不足会造成不可预计的错误！          !
echo !                                                       !
echo !   可在取消挂载前，用另外的脚本查看相关存储空间情况！  !
echo ! 如果取消挂载前 %MOUNT_POINT% 目录下数据所占用的空间   !
echo ! 过大，需要在取消挂载前，减小 %MOUNT_POINT% 目录下数据 !
echo ! 所占用的空间！                                        !
echo !                                                       !
echo !   本脚本最好不要重复运行！                            !
echo !                                                       !
echo !   脚本作者不承担脚本运行所造成的任何损失！            !
echo !                                                       !
echo ! 按任意键继续，表示接受！                              !
echo ! 不接受可以 直接关闭本窗口 退出。                      !
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo =========================================================
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
adb shell "sed -i '/^losetup \/dev\/block\/loop3 \/rsdcard/d' /system/bin/boot.sh"
adb shell "sed -i '/loop3 \/data\/app$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

if "%MOUNT_POINT%"=="/data/data" (
adb shell "sed -i '/^losetup \/dev\/block\/loop2 \/rsdcard/d' /system/bin/boot.sh"
adb shell "sed -i '/loop2 \/data\/data$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

if "%MOUNT_POINT%"=="/data/media" (
adb shell "sed -i '/^losetup \/dev\/block\/loop1 \/rsdcard/d' /system/bin/boot.sh"
adb shell "sed -i '/loop1 \/data\/media$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

:boot_mod_fin

echo.
echo.
echo -------------------------------------------------
echo +   完成修改 /system/bin/boot.sh 文件，取消     +
echo + 挂载 %IMG_FILE% 文件到 %MOUNT_POINT% 目录下。 +
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
echo +   即将拷贝 %IMG_FILE% 文件中的数据       +
echo + 到 %MOUNT_POINT% 目录下，                +
echo +  %MOUNT_POINT% 目录下的文件将会被清空！  +
echo --------------------------------------------
echo.
echo.
echo  即将挂载 %IMG_FILE% 文件 ...
echo.

pause

adb shell mkdir /data/temp4
adb shell losetup /dev/block/loop4 /rsdcard/%IMG_FILE%
adb shell mount -o ro -t ext4 /dev/block/loop4 /data/temp4

echo --------------------------------------------
echo +  上面如果报错，请不要继续！！！          +
echo --------------------------------------------
echo.

pause

echo.
echo ----------------------------------------------------
echo + 即将拷贝 %IMG_FILE% 文件中的数据到 %MOUNT_POINT% 目录下 ... +
echo + 原 %MOUNT_POINT% 目录下的数据将被删除！          +
echo + 此过程需要一点时间，请耐心等待 ...               +
echo ----------------------------------------------------
echo.

pause

echo.
echo --------------------------------------------
echo + 开始拷贝 %IMG_FILE% 文件中的数据到 %MOUNT_POINT% 目录下 ... +
echo + 原 %MOUNT_POINT% 目录下的数据将被删除！  +
echo + 此过程需要一点时间，请耐心等待 ...       +
echo --------------------------------------------
echo.

adb shell rm -rf %MOUNT_POINT%/*
::adb shell cp -ar /data/temp4/* %MOUNT_POINT%/
adb shell "(cd /data/temp4; busybox tar -cf - . ) | tar -xf - -C %MOUNT_POINT%"
adb shell umount /data/temp4
adb shell rmdir /data/temp4

echo.
echo --------------------------------------------
echo + 拷贝完成 ！                              +
echo --------------------------------------------
echo.
echo.
echo ========================================================
echo + 所有工作已完成，可以回滚屏幕检查有无错误信息。       +
echo + 按任意键将返回菜单。                                 +
echo + 返回菜单后，可选择迁移其他数据，                     +
echo + 或者选择 4， 重启机器使得数据迁移生效。              +
echo + 完成所有迁移后重启检查机器运行状况如果没有其他问题， +
echo + 可以手动删除SD卡上的 %IMG_FILE% 文件。               +
echo ========================================================
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