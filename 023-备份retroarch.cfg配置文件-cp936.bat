@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=Backup boot.sh file
::color B0
color 1F
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
echo  ����boot.sh ... 
echo.
adb pull /data/media/0/Android/data/com.retroarch/files/retroarch.cfg
echo.
echo.
echo  �������. 
echo.
echo  ��������˳� 
echo.
pause