@echo off
chcp 936 > NUL
mode con cols=80 lines=30
title=Unmount SD ext4 partition
color B0
::color 1F
echo Starting ... ������ ...
.\ConSetBuffer.exe /Y=9999


echo ============================================================
echo + ��bat�ű���������ҪRP2�ѳɹ���װBusyBox��                +
echo +                                 -------                  +
echo + ȷ��������� ��ȷ����ֱ�ӹرգ�                          +
echo ============================================================
echo.

pause

:menu

echo.
echo.
echo -------------------------------------------------------
echo + ѡ��ָ��Ĺ��ص�                                    +
echo +                                                     +
echo +  1. /data/app     ^<===   /dev/block/mmcblk1p4 ����  +
echo +  2. /data/data    ^<===   /dev/block/mmcblk1p3 ����  +
echo +  3. /data/media   ^<===   /dev/block/mmcblk1p2 ����  +
echo +  9. ����RP2                                         +
echo +                                                     +
echo + �������ֺ�س��� ��ֱ�ӹرմ��ڿ����˳���           +
echo -------------------------------------------------------
set userinput1=NA
set /p userinput1=

if "%userinput1%"=="1" (
set IMG_FILE=/dev/block/mmcblk1p4
set MOUNT_POINT=/data/app
goto start
)

if "%userinput1%"=="2" (
set IMG_FILE=/dev/block/mmcblk1p3
set MOUNT_POINT=/data/data
goto start
)

