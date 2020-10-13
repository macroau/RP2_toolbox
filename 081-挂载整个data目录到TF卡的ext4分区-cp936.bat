@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=Mount data dir to 2nd ext4 part on tf

echo Starting ... ������ ...
bin\ConSetBuffer.exe /Y=9999

set BIN_DIR=bin
set DATA_DIR=data

set EXT4_DEVICE=/dev/block/mmcblk1p2
set TEMP_MNT_DIR=/storage/temp6

set BB_FILENAME=busybox-armv7l
set BOOT_SH_FILENAME=boot.sh

set FLAG_FILE=/rsdcard/VIRTUAL_INTERNAL_STORAGE_EXT4.FLG

TIMEOUT /T 2 /NOBREAK > NUL

echo ============================================================
echo .  ��bat��                                                 .
echo .    1. ��װBusybox������                                  .
echo .    2. ��ʽ��TF���ڶ�������Ϊext4��ʽ                     .
echo .    3. �������ô洢��/data��TF����2������                 .
echo .    4. ����/system/bin/boot.sh�ļ����ӹ�������            .
echo .    5. ��TF��exfat�����������ر�־�ļ�                    .
echo .    6. ����                                               .
echo ============================================================
echo .  ��������Ҫ����ADB����ȷ�������ú�ADB���л�����          .
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


echo ------------------------------------------------------------
echo *** ��װBusybox������ ...
adb push %BIN_DIR%\%BB_FILENAME% /system/xbin/busybox
adb shell chmod a+x /system/xbin/busybox
echo ### ��װ�ɹ�
echo.

echo ------------------------------------------------------------
echo ### ������ʽ��TF���ĵ�2�������������� ...
echo.

pause

echo.

adb shell mke2fs -t ext4 -F %EXT4_DEVICE%
adb shell mkdir %TEMP_MNT_DIR%
adb shell mount -o rw -t ext4 %EXT4_DEVICE% %TEMP_MNT_DIR%

echo.
echo ------------------------------------------------------------
echo .  ������������벻Ҫ����������          .
echo ------------------------------------------------------------
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo . ����ϵͳ /data Ŀ¼�µ����� �� TF���� 2 ���� ...
echo . /data Ŀ¼ռ�õĿռ�Ϊ��                                 .

adb shell "du -h -d 1 /data | grep $'\t/data$'"

echo . �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...                   
echo ------------------------------------------------------------
echo.
echo.

adb shell "(cd /data/; busybox tar -cf - . ) | busybox tar -xf - -C %TEMP_MNT_DIR%/"
adb shell umount %TEMP_MNT_DIR%
adb shell rmdir %TEMP_MNT_DIR%

echo.
echo ------------------------------------------------------------
echo . ������ɣ��������Ĺ����Ƿ��г�����Ϣ��                 .
echo . ������� ��socket ignored�� ���󣬿��Ժ��ԡ�               .
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo *** ���� /system/bin/boot.sh �ļ�
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak`date +%%y%%m%%d_%%H%%M`"
adb push %DATA_DIR%\%BOOT_SH_FILENAME% /system/bin/boot.sh
echo ### ������� .
echo.
echo.

echo ------------------------------------------------------------
echo *** ��TF��exfat�����������ر�־�ļ� %FLAG_FILE% .
adb shell touch %FLAG_FILE%
echo.
echo.

echo ------------------------------------------

TIMEOUT /T 2 /NOBREAK > NUL
adb shell mount -o ro,remount /system
TIMEOUT /T 2 /NOBREAK > NUL
adb unroot

echo ------------------------------------------
echo ### ���й�������� .
echo ### ����������Զ�����RP2��ʹ�ù�����Ч .
echo ------------------------------------------

pause

adb shell sync
adb reboot

::EOF