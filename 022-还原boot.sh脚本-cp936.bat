@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=Restore boot.sh file
color B0
::color 1F
echo Starting ... ������ ... 


echo.
echo  ���RP2�Ƿ����� ... 
echo.
adb devices
pause

echo.
echo  ADB ROOT 
echo.
adb root
pause

echo.
echo  ADB REMOUNT 
echo.
adb remount
pause

echo.
echo  ��ԭboot.sh ... 
echo.
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak`date +%%y%%m%%d_%%H%%M`"
adb push boot.sh /system/bin/boot.sh
echo.
echo.
echo  ��ԭ���. 
echo.
echo  �ع���Ļ������Ƿ��б��� 
echo.
echo  ����������Զ�����RP2 ... 
echo.
pause

echo.
echo  ����RP2 ... 
echo.

adb shell sync
adb reboot

echo.
echo ��������˳� ... 
echo.
pause
