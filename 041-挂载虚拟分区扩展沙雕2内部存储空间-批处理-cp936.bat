@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=Mount ext4 image
::color B0
color 1F
echo Starting ... ������ ...
.\ConSetBuffer.exe /Y=9999


echo ============================================================
echo + ��bat�ű���������ҪRP2�ѳɹ���װBusyBox��                +
echo +                                 -------                  +
echo + ȷ��������� ��ȷ����ֱ�ӹرգ�                          +
echo ============================================================
echo.

pause

set MEDIA_FILE=image_data_media.img
set DATA_FILE=image_data_data.img
::����һ���ǹ��ص� /data/media �ľ����ļ�Ԥ���С����λMB
set MEDIA_FILE_SIZE=40000
::����һ���ǹ��ص� /data/data �ľ����ļ�Ԥ���С����λMB
set DATA_FILE_SIZE=9000

echo.
echo.
echo ================================================
echo + ���ؽű� V1.3                       20201001 +
echo ================================================
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo +��ע�⡿                                      +
echo +                                              +
echo +   ��Ϊ�ű�ִ�����������������ݵķ��գ�     +
echo + ��һ����ǰ���ݻ�����SD������Ҫ���ݣ�         +
echo +                                              +
echo +   �뱣֤����SD��ʣ��ռ���㣬ʣ��ռ�Ҫ���� +
echo + ( %MEDIA_FILE_SIZE% + %DATA_FILE_SIZE% + 500 ) MB ��                +
echo + �ռ䲻�����ɺ����ű�����ʧ�ܣ�             +
echo +                                              +
echo +   ���ű��������ظ����У���һ�����к�       +
echo + �ڶ������п��ܻ�������ݶ�ʧ��               +
echo +                                              +
echo +   �ű����߲��е��ű���������ɵ��κ���ʧ��   +
echo +                                              +
echo + ���������������ʾ���ܣ�                     +
echo + �����ܿ��� ֱ�ӹرձ����� �˳���             +
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo ================================================
echo.
echo.

pause

echo.
echo.
echo --------------------------------------------
echo + �����г���׿�豸 ...                     +
echo --------------------------------------------

adb devices

echo --------------------------------------------
echo + �������û�гɹ��г���ȷ�İ�׿�豸��     +
echo + ��һ�� ��Ҫ���� ��                       +
echo --------------------------------------------
echo.
echo.

pause

echo.
echo.
echo --------------------------------------------
echo + ��ִ�� adb root ...                      +
echo --------------------------------------------
echo.
echo.

TIMEOUT /T 2 /NOBREAK > NUL
adb root
TIMEOUT /T 2 /NOBREAK > NUL
adb remount

echo --------------------------------------------
echo + �������adb root��adb remountû�гɹ���  +
echo + ��һ�� ��Ҫ���� ��                       +
echo --------------------------------------------
echo.
echo.

pause

echo.
echo.
echo -------------------------------------------------
echo + ���ɿվ����ļ����ڹ��ص� /data/media          +
echo + �ļ�����   %MEDIA_FILE%               +
echo + �ļ���С�� %MEDIA_FILE_SIZE% MB                           +
echo + �ļ�λ������SD����Ŀ¼�� ����ر�֤�ռ���㣡 +
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...            +
echo -------------------------------------------------
echo.
echo.

adb shell dd if=/dev/zero of=/rsdcard/%MEDIA_FILE% bs=1m count=%MEDIA_FILE_SIZE%
adb shell mke2fs -t ext4 -F /rsdcard/%MEDIA_FILE%

echo.
echo.
echo -------------------------------------------------
echo + ���ɿվ����ļ����ڹ��ص� /data/data           +
echo + �ļ�����   %DATA_FILE%                +
echo + �ļ���С�� %DATA_FILE_SIZE% MB                           +
echo + �ļ�λ������SD����Ŀ¼�� ����ر�֤�ռ���㣡 +
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...            +
echo -------------------------------------------------
echo.
echo.

adb shell dd if=/dev/zero of=/rsdcard/%DATA_FILE% bs=1m count=%DATA_FILE_SIZE%
adb shell mke2fs -t ext4 -F /rsdcard/%DATA_FILE%

