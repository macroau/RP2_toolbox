@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=TURN OFF mount

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
echo .    �򿪹��أ�����Ҫ����ʱ�رչ��غ���Ҫ��ʱ���У�      .
echo .  ��Ҫ����RP2��                                           . 
echo .  ��ע�⡿ ��Ҫ�Ѿ����й�                                 .
echo .  ����������dataĿ¼��TF����ext4����.bat��                .
echo .  ���ú���TF���ĵ�2����������                             .
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

echo ------------------------------------------------------------
echo *** �������ر�־�ļ� %FLAG_FILE% .
adb shell touch %FLAG_FILE%
echo ### �������  .
echo.
echo.


echo ------------------------------------------
echo ### ���й�������� .
echo ### ����������Զ�����RP2��ʹ�ù�����Ч .
echo ------------------------------------------

pause

adb shell sync
adb reboot

::EOF