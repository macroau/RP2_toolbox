@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=RESTORE RA
bin\ConSetBuffer.exe /Y=9999

echo Starting ... ������ ...

set BB_FILENAME=bin\busybox-armv7l

set EXT_DATA_DIR=/storage/sdcard1
set EXT_DATA_FILE=ra_ext.tar.gz

set INT_DATA_MEDIA_DIR=/storage/sdcard0
set INT_DATA_MEDIA_FILE=ra_int_m.tar.gz

set INT_DATA_DATA_DIR=/data/data
set INT_DATA_DATA_FILE=ra_int_d.tar.gz
set INT_DATA_DATA_PKG=com.retroarch

set INT_DATA_MEDIA_ANDR_DIR=/storage/sdcard0/Android/data
set INT_DATA_MEDIA_ANDR_FILE=ra_int_andr.tar.gz

set TF_ROOT=/storage/sdcard1

set LOCAL_FILE_DIR=ra_bak

TIMEOUT /T 2 /NOBREAK > NUL

echo.
echo.
echo ==================================================================
echo . ��bat�����ָ���RA1.9��ȫ������                                 .
echo ==================================================================
echo .   ��ȷ���Ѿ���װ��RA1.9������֤RA���ѹر�״̬                  .
echo .   ���������ʼ ...      ����ҪADB��                            .
echo ==================================================================
echo.

pause

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

echo.
echo.
echo ------------------------------------------------------------
echo . ��ִ�� adb root ...                                      .
echo ------------------------------------------------------------
echo.
echo.

TIMEOUT /T 2 /NOBREAK > NUL
adb root
TIMEOUT /T 2 /NOBREAK > NUL
adb remount

echo.
echo ------------------------------------------------------------
echo . �������adb root��adb remountû�гɹ���                  .
echo . ��һ�� ��Ҫ���� ��                                       .
echo ------------------------------------------------------------
echo.
echo.

pause

echo ------------------------------------------
echo *** ��װBusybox ...
adb push %BB_FILENAME% /system/xbin/busybox
adb shell chmod a+x /system/xbin/busybox

echo ------------------------------------------
echo *** ����ѹ���� %EXT_DATA_FILE% ...
adb push %LOCAL_FILE_DIR%\%EXT_DATA_FILE% %TF_ROOT%/
echo ### ������� .
echo ------
echo *** ��ѹ�� ...
adb shell "busybox tar zxf %TF_ROOT%/%EXT_DATA_FILE% -C %EXT_DATA_DIR%/"
echo ### ��ѹ����� .
echo ------
echo *** ���TF���ϵ�RA����ռ�õĿռ� ...
adb shell "du -h -d 1 %EXT_DATA_DIR%/RetroArch | grep '/RetroArch$'"
adb shell rm %TF_ROOT%/%EXT_DATA_FILE%
echo.

echo ------------------------------------------
echo *** ����ѹ���� %INT_DATA_MEDIA_FILE% ...
adb push %LOCAL_FILE_DIR%\%INT_DATA_MEDIA_FILE% %TF_ROOT%/ 
echo ### ������� .
echo ------
echo *** ��ѹ�� ...
adb shell "busybox tar zxmof %TF_ROOT%/%INT_DATA_MEDIA_FILE% -C %INT_DATA_MEDIA_DIR%/;chmod 777 /data/media -R;"
echo ### ��ѹ����� .
echo ------
echo *** ����ڲ��洢��RA����ռ�õĿռ�-1 ...
adb shell "du -h -d 1 %INT_DATA_MEDIA_DIR%/RetroArch | grep '/RetroArch$'"
adb shell rm %TF_ROOT%/%INT_DATA_MEDIA_FILE%
echo.

echo ------------------------------------------
echo *** ����ѹ���� %INT_DATA_DATA_FILE% ...
adb push %LOCAL_FILE_DIR%\%INT_DATA_DATA_FILE%  %TF_ROOT%/
echo ### ������� .
echo ------
echo *** ��ѹ�� ...
adb shell "uid=$(ls -ld %INT_DATA_DATA_DIR%/%INT_DATA_DATA_PKG% | cut -d ' ' -f 2);busybox tar zxmof %TF_ROOT%/%INT_DATA_DATA_FILE% -C %INT_DATA_DATA_DIR%/;chown $uid:$uid %INT_DATA_DATA_DIR%/%INT_DATA_DATA_PKG% -R"
echo ### ��ѹ����� .
echo ------
echo *** ����ڲ��洢��RA����ռ�õĿռ�-2 ...
adb shell "du -h -d 1 %INT_DATA_DATA_DIR%/com.retroarch | grep '/com.retroarch$'"
adb shell rm %TF_ROOT%/%INT_DATA_DATA_FILE%
echo.

echo ------------------------------------------
echo *** ����ѹ���� %INT_DATA_MEDIA_ANDR_FILE% ...
adb push %LOCAL_FILE_DIR%\%INT_DATA_MEDIA_ANDR_FILE%  %TF_ROOT%/
echo ### ������� .
echo ------
echo *** ��ѹ�� ...
adb shell "busybox tar zxmof %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE% -C %INT_DATA_MEDIA_ANDR_DIR%/;chmod 777 /data/media -R;"
echo ### ��ѹ����� .
echo ------
echo *** ����ڲ��洢��RA����ռ�õĿռ�-3 ...
adb shell "du -h -d 1 %INT_DATA_MEDIA_ANDR_DIR%/com.retroarch | grep '/com.retroarch$'"
adb shell rm %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE%
echo.

echo ------------------------------------------

TIMEOUT /T 2 /NOBREAK > NUL
adb shell mount -o ro,remount /system
TIMEOUT /T 2 /NOBREAK > NUL
adb unroot

echo ------------------------------------------
echo ### ���й�������� .
echo ### �ѻָ�RA��ȫ������ .
echo ------------------------------------------

pause

::EOF