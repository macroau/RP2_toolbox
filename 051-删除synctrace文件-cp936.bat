@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=ɾ��synctrace�ļ�
::color B0
color 1F


echo.
echo.
echo ------------------------------------------------------
echo . ����ɾ�� /sdcard/synctrace* �ļ�                   .
echo ------------------------------------------------------
echo.

pause

echo.
echo ------------------------------------------------------
echo . ɾ�� /sdcard/synctrace* �ļ�                       .
echo ------------------------------------------------------
echo.
echo.

echo deleting ...
adb shell rm /sdcard/synctrace*
echo deleted.
pause

::EOF