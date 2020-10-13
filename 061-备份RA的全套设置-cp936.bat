@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=BAK RA
bin\ConSetBuffer.exe /Y=9999

echo Starting ... ������ ...

set BB_FILENAME=bin\busybox-armv7l

set EXT_DATA_DIR=/storage/sdcard1
set EXT_DATA_FILE=ra_ext.tar.gz

set INT_DATA_MEDIA_DIR=/storage/sdcard0
set INT_DATA_MEDIA_FILE=ra_int_m.tar.gz

set INT_DATA_DATA_DIR=/data/data
set INT_DATA_DATA_FILE=ra_int_d.tar.gz
set INT_DATA_DATA_PKG=com.gpsp

set INT_DATA_MEDIA_ANDR_DIR=/storage/sdcard0/Android/data
set INT_DATA_MEDIA_ANDR_FILE=ra_int_andr.tar.gz

set TF_ROOT=/storage/sdcard1

set LOCAL_FILE_DIR=ra_bak

TIMEOUT /T 2 /NOBREAK > NUL

echo.
echo.
echo ==================================================================
echo . ��bat������RA1.9��ȫ������                                     .
echo ==================================================================
echo .   ���ݹ��̻��ų�ĳЩ����û�б�Ҫ���ݵ��ļ���Ŀ¼               .
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

md %LOCAL_FILE_DIR%

echo ------------------------------------------
echo *** ���TF���ϵ�RA����ռ�õĿռ� ...
adb shell "du -h -d 1 %EXT_DATA_DIR%/RetroArch | grep '/RetroArch$'"
echo ------
echo *** ѹ��TF���ϵ�RA���� ...
echo --- �ų� �ļ��У�cheats, logs, playlists, saves, screenshots, states, temp, thumbnails
adb shell "cd %EXT_DATA_DIR%/ ;busybox tar zcf %TF_ROOT%/%EXT_DATA_FILE% RetroArch --exclude RetroArch/cheats --exclude RetroArch/logs --exclude RetroArch/playlists --exclude RetroArch/saves --exclude RetroArch/screenshots --exclude RetroArch/states --exclude RetroArch/temp --exclude RetroArch/thumbnails"
echo ### ѹ����� .
echo ------
adb shell busybox ls -lh %TF_ROOT%/%EXT_DATA_FILE%
echo ------
echo *** ��ȡѹ���� %EXT_DATA_FILE% ...
adb pull %TF_ROOT%/%EXT_DATA_FILE% %LOCAL_FILE_DIR%
echo ### ��ȡ��� .
adb shell rm %TF_ROOT%/%EXT_DATA_FILE%
echo.

echo ------------------------------------------
echo *** ����ڲ��洢��RA����ռ�õĿռ�-1 ...
adb shell "du -h -d 1 %INT_DATA_MEDIA_DIR%/RetroArch | grep '/RetroArch$'"
echo ------
echo *** ѹ���ڲ��洢�е�RA����-1 ...
echo --- �ų� �ļ��У�cheats, logs, playlists, saves, screenshots, states, temp, thumbnails
adb shell "cd %INT_DATA_MEDIA_DIR%/ ;busybox tar zcf %TF_ROOT%/%INT_DATA_MEDIA_FILE% RetroArch --exclude RetroArch/cheats --exclude RetroArch/logs --exclude RetroArch/playlists --exclude RetroArch/saves --exclude RetroArch/screenshots --exclude RetroArch/states --exclude RetroArch/temp --exclude RetroArch/thumbnails"
echo ### ѹ����� .
echo ------
adb shell busybox ls -lh %TF_ROOT%/%INT_DATA_MEDIA_FILE%
echo ------
echo *** ��ȡѹ���� %INT_DATA_MEDIA_FILE% ...
adb pull %TF_ROOT%/%INT_DATA_MEDIA_FILE% %LOCAL_FILE_DIR%
echo ### ��ȡ��� .
adb shell rm %TF_ROOT%/%INT_DATA_MEDIA_FILE%
echo.

echo ------------------------------------------
echo *** ����ڲ��洢��RA����ռ�õĿռ�-2 ...
adb shell "du -h -d 1 %INT_DATA_DATA_DIR%/com.retroarch | grep '/com.retroarch$'"
echo ------
echo *** ѹ���ڲ��洢�е�RA����-2 ...
echo --- �ų� �ļ��У�cache, lib    �ų� �ļ��� *.lpl
adb shell "cd %INT_DATA_DATA_DIR%/ ;busybox tar zcf %TF_ROOT%/%INT_DATA_DATA_FILE% com.retroarch --exclude *.lpl --exclude com.retroarch/cache --exclude com.retroarch/lib"
echo ### ѹ����� .
echo ------
adb shell busybox ls -lh %TF_ROOT%/%INT_DATA_DATA_FILE%
echo ------
echo *** ��ȡѹ���� %INT_DATA_DATA_FILE% ...
adb pull %TF_ROOT%/%INT_DATA_DATA_FILE% %LOCAL_FILE_DIR%
echo ### ��ȡ��� .
adb shell rm %TF_ROOT%/%INT_DATA_DATA_FILE%
echo.

echo ------------------------------------------
echo *** ����ڲ��洢��RA����ռ�õĿռ�-3 ...
adb shell "du -h -d 1 %INT_DATA_MEDIA_ANDR_DIR%/com.retroarch | grep '/com.retroarch$'"
echo ------
echo *** ѹ���ڲ��洢�е�RA����-3 ...
adb shell "cd %INT_DATA_MEDIA_ANDR_DIR%/ ;busybox tar zcf %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE% com.retroarch"
echo ### ѹ����� .
echo ------
adb shell busybox ls -lh %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE%
echo ------
echo *** ��ȡѹ���� %INT_DATA_MEDIA_ANDR_FILE% ...
adb pull %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE% %LOCAL_FILE_DIR%
echo ### ��ȡ��� .
adb shell rm %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE%
echo.

echo ------------------------------------------

TIMEOUT /T 2 /NOBREAK > NUL
adb shell mount -o ro,remount /system
TIMEOUT /T 2 /NOBREAK > NUL
adb unroot

echo ------------------------------------------
echo ### ���й�������� .
echo ### ����ȡ4���ļ���
echo ### %EXT_DATA_FILE%
echo ### %INT_DATA_MEDIA_FILE%
echo ### %INT_DATA_DATA_FILE%
echo ### %INT_DATA_MEDIA_ANDR_FILE%
echo ------------------------------------------
dir %LOCAL_FILE_DIR%
echo ------------------------------------------

pause

::EOF