echo.
echo.
echo ---------------------------------------------
echo + ���� /data/media Ŀ¼�µ����ݵ������ļ��� +
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...        +
echo ---------------------------------------------
echo.
echo.

adb shell mkdir /data/temp
adb shell losetup /dev/block/loop1 /rsdcard/%MEDIA_FILE%
adb shell mount -o rw -t ext4 /dev/block/loop1 /data/temp
::adb shell cp -ar /data/media/* /data/temp/
adb shell "(cd /data/media; busybox tar -cf - . ) | busybox tar -xf - -C /data/temp"
adb shell umount /data/temp
adb shell rmdir /data/temp

echo.
echo.
echo --------------------------------------------
echo + ���� /data/data Ŀ¼�µ����ݵ������ļ��� +
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...       +
echo --------------------------------------------
echo.
echo.

adb shell mkdir /data/temp2
adb shell losetup /dev/block/loop2 /rsdcard/%DATA_FILE%
adb shell mount -o rw -t ext4 /dev/block/loop2 /data/temp2
::adb shell cp -ar /data/data/* /data/temp2/
adb shell "(cd /data/data; busybox tar -cf - . ) | busybox tar -xf - -C /data/temp2"
adb shell umount /data/temp2
adb shell rmdir /data/temp2

echo.
echo.
echo ------------------------------------------------------
echo +   �Ƿ�ɾ��ԭ /data/media Ŀ¼�µ����� (�з���!!!!) +
echo + ���ͷ��ڲ��洢�ռ䣿                               +
echo +   �����Ҫɾ���������д�� YES ���س���            +
echo + ����ֱ�ӻس�������                                 +
echo ------------------------------------------------------
set userinput=NA
set /p userinput=

if "%userinput%"=="YES" (
echo.
echo.
echo --------------------------------------------
echo + ɾ��ԭ /data/media Ŀ¼�µ����� ...      +
echo --------------------------------------------

adb shell rm -rf /data/media/*

echo.
echo.
)

echo.
echo.
echo -----------------------------------------------------
echo +   �Ƿ�ɾ��ԭ /data/data Ŀ¼�µ����� (�з���!!!!) +
echo + ���ͷ��ڲ��洢�ռ䣿                              +
echo +   �����Ҫɾ���������д�� YES ���س���           +
echo + ����ֱ�ӻس�������                                +
echo -----------------------------------------------------
set userinput=NA
set /p userinput=

if "%userinput%"=="YES" (
echo.
echo.
echo --------------------------------------------
echo + ɾ��ԭ /data/data Ŀ¼�µ����� ...       +
echo --------------------------------------------

adb shell rm -rf /data/data/*

echo.
echo.
)


echo.
echo.
echo --------------------------------------------
echo + ���� /system/bin/boot.sh �ļ� ...        +
echo --------------------------------------------
echo.
echo.

::����/system/bin/boot.sh
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak"
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.`date +%%y%%m%%d_%%H%%M`"

::��ʼ�޸�
adb shell "echo >> /system/bin/boot.sh"
adb shell "echo >> /system/bin/boot.sh"
adb shell "echo >> /system/bin/boot.sh"

adb shell "echo 'losetup /dev/block/loop1 /rsdcard/%MEDIA_FILE%' >> /system/bin/boot.sh"
adb shell "echo 'mount -o rw -t ext4 /dev/block/loop1 /data/media' >> /system/bin/boot.sh"

adb shell "echo 'losetup /dev/block/loop2 /rsdcard/%DATA_FILE%' >> /system/bin/boot.sh"
adb shell "echo 'mount -o rw -t ext4 /dev/block/loop2 /data/data' >> /system/bin/boot.sh"


echo.
echo.
echo ==================================================
echo + ���й�������ɣ����Իع���Ļ������޴�����Ϣ�� +
echo + �����������������ʹ���Զ�������Ч��           +
echo + ����������������� ֱ�ӹرձ����� �˳� ...     +
echo ==================================================
echo.
echo.

pause

adb shell sync
adb reboot

::EOF