@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=Fsck SD ext4 image
::color B0
color 4F
echo Starting ... ������ ...
.\ConSetBuffer.exe /Y=9999


adb root

:menu

echo.
echo.
echo ---------------------------------------------------------------
echo + ѡ������ļ���                                            +
echo +                                                             +
echo +  1. /rsdcard/image_data_app.img                             +
echo +  2. /rsdcard/image_data_data.img                            +
echo +  3. /rsdcard/image_data_media.img                           +
echo +                                                             +
echo + �������ֺ�س���                                            +
echo ---------------------------------------------------------------
set userinput1=NA
set /p userinput1=�û����룺

if "%userinput1%"=="1" (
echo.

adb shell e2fsck -y /rsdcard/image_data_app.img

goto start
)

if "%userinput1%"=="2" (
echo.

adb shell e2fsck -y /rsdcard/image_data_data.img

goto start
)

if "%userinput1%"=="3" (
echo.

adb shell e2fsck -y /rsdcard/image_data_media.img

goto start
)


:start

echo. 
echo. 
echo. 

goto menu

pause

::EOF