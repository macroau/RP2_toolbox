@echo off
chcp 65001 > NUL
mode con cols=80 lines=85
title=BusyBox Installation
::color B0
color 1F
echo Starting ... 启动中 ...
.\ConSetBuffer.exe /Y=9999

::set BB_FILENAME=busybox-armv7l-1.31.0
set BB_FILENAME=busybox-armv7l
set DL_URL=https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-armv7l

echo.
echo.
echo ======================================================
echo + Install/Push BusyBox on RP2 V1.0          20200921 +
echo +                                                    +
echo + https://busybox.net/downloads/binaries/            +
echo ======================================================
echo.
echo.
pause

dir %BB_FILENAME% > NUL

if "%ERRORLEVEL%" NEQ "0" (
echo.
echo.
echo ------------------------------------------------------
echo + BusyBox binary not found locally !                 +
echo + Will download BusyBox binary from internet ...     +
echo ------------------------------------------------------
echo.
echo.
pause

wget %DL_URL%

echo.
echo.
echo --------------------------------------------------------
echo + Download finished .                                  +
echo + If you see any errors, DON'T continue and close then +
echo + re-run this bat file.                                +
echo --------------------------------------------------------
pause
)

dir %BB_FILENAME% > NUL

if "%ERRORLEVEL%" NEQ "0" (
echo.
echo.
echo ------------------------------------------------------
echo + BusyBox binary doesn't exist !                     +
echo + Will exit ...                                      +
echo ------------------------------------------------------
echo.
echo.
goto exit
)

echo.
echo.
echo ------------------------------------------------------
echo + Check if RP2 has been connected ...                +
echo ------------------------------------------------------
echo.
echo.

adb devices

echo.
pause

echo.
echo.
echo ------------------------------------------------------
echo + ADB root ...                                       +
echo ------------------------------------------------------
echo.
echo.

TIMEOUT /T 2 /NOBREAK > NUL

adb root

TIMEOUT /T 2 /NOBREAK > NUL

adb remount

echo.
pause

echo.
echo.
echo ------------------------------------------------------
echo + Pushing BusyBox binary to folder /system/xbin/ ... +
echo ------------------------------------------------------
echo.
echo.

adb push %BB_FILENAME% /system/xbin/busybox
adb shell chmod a+x /system/xbin/busybox

echo.
pause

echo.
echo.
echo ------------------------------------------------------
echo + Trying launch BusyBox ...                          +
echo ------------------------------------------------------
echo.
echo.

adb shell busybox

echo.
echo -------------------------------------------------------------
echo + Finished ...                                              +
echo +                                                           +
echo + You can try to run BusyBox tools by typing something like +
echo +   adb shell busybox fsck --help                           +
echo +             -------                                       +
echo + Or you can type                                           +
echo +   adb shell busybox --install /system/xbin                +
echo + to install all the links to /system/xbin if you want.     +
echo +                                                           +
echo + Press any key to exit.                                    +
echo -------------------------------------------------------------
echo.
:exit
pause
::EOF