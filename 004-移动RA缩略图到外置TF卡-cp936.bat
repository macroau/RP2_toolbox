@echo off
call config.bat

chcp 936 > NUL
::mode con cols=120 lines=30
title=�ƶ�RA����ͼ������TF��
::color B0
::color 30
echo Starting ... ������ ...
::.\ConSetBuffer.exe /Y=9999


echo.
echo.
echo ==================================================================
echo . �ƶ�RA����ͼ������TF�� .
echo ==================================================================

echo.

pause

:start

echo.
echo.
echo ------------------------------------------------------------
echo . �����г���׿�豸 ...                                     .
echo ------------------------------------------------------------
echo.

adb devices

echo.
echo ------------------------------------------------------------
echo . �������û�гɹ��г���ȷ�İ�׿�豸��                     .
echo . ��һ�� ��Ҫ������ �� ֱ�ӹرձ����� �˳���               .
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
echo .   ��ɣ���������RA��thumbnails������ͼ����·������  .
echo .    /storage/sdcard1/RetroArch/thumbnails/           .
echo =======================================================
echo. 

:exit
pause
:: �˳�������

::EOF