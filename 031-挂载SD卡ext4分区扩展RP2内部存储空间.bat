@echo off
chcp 65001 > NUL
mode con cols=80 lines=30
title=Mount SD ext4 partition
::color B0
color 1F
echo Starting ... 启动中 ...
.\ConSetBuffer.exe /Y=9999


set MOUNT_DATA=0
set MOUNT_APP=0

echo ============================================================
echo + 本bat脚本的运行需要RP2已成功安装BusyBox！                +
echo +                                 -------                  +
echo + 确认请继续， 不确定请直接关闭！                          +
echo ============================================================
echo.

pause

echo.
echo.
echo ==================================================================
echo + 挂载外部SD卡ext4分区脚本 V1.2               20200930           +
echo ==================================================================
echo +   本批处理脚本用来挂载SD卡的ext4分区到 /data/media，/data/data +
echo + 和 /data/app 。                                                +
echo +                                                                +
echo +   可以选择挂载一个分区到 /data/media，或者挂载两个分区到       +
echo + /data/media 和 /data/data， 或者挂载三个分区到 /data/media，   +
echo + /data/data 和 /data/app。                                      +
echo +                                                                +
echo +   只挂载一个分区到 /data/media 时，第2个分区必须是ext4分区；   +
echo + 挂载两个分区到 /data/media 和 /data/data 时，第2，3个分区      +
echo + 必须是ext4分区；或者挂载三个分区到 /data/media，/data/data     +
echo + 和 /data/app 时，第2，3，4个分区必须是ext4分区。               +
echo +                                                                +
echo +  无论何种情况SD卡的第1个分区必须是月光系统可以识别的exFat分区，+
echo + exFat分区最好【不要小于40GB】，用于挂载的每个ext4分区最好均    +
echo + 【不要小于8GB】，且都必须是主分区。                            +
echo +   第2个分区用来挂载到 /data/media，第3个分区（如果需要）用来   +
echo + 挂载到 /data/data，第4个分区（如果需要）挂载到 /data/app 。    +
echo ==================================================================
echo.

pause

echo.
echo.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !【注意】                                          !
echo !                                                  !
echo !   因为脚本执行整个过程有损坏数据的风险，         !
echo ! 请一定提前备份机器及SD卡中重要数据！             !
echo !                                                  !
echo !   运行脚本前最好重启RP2一次。                    !
echo !                                                  !
echo !   运行本脚本前，RP2必须已成功安装BusyBox工具箱！ !
echo !                                                  !
echo !   请保证外置SD卡ext4分区空间充足(均不小于8GB)，  !
echo ! 空间不足会造成后续脚本运行失败！                 !
echo !   注意ext4分区数据将会被删除！                   !
echo !                                                  !
echo !   本脚本【不可以】重复运行，第一次运行后，       !
echo ! 第二次运行可能会造成数据丢失！                   !
echo !                                                  !
echo !   脚本作者不承担脚本运行所造成的任何损失！       !
echo !                                                  !
echo ! 按任意键继续，表示接受！                         !
echo ! 不接受可以 直接关闭本窗口 退出。                 !
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo.
echo.

pause

echo.
echo.
echo ---------------------------------------------------------------
echo + 选择方案                                                    +
echo +                                                             +
echo +  1. 只挂载/data/media，第2个分区是ext4格式                  +
echo +  2. 挂载/data/media和/data/data，第2，3个分区是ext4格式     +
echo +  3. 挂载/data/media，/data/data和/data/app，第2，3，4个分区 +
echo +     是ext4格式，此方案影响启动app的速度较多                 +
echo +  9. 重启RP2                                                 +
echo +                                                             +
echo + 输入数字后回车：                                            +
echo ---------------------------------------------------------------
set userinput1=NA
set /p userinput1=用户输入：

if "%userinput1%"=="1" (
set MOUNT_DATA=0
set MOUNT_APP=0
echo ------------------------------------------------------------
echo + 选择了：                                                 +
echo +  1. 只挂载/data/media，第2个分区是ext4格式               +
echo ------------------------------------------------------------
goto start
)

if "%userinput1%"=="2" (
set MOUNT_DATA=1
set MOUNT_APP=0
echo ------------------------------------------------------------
echo + 选择了：                                                 +
echo +  2. 挂载/data/media和/data/data，第2，3个分区是ext4格式  +
echo ------------------------------------------------------------
goto start
)

if "%userinput1%"=="3" (
set MOUNT_DATA=1
set MOUNT_APP=1
echo ---------------------------------------------------------------
echo + 选择了：                                                    +
echo +  3. 挂载/data/media，/data/data和/data/app，第2，3，4个分区 +
echo +     是ext4格式                                              +
echo ---------------------------------------------------------------
goto start
)

if "%userinput1%"=="9" (
echo [[[ 即将重启RP2！ ]]]
adb reboot
goto exit
)

goto exit

:start

echo.
echo.
echo ------------------------------------------------------------
echo + 尝试列出安卓设备 ...                                     +
echo ------------------------------------------------------------
echo.

