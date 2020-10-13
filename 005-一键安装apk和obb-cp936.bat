@echo off
chcp 936 > NUL
title=APK and OBB installer
bin\ConSetBuffer.exe /Y=9999

echo Starting ... ������ ...

set RP2_OBB_DIR=/sdcard/Android/obb
set TEMP_FILE=/rsdcard/adb_install_apk_temp.apk
set APK_DIR=apk
set OBB_DIR=obb

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
echo . ��ʼ����apk����װ�����Ժ� ...                            .
echo ------------------------------------------------------------
echo.

cd %APK_DIR%

for %%j in (*) do ( 
echo *** ��ʼ���� %%j �����Ժ� ...

adb push "%%j" %TEMP_FILE%

echo *** ������ϣ���ʼ��װ�����Ժ� ...

adb shell pm install -r %TEMP_FILE%
adb shell rm %TEMP_FILE%

echo ### ��װ��� .
echo.

)

cd..

echo.
echo ------------------------------------------------------------
echo . ��ʼ����OBB�ļ������Ժ�                                .
echo ------------------------------------------------------------
echo.

cd %OBB_DIR%

for /d %%i in (*) do (
echo *** ��RP2�����ļ��У� %RP2_OBB_DIR%/%%i ...
echo ### ������� .
echo ----
echo.
echo.
adb shell mkdir -p %RP2_OBB_DIR%/%%i

cd %%i

for %%j in (*) do ( 
echo *** ��ʼ����OBB�ļ��� %%j ...
echo *** ������Ҫһ��ʱ�䣬�����ļ���Ҫ��ʱ��ȡ����OBB�ļ��Ĵ�С�������ĵȴ� ...
adb push "%%j" %RP2_OBB_DIR%/%%i/
echo ### ������� .
echo ----
echo.
echo.
)

cd ..
)

cd..

echo.
echo ==================================================
echo . ��װ��ɣ�   ��������˳�����ֱ�ӹرմ��ڡ�    .
echo ==================================================
echo.

:exit

pause

::EOF