@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=Fsck SD ext4 partition
::color B0
color 4E
echo Starting ... ������ ...
.\ConSetBuffer.exe /Y=9999


adb root

:menu

echo.
echo.
echo ---------------------------------------------------------------
echo + ѡ����ķ�����                                            +
echo +                                                             +
echo +  1. /dev/block/mmcblk1p2                                    +
echo +  2. /dev/block/mmcblk1p3                                    +
echo +  3. /dev/block/mmcblk1p4                                    +
echo +                                                             +
echo + �������ֺ�س���                                            +
echo ---------------------------------------------------------------
set userinput1=NA
set /p userinput1=�û����룺

if "%userinput1%"=="1" (
echo.

adb shell e2fsck -y /dev/block/mmcblk1p2

goto start
)

if "%userinput1%"=="2" (
echo.

adb shell e2fsck -y /dev/block/mmcblk1p3

goto start
)

if "%userinput1%"=="3" (
echo.

adb shell e2fsck -y /dev/block/mmcblk1p4

goto start
)


:start

echo. 
echo. 
echo. 

goto menu

pause

::EOF