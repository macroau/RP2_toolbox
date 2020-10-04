@echo off
chcp 65001 > NUL
mode con cols=80 lines=30
title=重启RP2
::color B0
color 1F


echo.
echo.
echo ------------------------------------------------------
echo + 即将重启 RP2                                       +
echo ------------------------------------------------------
echo.

pause

echo.
echo ------------------------------------------------------
echo + 重启 RP2                                           +
echo ------------------------------------------------------
echo.
echo.

adb shell sync
adb reboot

pause