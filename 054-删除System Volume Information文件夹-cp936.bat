@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=ɾ��System Volume Information�ļ���
::color B0
color 1F


echo.
echo.
echo ------------------------------------------------------
echo . ����ɾ��System Volume Information�ļ���            .
echo ------------------------------------------------------
echo.

pause

echo.
echo ------------------------------------------------------
echo . ɾ�� System Volume Information �ļ���              .
echo ------------------------------------------------------
echo.
echo.

echo deleting ...
adb shell "rm -rf /storage/sdcard1/System\ Volume\ Information"
echo deleted.
pause

::EOF