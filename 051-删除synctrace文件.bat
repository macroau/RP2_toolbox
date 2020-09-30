@echo off
chcp 65001 > NUL
mode con cols=80 lines=30
title=删除synctrace文件
::color B0
color 1F

echo.
echo.
echo ------------------------------------------------------
echo + 即将删除 /sdcard/synctrace* 文件                   +
echo ------------------------------------------------------
echo.

pause

echo.
echo ------------------------------------------------------
echo + 删除 /sdcard/synctrace* 文件                       +
echo ------------------------------------------------------
echo.
echo.

echo deleting ...
adb shell rm /sdcard/synctrace*
echo deleted.
pause