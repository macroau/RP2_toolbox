@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=Mount SD ext4 partition
::color B0
color 1F
echo Starting ... ������ ...
.\ConSetBuffer.exe /Y=9999


set MOUNT_DATA=0
set MOUNT_APP=0

echo ============================================================
echo + ��bat�ű���������ҪRP2�ѳɹ���װBusyBox��                +
echo +                                 -------                  +
echo + ȷ��������� ��ȷ����ֱ�ӹرգ�                          +
echo ============================================================
echo.

pause

echo.
echo.
echo ==================================================================
echo + �����ⲿSD��ext4�����ű� V1.2               20200930           +
echo ==================================================================
echo +   ��������ű���������SD����ext4������ /data/media��/data/data +
echo + �� /data/app ��                                                +
echo +                                                                +
echo +   ����ѡ�����һ�������� /data/media�����߹�������������       +
echo + /data/media �� /data/data�� ���߹������������� /data/media��   +
echo + /data/data �� /data/app��                                      +
echo +                                                                +
echo +   ֻ����һ�������� /data/media ʱ����2������������ext4������   +
echo + �������������� /data/media �� /data/data ʱ����2��3������      +
echo + ������ext4���������߹������������� /data/media��/data/data     +
echo + �� /data/app ʱ����2��3��4������������ext4������               +
echo +                                                                +
echo +  ���ۺ������SD���ĵ�1�������������¹�ϵͳ����ʶ���exFat������+
echo + exFat������á���ҪС��40GB�������ڹ��ص�ÿ��ext4������þ�    +
echo + ����ҪС��8GB�����Ҷ���������������                            +
echo +   ��2�������������ص� /data/media����3�������������Ҫ������   +
echo + ���ص� /data/data����4�������������Ҫ�����ص� /data/app ��    +
echo ==================================================================
echo.

pause

echo.
echo.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !��ע�⡿                                          !
echo !                                                  !
echo !   ��Ϊ�ű�ִ�����������������ݵķ��գ�         !
echo ! ��һ����ǰ���ݻ�����SD������Ҫ���ݣ�             !
echo !                                                  !
echo !   ���нű�ǰ�������RP2һ�Ρ�                    !
echo !                                                  !
echo !   ���б��ű�ǰ��RP2�����ѳɹ���װBusyBox�����䣡 !
echo !                                                  !
echo !   �뱣֤����SD��ext4�����ռ����(����С��8GB)��  !
echo ! �ռ䲻�����ɺ����ű�����ʧ�ܣ�                 !
echo !   ע��ext4�������ݽ��ᱻɾ����                   !
echo !                                                  !
echo !   ���ű��������ԡ��ظ����У���һ�����к�       !
echo ! �ڶ������п��ܻ�������ݶ�ʧ��                   !
echo !                                                  !
echo !   �ű����߲��е��ű���������ɵ��κ���ʧ��       !
echo !                                                  !
echo ! ���������������ʾ���ܣ�                         !
echo ! �����ܿ��� ֱ�ӹرձ����� �˳���                 !
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo.
echo.

pause

echo.
echo.
echo ---------------------------------------------------------------
echo + ѡ�񷽰�                                                    +
echo +                                                             +
echo +  1. ֻ����/data/media����2��������ext4��ʽ                  +
echo +  2. ����/data/media��/data/data����2��3��������ext4��ʽ     +
echo +  3. ����/data/media��/data/data��/data/app����2��3��4������ +
echo +     ��ext4��ʽ���˷���Ӱ������app���ٶȽ϶�                 +
echo +  9. ����RP2                                                 +
echo +                                                             +
echo + �������ֺ�س���                                            +
echo ---------------------------------------------------------------
set userinput1=NA
set /p userinput1=�û����룺

if "%userinput1%"=="1" (
set MOUNT_DATA=0
set MOUNT_APP=0
echo ------------------------------------------------------------
echo + ѡ���ˣ�                                                 +
echo +  1. ֻ����/data/media����2��������ext4��ʽ               +
echo ------------------------------------------------------------
goto start
)

if "%userinput1%"=="2" (
set MOUNT_DATA=1
set MOUNT_APP=0
echo ------------------------------------------------------------
echo + ѡ���ˣ�                                                 +
echo +  2. ����/data/media��/data/data����2��3��������ext4��ʽ  +
echo ------------------------------------------------------------
goto start
)

if "%userinput1%"=="3" (
set MOUNT_DATA=1
set MOUNT_APP=1
echo ---------------------------------------------------------------
echo + ѡ���ˣ�                                                    +
echo +  3. ����/data/media��/data/data��/data/app����2��3��4������ +
echo +     ��ext4��ʽ                                              +
echo ---------------------------------------------------------------
goto start
)

