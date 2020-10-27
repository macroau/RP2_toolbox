@echo off
chcp 936 > NUL
title=FILES and DIRS copy
bin\ConSetBuffer.exe /Y=9999

echo Starting ... ������ ...


set TEMP_FILE=/sdcard/adb_temp_file
set DIR=adbfiles
:: ADB_DIR��RP2�ϵ�Ŀ���ļ��У������Ժ�����
set ADB_DIR=/sdcard/temp

if '%1' neq '' (
set ADB_DIR=%1
) 

echo.
echo ------------------------------------------------------------
echo .   ���ű����´����ǰĿ¼�µ� %DIR% ��Ŀ¼�µ��ļ����Լ� .
echo . ����Ŀ¼�µ��ļ���RP2�� %ADB_DIR% Ŀ¼��   .
echo ------------------------------------------------------------

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

adb shell "mkdir -p '%ADB_DIR%'"
if %ERRORLEVEL% neq 0 (
echo ERRORLEVEL: %ERRORLEVEL%
goto exit
)

echo.
echo ------------------------------------------------------------
echo . ��ʼ�����ļ������Ժ� ...                            
echo ------------------------------------------------------------
echo.

cd %DIR%
if %ERRORLEVEL% neq 0 (
echo ERRORLEVEL: %ERRORLEVEL%
goto exit
)

for %%j in (*) do ( 
echo *** ��ʼ���� %%j �����Ժ� ...

adb push "%%j" %TEMP_FILE%

echo *** ������ϣ���ʼ��װ�����Ժ� ...

adb shell "mv %TEMP_FILE% %ADB_DIR%/'%%j'"

echo ### ��װ��� .
echo.
)

cd..

echo.
echo ------------------------------------------------------------
echo . ��ʼ�������ļ��У����Ժ�                                .
echo ------------------------------------------------------------
echo.

cd %DIR%
if %ERRORLEVEL% neq 0 (
echo ERRORLEVEL: %ERRORLEVEL%
goto exit
)

for /d %%i in (*) do (
echo *** ��RP2�����ļ��У� %ADB_DIR%/%%i ...
adb shell "mkdir -p %ADB_DIR%/'%%i'"
echo ### ������� .
echo ----
echo.
echo.

cd %%i

for %%j in (*) do ( 
echo *** ��ʼ������Ŀ¼�е��ļ��� %%j ...
echo *** ������Ҫһ��ʱ�䣬�����ļ���Ҫ��ʱ��ȡ����OBB�ļ��Ĵ�С�������ĵȴ� ...
adb push "%%j" %TEMP_FILE%
adb shell "mv %TEMP_FILE% %ADB_DIR%/'%%j'"

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
echo . ������ɣ�   ��������˳�����ֱ�ӹرմ��ڡ�    .
echo ==================================================
echo.

:exit

pause

::EOF