@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=REPLACE RA FONT
bin\ConSetBuffer.exe /Y=9999

echo Starting ... ������ ...

set FONT_DIR=font
set FONT_FILE=sarasa-ui-sc-regular.ttf
set RP2_FONT_DIR=/data/media/0

TIMEOUT /T 2 /NOBREAK > NUL

echo.
echo.
echo ==================================================================
echo . ��bat�滻RA��1.5��1.9/1.8.4�������������ļ�                    .
echo ==================================================================
echo .   ��ȷ���Ѱ�װRA������RA��ǰ���ڹر�״̬                       .
echo .   �벻Ҫ��װ����ra32����aarch64������RA                        .
echo .   �����ȫ�°�װ��RA��������Ҫ����һ��RA�����Զ��������Ŀ¼   .
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
echo *** �滻�У����Ժ� ...

adb push font\sarasa-ui-sc-regular.ttf /data/media/0/sarasa-ui-sc-regular.ttf

adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/switch/nxrgui.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/switch/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/xmb/monochrome/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/glui/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/ozone/bold.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/ozone/regular.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/flatui/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/retroactive/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/dot-art/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/neoactive/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/monochrome/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/systematic/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/glui/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/zarch/Roboto-Condensed.ttf

adb pull /sdcard/Android/data/com.retroarch/files/retroarch.cfg
copy /b retroarch.cfg+ra_cfg\ra_font_cfg.txt
adb push retroarch.cfg /sdcard/Android/data/com.retroarch/files/retroarch.cfg
del retroarch.cfg

adb shell chmod -R 777 /data/data/com.retroarch/*
adb shell chmod -R 777 /data/data/com.gpsp/*
adb shell chmod -R 777 /data/media/*

echo ### �滻��� .
echo ------------------------------------------

TIMEOUT /T 2 /NOBREAK > NUL
adb shell mount -o ro,remount /system
TIMEOUT /T 2 /NOBREAK > NUL
adb unroot

echo ------------------------------------------
echo ### ���й�������� .
echo ------------------------------------------

pause

::EOF