if "%userinput1%"=="3" (
set IMG_FILE=/dev/block/mmcblk1p2
set MOUNT_POINT=/data/media
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

echo.
echo.
echo ============================================================
echo + �ָ�Ǩ��SD��ext4�������ݵ��ڲ��洢�ű� V1.2     20200930 +
echo ============================================================
echo +   ��bat�ű�����ȡ������SD��ext4��������Ǩ�� ext4 ������  +
echo + �����ݵ����ڲ��洢 %MOUNT_POINT% ��                      +
echo + ȡ������ǰ�� ���ص� %MOUNT_POINT% ���� %IMG_FILE% ������ +
echo ============================================================
echo.

pause

echo.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !��ע�⡿                                                !
echo !                                                        !
echo !   ��Ϊ�ű�ִ�����������������ݵķ��գ�               !
echo ! ��һ����ǰ���ݻ�����SD������Ҫ���ݣ�                   !
echo !                                                        !
echo !   �ű����й����У�RP2���Զ������������İ���            !
echo ! ������ʾ������                                         !
echo !                                                        !
echo !   ���б��ű�ǰ��RP2�����ѳɹ���װBusyBox�����䣡       ! 
echo !                                                        !
echo !   �뱣֤�ڲ��洢��ʣ��ռ���㣬ʣ��ռ�Ҫ����         !
echo ! ȡ������ǰ %MOUNT_POINT% Ŀ¼��������ռ�õĿռ䡣      !
echo ! �ڲ��洢��ʣ��ռ䲻�����ɲ���Ԥ�ƵĴ���           !
echo !                                                        !
echo !   ͬһ�����ص㡾�����ԡ��ظ��ָ����ظ��ָ��ᶪʧ���ݣ� !
echo !                                                        !
echo !   ���ű���ò�Ҫ�ظ����У�                             !
echo !                                                        !
echo !   �ű����߲��е��ű���������ɵ��κ���ʧ��             !
echo !                                                        !
echo ! ���������������ʾ���ܣ�                               !
echo ! �����ܿ��� ֱ�ӹرձ����� �˳���                       !
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo.

pause

CALL :adb_init

echo.
echo.
echo -------------------------------------------------
echo +   �����޸� /system/bin/boot.sh �ļ���ȡ��     +
echo + ���� %IMG_FILE% ������ %MOUNT_POINT% Ŀ¼�£� +
echo -------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo -------------------------------------------------
echo +   �޸� /system/bin/boot.sh �ļ���ȡ��         +
echo + ���� %IMG_FILE% ������ %MOUNT_POINT% Ŀ¼�£� +
echo -------------------------------------------------
echo.
echo.

::����/system/bin/boot.sh
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.bak"
adb shell "cp /system/bin/boot.sh /system/bin/boot.sh.`date +%%y%%m%%d_%%H%%M`"

if "%MOUNT_POINT%"=="/data/app" (
adb shell "sed -i '/mmcblk1p4 \/data\/app$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

if "%MOUNT_POINT%"=="/data/data" (
adb shell "sed -i '/mmcblk1p3 \/data\/data$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

if "%MOUNT_POINT%"=="/data/media" (
adb shell "sed -i '/mmcblk1p2 \/data\/media$/d' /system/bin/boot.sh"
goto boot_mod_fin
)

:boot_mod_fin

echo.
echo.
echo -------------------------------------------------
echo +   ����޸� /system/bin/boot.sh �ļ���ȡ��     +
echo + ���� %IMG_FILE% ������ %MOUNT_POINT% Ŀ¼�¡� +
echo + ��������Զ����� RP2 ��                       +
echo -------------------------------------------------
echo.
echo.

pause

adb shell sync
adb reboot

echo.
echo.
echo ----------------------------------------------------
echo +   ���� RP2 ...                                   +
echo +                                                  +
echo + ���������֮ǰ���벻Ҫ���������ĵȴ�RP2���      +
echo + ������                                           +
echo +                                                  +
echo +   �벻Ҫ�Ͽ�RP2��USB���ӣ�                       +
echo +                                                  +
echo +   RP2��ȫ�����󣬴�ʱ��Ҫ����RP2��������������� +
echo ----------------------------------------------------
echo.
echo.

pause

CALL :adb_init

echo.
echo.
echo --------------------------------------------
echo +   �������� %IMG_FILE% �е�����Ǩ��       +
echo + �� %MOUNT_POINT% Ŀ¼�£�                +
echo +  %MOUNT_POINT% Ŀ¼�µ��ļ����ᱻ��գ�  +
echo --------------------------------------------
echo.
echo.
echo  �������� %IMG_FILE% ���� ...
echo.

pause

adb shell mkdir /data/temp4
::adb shell mount -o rw -t ext4 %IMG_FILE% /data/temp4
adb shell mount -o ro -t ext4 %IMG_FILE% /data/temp4

echo --------------------------------------------
echo +  ������������벻Ҫ����������          +
echo --------------------------------------------
echo.

pause

echo.
echo --------------------------------------------
echo + �������� %IMG_FILE% �����е����ݵ� %MOUNT_POINT% Ŀ¼�� ... +
echo + ԭ %MOUNT_POINT% Ŀ¼�µ����ݽ���ɾ����  +
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...       +
echo --------------------------------------------
echo.

pause

echo.
echo --------------------------------------------
echo + ��ʼ���� %IMG_FILE% �����е����ݵ� %MOUNT_POINT% Ŀ¼�� ... +
echo + ԭ %MOUNT_POINT% Ŀ¼�µ����ݽ���ɾ����  +
echo + �˹�����Ҫһ��ʱ�䣬�����ĵȴ� ...       +
echo --------------------------------------------
echo.

adb shell rm -rf %MOUNT_POINT%/*
::adb shell cp -ar /data/temp4/* %MOUNT_POINT%/
adb shell "(cd /data/temp4; busybox tar -cf - . ) | busybox tar -xf - -C %MOUNT_POINT%"
adb shell umount /data/temp4
adb shell rmdir /data/temp4

echo.
echo --------------------------------------------
echo + ������� ��                              +
echo --------------------------------------------
echo.
echo.
echo ==================================================
echo + ���й�������ɣ����Իع���Ļ������޴�����Ϣ�� +
echo + ����������Զ�����RP2�������ز˵���            +
echo + ���ز˵��󣬵ȴ�RP2��ȫ�����󣬿�ѡ��Ǩ��      +
echo + �������ݡ�                                     +
echo +   ע�⣬ͬһ�����ص㲻�ɶ��λָ������λָ�     +
echo + �ᵼ�����ݶ�ʧ����һ��С��ѡ�񣬲�Ҫѡ��     +
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

goto menu


:exit
pause
:: �˳�������
EXIT /B %ERRORLEVEL%


:adb_init
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

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
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
EXIT /B 0

::EOF