@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=�������ռ�ÿռ����
::color B0
color 1F
echo Starting ... ������ ...


echo.
echo.
adb shell df /data/media /data/data /data/app
echo.
echo.

echo ------------------------------------------------------
echo + Used һ��������ռ�õĿռ䡣                        +
echo ------------------------------------------------------
echo.
echo.

echo.
echo.
TIMEOUT /T 2 /NOBREAK > NUL
adb shell df /data
adb shell df /rsdcard
echo.
echo.

echo ------------------------------------------------------
echo + Free һ�����ڲ��洢����ʣ��ռ䡣                  +
echo + ���Ҫ�������ص��ļ��е����ݻָ����ڲ��洢����     +
echo + ��Ҫȷ���ڲ��洢����ʣ��ռ��㹻��                 +
echo ------------------------------------------------------
echo.
echo.

pause