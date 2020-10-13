@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=ADB install apk
::color B0
color 20
echo Starting ... ������ ...

set TEMP_FILE=/rsdcard/adb_install_apk_temp.apk

::set TEMP=%1
::set "TEMP=%TEMP: =%" 
::if "%TEMP%"=="" goto exit
echo "%1" | findstr /c:APK /i > NUL

if errorlevel 1 (
  echo. Need apk file.
  echo . �����Ҫ��װ��apk�ļ��Ϸŵ����bat�������ļ��ϣ�  .
  goto exit
) ELSE (
  echo. OK!
)


echo.
echo ==================================================
echo . ����װ %1 ... 
echo ==================================================
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

adb push %1 %TEMP_FILE%

echo *** ������ϣ���ʼ��װ�����Ժ� ...

adb shell pm install -r %TEMP_FILE%
adb shell rm %TEMP_FILE%

echo.
echo ==================================================
echo . ��װ��ɣ�   ��������˳�����ֱ�ӹرմ��ڡ�    .
echo ==================================================
echo.

:exit

pause

::EOF