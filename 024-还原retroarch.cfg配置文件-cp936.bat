@echo off
chcp 936 > NUL
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
adb shell "cp /data/media/0/Android/data/com.retroarch/files/retroarch.cfg /data/media/0/Android/data/com.retroarch/files/retroarch.cfg.bak`date +%%y%%m%%d_%%H%%M`"
adb push retroarch.cfg /data/media/0/Android/data/com.retroarch/files/retroarch.cfg
echo.
echo.
echo  还原完成. 
echo.
echo  回滚屏幕，检查是否有报错.  
echo.

pause


echo 按任意键退出 ... 
echo.
pause
