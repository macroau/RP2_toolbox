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
echo  ����boot.sh ... 
echo.
adb pull /system/bin/boot.sh
echo.
echo.
echo  �������. 
echo.
echo  ��������˳� 
echo.
pause