@echo off
chcp 65001 > NUL
mode con cols=80 lines=30
title=Restore boot.sh file
color B0
::color 1F
echo Starting ... 启动中 ... 


echo.
echo  检查RP2是否连接 ... 
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
echo  还原boot.sh ... 
echo.
adb push boot.sh /system/bin/boot.sh
echo.
echo.
echo  还原完成. 
echo.
echo  回滚屏幕，检查是否有报错。 
echo.
echo  按任意键后，自动重启RP2 ... 
echo.
pause

echo.
echo  重启RP2 ... 
echo.
adb reboot
echo.
echo 按任意键退出 ... 
echo.
pause
