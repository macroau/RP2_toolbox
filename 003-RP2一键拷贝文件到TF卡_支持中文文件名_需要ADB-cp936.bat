@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=ADB COPY

echo Starting ... ������ ...

if '%1'=='' (
echo .  ����Ҫ�������ļ��Ϸŵ��������������  .
goto exit
)

set FILENAME=%~n1%~x1
set FILENAME_EXT=%~x1

:: RP2�ϵ�Ŀ��Ŀ¼���粻���ڻ��Զ��������ɸ��� ...
set TF_ROOT=/sdcard/RetroArch/assets/xmb/monochrome/png
:: ------------------------------- 

::set TEMP_FILE=adb_push_temp%FILENAME_EXT%
set TEMP_FILE=adb_push_temp_file



echo.
echo ==================================================
echo . ����������%FILENAME%���ļ��� TF������Ŀ¼��    .
echo .   %TF_ROOT%                                    .
echo ==================================================
echo . ��������ű�����ˣ��ƿ��ˣ�                   .
echo . ֱ��adb push�޷����������ļ����ļ������⡣     .
echo .   RP2�ϵ�Ŀ��Ŀ¼���Ը���Ϊ����Ŀ¼��          .
echo . ��ֱ���޸�bat�ļ���������䣺                  .
echo .   set TF_ROOT=/rsdcard/Roms/000                .
echo .               -----------------Ϊ������Ŀ¼    .
echo --------------------------------------------------
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
echo . ��һ�� ֱ�ӹرձ����� �˳���                             .
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo ------------------------------------------------------------
echo . ��ʼ����apk����װ�����Ժ�                                .
echo ------------------------------------------------------------
echo.


echo *** ��ʼ���� "%1" �����Ժ� ...

adb shell "mkdir -p %TF_ROOT%"
adb push %1 %TF_ROOT%/%TEMP_FILE%


echo *** ������ϣ����Ժ� ...

adb shell "mv %TF_ROOT%/%TEMP_FILE% %TF_ROOT%/'%FILENAME%'"


echo.
echo ==================================================
echo . ������ɣ�   ��������˳�����ֱ�ӹرմ��ڡ�    .
echo ==================================================
echo.

:exit

pause

::EOF