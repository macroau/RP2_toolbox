@echo off
chcp 65001 > NUL
mode con cols=80 lines=30
title=删除System Volume Information文件夹
::color B0
color 1F


echo.
echo.
echo ------------------------------------------------------
echo . 即将删除System Volume Information文件夹            .
echo ------------------------------------------------------
echo.

pause

echo.
echo ------------------------------------------------------
echo . 删除 System Volume Information 文件夹              .
echo ------------------------------------------------------
echo.
echo.

echo deleting ...
adb shell "rm -rf /storage/sdcard1/System\ Volume\ Information"
echo deleted.
pause

::EOF