if "%userinput1%"=="9" (
echo [[[ ��������RP2�� ]]]
adb shell sync
adb reboot
goto exit
)

goto exit

:start

TIMEOUT /T 2 /NOBREAK > NUL

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
echo + ��һ�� ��Ҫ���� ��                                       +
echo ------------------------------------------------------------
echo.
echo.

pause

set PART_NO=2
set DEV_NAME=/dev/block/mmcblk1p2
set INN_DIR=/data/media

CALL :work_prog

if "%MOUNT_DATA%"=="0" (
echo.
echo --------------------------------------------
echo + ����Ҫ���� /data/data �� /data/app��     +
echo --------------------------------------------
echo.
echo.
goto fin
)

set PART_NO=3
set DEV_NAME=/dev/block/mmcblk1p3
set INN_DIR=/data/data

CALL :work_prog

if "%MOUNT_APP%"=="0" (
echo.
echo --------------------------------------------
echo + ����Ҫ���� /data/app��                   +
echo --------------------------------------------
echo.
echo.
goto fin
)

set PART_NO=4
set DEV_NAME=/dev/block/mmcblk1p4
set INN_DIR=/data/app

CALL :work_prog

:fin

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

echo.
echo ============================================
echo + ���� RP2 ...                             +
echo ============================================
echo.

adb shell sync
adb reboot

:exit

pause

:: �˳�������
EXIT /B %ERRORLEVEL%

:work_prog

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::set PART_NO=?
::set DEV_NAME=/dev/block/mmcblk1p?
::set INN_DIR=/data/?

echo.
echo.
echo --------------------------------------------
echo + ����SD���� %PART_NO% ��������ext4��ʽ��          +
echo + �����豸���� %DEV_NAME%        +
echo --------------------------------------------
echo.
echo.

adb shell mke2fs -t ext4 -F %DEV_NAME%
adb shell mkdir /data/tempmnt
adb shell mount -o rw -t ext4 %DEV_NAME% /data/tempmnt

echo.
echo --------------------------------------------
echo +  ������������벻Ҫ����������          +
echo --------------------------------------------
echo.

pause

echo.
echo.
echo --------------------------------------------------------
echo + ���� %INN_DIR% Ŀ¼�µ����� �� �� %PART_NO% ��������       +
echo + �� %PART_NO% �����������ݽ��������                          +
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...                   +
echo --------------------------------------------------------
echo.
echo.

adb shell rm -rf /data/tempmnt/*
::adb shell "(cd %INN_DIR%; tar -cf - . ) | tar -xf - -C /data/tempmnt"   ->����ʧ��
::adb shell cp -ar %INN_DIR%/* /data/tempmnt/
adb shell "(cd %INN_DIR%; busybox tar -cf - . ) | busybox tar -xf - -C /data/tempmnt"
adb shell umount /data/tempmnt
adb shell rmdir /data/tempmnt

echo.
echo --------------------------------------------
echo + ������ɣ��������Ĺ����Ƿ��г�����Ϣ�� +
echo --------------------------------------------
echo.
echo.

pause

echo.
echo.
echo --------------------------------------------
echo +   �Ƿ�ɾ��ԭ %INN_DIR% Ŀ¼�µ����� (�з���!!!!) +
echo + ���ͷ��ڲ��洢�ռ䣿                     +
echo +   �����Ҫɾ���������д�� YES ���س���  +
echo + ����ֱ�ӻس�������                       +
echo --------------------------------------------
set uinput=NA
set /p uinput=�û����룺

if "%uinput%"=="YES" (
echo.
echo --------------------------------------------
echo + ɾ��ԭ %INN_DIR% Ŀ¼�µ����� ...        +
echo --------------------------------------------
echo.

adb shell rm -rf %INN_DIR%/*

echo.
echo --------------------------------------------
echo + ɾ����ɣ��������Ĺ����Ƿ��г�����Ϣ�� +
echo --------------------------------------------
echo.
echo.

pause
)


echo.
echo.
echo --------------------------------------------
echo + �� /system/bin/boot.sh ��ӵ� %PART_NO% �������Ĺ������� ... +
echo --------------------------------------------
echo.
echo.

::����/system/bin/boot.sh
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak"
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.`date +%%y%%m%%d_%%H%%M`"

::��ʼ�޸�
adb shell "echo >> /system/bin/boot.sh"
adb shell "echo >> /system/bin/boot.sh"
adb shell "echo 'mount -o rw -t ext4 %DEV_NAME% %INN_DIR%' >> /system/bin/boot.sh"

echo.
echo --------------------------------------------
echo + ������ɣ�                               +
echo --------------------------------------------
echo.

pause

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
EXIT /B 0

::EOF