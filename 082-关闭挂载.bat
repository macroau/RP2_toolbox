@echo off
chcp 65001 > NUL
mode con cols=120 lines=30
title=TURN OFF mount

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
echo .    暂时使得挂载失效（需要重启RP2）                       .
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

echo ------------------------------------------------------------
echo *** 删除挂载标志文件 %FLAG_FILE% .
adb shell rm %FLAG_FILE%
echo ### 删除完成  .
echo.
echo.


echo ------------------------------------------
echo ### 所有工作已完成 .
echo ### 按任意键将自动重启RP2，使得挂载失效 .
echo ------------------------------------------

pause

adb shell sync
adb reboot

::EOF