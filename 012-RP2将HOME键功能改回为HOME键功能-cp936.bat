@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=Change HOME back to HOME
color B0
::color 1F
echo Starting ... ������ ...
.\ConSetBuffer.exe /Y=9999


echo.
echo ============================================================
echo + ��bat�ű����޸������ļ�                                  +
echo +   /system/usr/keylayout/Vendor_2020_Product_0111.kl      +
echo + �Խ� HOME �����ܸĻ�Ϊ ��HOME������                      +
echo +                                                          +
echo +   ��bat�ű�����ǰ����Ҫ�ȳɹ���װBusyBox��               +
echo +                                  -------                 +
echo + ȷ���������������رմ��ڣ�                             +
echo ============================================================
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo + �����г���׿�豸 ...                                     +
echo ------------------------------------------------------------
echo.

adb devices

echo.
echo ------------------------------------------------------------
echo + �������û�гɹ��г���ȷ�İ�׿�豸��                     +
echo + ��һ�� ��Ҫ������ �� ֱ�ӹرձ����� �˳���               +
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo + ��ִ�� adb root ...                                      +
echo ------------------------------------------------------------
echo.
echo.

TIMEOUT /T 2 /NOBREAK > NUL
adb root
TIMEOUT /T 2 /NOBREAK > NUL
adb remount

echo.
echo ------------------------------------------------------------
echo + �������adb root��adb remountû�гɹ���                  +
echo + ��һ�� ��Ҫ������ �� ֱ�ӹرձ����� �˳���               +
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo ------------------------------------------------------------
echo + �޸� /system/usr/keylayout/Vendor_2020_Product_0111.kl   +
echo ------------------------------------------------------------
echo.

::�޸�
adb shell "busybox sed -i 's/^key 0x66 \+[A-Z]\+ *$/key 0x66  HOME/' /system/usr/keylayout/Vendor_2020_Product_0111.kl"

echo.
echo --------------------------------------------
echo + �޸���� ��                              +
echo --------------------------------------------
echo.
echo.
echo ==================================================
echo + ���й�������ɣ����Իع���Ļ������޴�����Ϣ�� +
echo + ����������Զ�����RP2����ʹ���޸� HOME�� ����  +
echo + �Ļ�Ϊ ��HOME���� ��Ч��                       +
echo ==================================================
echo.
echo.

pause

adb shell sync
adb reboot

echo.
echo.
echo --------------------------------------------
echo +   ���� RP2 ...                           +
echo --------------------------------------------
echo.
echo.

pause

::EOF