adb devices

echo.
echo ------------------------------------------------------------
echo + 如果上面没有成功列出正确的安卓设备，                     +
echo + 请一定 不要继续， 可 直接关闭本窗口 退出！               +
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo + 将执行 adb root ...                                      +
echo ------------------------------------------------------------
echo.
echo.

TIMEOUT /T 2 /NOBREAK > NUL
adb root
TIMEOUT /T 2 /NOBREAK > NUL
adb remount

echo.
echo ------------------------------------------------------------
echo + 如果上面adb root或adb remount没有成功，                  +
echo + 请一定 不要继续 ！                                       +
echo ------------------------------------------------------------
echo.
echo.

pause

set PART_NO=2
set DEV_NAME=/dev/block/mmcblk1p2
set INN_DIR=/data/media

CALL :work_prog

if "%MOUNT_DATA%"=="0" (
echo.
echo --------------------------------------------
echo + 不需要挂载 /data/data 和 /data/app。     +
echo --------------------------------------------
echo.
echo.
goto fin
)

set PART_NO=3
set DEV_NAME=/dev/block/mmcblk1p3
set INN_DIR=/data/data

CALL :work_prog

if "%MOUNT_APP%"=="0" (
echo.
echo --------------------------------------------
echo + 不需要挂载 /data/app。                   +
echo --------------------------------------------
echo.
echo.
goto fin
)

set PART_NO=4
set DEV_NAME=/dev/block/mmcblk1p4
set INN_DIR=/data/app

CALL :work_prog

:fin

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

echo.
echo ============================================
echo + 重启 RP2 ...                             +
echo ============================================
echo.

adb reboot

:exit

pause

:: 退出主程序
EXIT /B %ERRORLEVEL%

:work_prog

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::set PART_NO=?
::set DEV_NAME=/dev/block/mmcblk1p?
::set INN_DIR=/data/?

echo.
echo.
echo --------------------------------------------
echo + 挂载SD卡第 %PART_NO% 个分区（ext4格式）          +
echo + 分区设备名： %DEV_NAME%        +
echo --------------------------------------------
echo.
echo.

adb shell mke2fs -t ext4 -F %DEV_NAME%
adb shell mkdir /data/tempmnt
adb shell mount -o rw -t ext4 %DEV_NAME% /data/tempmnt

echo.
echo --------------------------------------------
echo +  上面如果报错，请不要继续！！！          +
echo --------------------------------------------
echo.

pause

echo.
echo.
echo --------------------------------------------------------
echo + 拷贝 %INN_DIR% 目录下的数据 到 第 %PART_NO% 个分区，       +
echo + 第 %PART_NO% 个分区的数据将被清除！                          +
echo + 此过程需要一点时间，请耐心等待 ...                   +
echo --------------------------------------------------------
echo.
echo.

adb shell rm -rf /data/tempmnt/*
::adb shell "(cd %INN_DIR%; tar -cf - . ) | tar -xf - -C /data/tempmnt"   ->拷贝失败
::adb shell cp -ar %INN_DIR%/* /data/tempmnt/
adb shell "(cd %INN_DIR%; busybox tar -cf - . ) | busybox tar -xf - -C /data/tempmnt"
adb shell umount /data/tempmnt
adb shell rmdir /data/tempmnt

echo.
echo --------------------------------------------
echo + 拷贝完成，检查上面的过程是否有出错信息。 +
echo --------------------------------------------
echo.
echo.

pause

echo.
echo.
echo --------------------------------------------
echo +   是否删除原 %INN_DIR% 目录下的数据 (有风险!!!!) +
echo + 以释放内部存储空间？                     +
echo +   如果需要删除请输入大写的 YES 并回车。  +
echo + 否则直接回车继续。                       +
echo --------------------------------------------
set uinput=NA
set /p uinput=用户输入：

if "%uinput%"=="YES" (
echo.
echo --------------------------------------------
echo + 删除原 %INN_DIR% 目录下的数据 ...        +
echo --------------------------------------------
echo.

adb shell rm -rf %INN_DIR%/*

echo.
echo --------------------------------------------
echo + 删除完成，检查上面的过程是否有出错信息。 +
echo --------------------------------------------
echo.
echo.

pause
)


echo.
echo.
echo --------------------------------------------
echo + 向 /system/bin/boot.sh 添加第 %PART_NO% 个分区的挂载命令 ... +
echo --------------------------------------------
echo.
echo.

::备份/system/bin/boot.sh
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak"
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.`date +%%y%%m%%d_%%H%%M`"

::开始修改
adb shell "echo >> /system/bin/boot.sh"
adb shell "echo >> /system/bin/boot.sh"
adb shell "echo 'mount -o rw -t ext4 %DEV_NAME% %INN_DIR%' >> /system/bin/boot.sh"

echo.
echo --------------------------------------------
echo + 操作完成！                               +
echo --------------------------------------------
echo.

pause

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
EXIT /B 0

::EOF