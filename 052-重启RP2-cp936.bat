@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=����RP2
::color B0
color 1F


echo.
echo.
echo ------------------------------------------------------
echo + �������� RP2                                       +
echo ------------------------------------------------------
echo.

pause

echo.
echo ------------------------------------------------------
echo + ���� RP2                                           +
echo ------------------------------------------------------
echo.
echo.

adb shell sync
adb reboot

pause