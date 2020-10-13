@echo off
call config.bat

chcp 936 > NUL
::mode con cols=120 lines=30
title=移动RA缩略图到外置TF卡
::color B0
::color 30
echo Starting ... 启动中 ...
::.\ConSetBuffer.exe /Y=9999


echo.
echo.
echo ==================================================================
echo . 移动RA缩略图到外置TF卡 .
echo ==================================================================

echo.

pause

:start

echo.
echo.
echo ------------------------------------------------------------
echo . 尝试列出安卓设备 ...                                     .
echo ------------------------------------------------------------
echo.

adb devices

echo.
echo ------------------------------------------------------------
echo . 如果上面没有成功列出正确的安卓设备，                     .
echo . 请一定 不要继续， 可 直接关闭本窗口 退出！               .
echo ------------------------------------------------------------
echo.
echo.

pause

adb root
adb shell cp -r /storage/emulated/0/RetroArch/thumbnails/* /rsdcard/RetroArch/thumbnails/
adb shell rm -rf /storage/emulated/0/RetroArch/thumbnails/*
adb shell chmod -R 777 /rsdcard/RetroArch/thumbnails/*
adb unroot

echo.
echo =======================================================
echo .   完成，重新设置RA中thumbnails（缩略图）的路径到：  .
echo .    /storage/sdcard1/RetroArch/thumbnails/           .
echo =======================================================
echo. 

:exit
pause
:: 退出主程序

::EOF