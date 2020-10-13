@echo off
chcp 936 > NUL
mode con cols=80 lines=85
title=Mount ext4 image for data_app
::color B0
color 2F
echo Starting ... ������ ...
.\ConSetBuffer.exe /Y=9999


::���ص�/data/app�ľ����ļ����ļ���
set APP_FILE=image_data_app.img
::����һ���ǹ��ص� /data/app �ľ����ļ�Ԥ���С����λMB
set APP_FILE_SIZE=8192

echo.
echo ==================================================
echo + ����APP�ű� V1.1                      20200930 +
echo ==================================================
echo + ��������ű���������SD�������ļ��� /data/app ��+
echo + ����ͬ����/data/media��/data/data�Ľű�һ��    +
echo + ���ʹ�ã�������Ҳ���Զ���ʹ�á�               +
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo +��ע�⡿                                        +
echo +                                                +
echo +   ��Ϊ�ű�ִ�����������������ݵķ��գ�       +
echo + ��һ����ǰ���ݻ�����SD������Ҫ���ݣ�           +
echo +                                                +
echo +   ���нű�ǰ�������һ�Ρ�                     +
echo +                                                +
echo +   �뱣֤����SD��ʣ��ռ���㣬ʣ��ռ�Ҫ����   +
echo + ( %APP_FILE_SIZE% + 500 ) MB ��                +
echo + �ռ䲻�����ɺ����ű�����ʧ�ܣ�               +
echo +                                                +
echo +   ���ű��������ظ����У���һ�����к�         +
echo + �ڶ������п��ܻ�������ݶ�ʧ��                 +
echo +                                                +
echo +   �ű����߲��е��ű���������ɵ��κ���ʧ��     +
echo +                                                +
echo + ���������������ʾ���ܣ�                       +
echo + �����ܿ��� ֱ�ӹرձ����� �˳���               +
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo ==================================================
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
echo + ��һ�� ֱ�ӹرձ����� �˳���             +
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

adb root
adb remount

echo --------------------------------------------
echo + �������adb root��adb remountû�гɹ���  +
echo + ��һ�� ֱ�ӹرձ����� �˳���             +
echo --------------------------------------------
echo.
echo.
pause

echo.
echo.
echo ------------------------------------------------
echo + ���ɿվ����ļ����ڹ��ص� /data/app           +
echo + �ļ�����   %APP_FILE%                        +
echo + �ļ���С�� %APP_FILE_SIZE% MB                +
echo + �ļ�λ������SD����Ŀ¼�� ����ر�֤�ռ���㣡+
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...           +
echo ------------------------------------------------
echo.
echo.

adb shell dd if=/dev/zero of=/rsdcard/%APP_FILE% bs=1m count=%APP_FILE_SIZE%
adb shell mke2fs -t ext4 -F /rsdcard/%APP_FILE%

echo.
echo.
echo --------------------------------------------
echo + ���� /data/app Ŀ¼�µ����ݵ������ļ���  +
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...       +
echo --------------------------------------------
echo.
echo.

adb shell mkdir /data/temp3
adb shell losetup /dev/block/loop3 /rsdcard/%APP_FILE%
adb shell mount -o rw -t ext4 /dev/block/loop3 /data/temp3
adb shell cp -ar /data/app/* /data/temp3/
adb shell umount /data/temp3
adb shell rmdir /data/temp3

echo.
echo.
echo ----------------------------------------------------
echo +   �Ƿ�ɾ��ԭ /data/app Ŀ¼�µ����� (�з���!!!!) +
echo + ���ͷ��ڲ��洢�ռ䣿                             +
echo +   �����Ҫɾ���������д�� YES ���س���          +
echo + ����ֱ�ӻس�������                               +
echo ----------------------------------------------------
echo.
echo.
set userinput=NA
set /p userinput=

if "%userinput%"=="YES" (
echo.
echo.
echo --------------------------------------------
echo + ɾ��ԭ /data/app Ŀ¼�µ����� ...        +
echo --------------------------------------------

adb shell rm -rf /data/app/*

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

adb shell "echo 'losetup /dev/block/loop3 /rsdcard/%APP_FILE%' >> /system/bin/boot.sh"
adb shell "echo 'mount -o rw -t ext4 /dev/block/loop3 /data/app' >> /system/bin/boot.sh"

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