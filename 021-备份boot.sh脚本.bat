@echo off
chcp 65001 > NUL
mode con cols=80 lines=85
title=Backup boot.sh file
::color B0
color 1F
echo Starting ... 启动中 ...

echo.
echo  检查RP2是否连接 ...
echo.
adb devices
pause

echo.
echo  备份boot.sh ...
echo.
adb pull /system/bin/boot.sh
echo.
echo.
echo  备份完成.
echo.
echo  按任意键退出
echo.
pause