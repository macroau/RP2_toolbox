@echo off
chcp 65001 > NUL
mode con cols=120 lines=30
title=RESTORE RA
bin\ConSetBuffer.exe /Y=9999

echo Starting ... 启动中 ...

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
echo . 本bat将【恢复】RA1.9的全部设置                                 .
echo ==================================================================
echo .   请确保已经安装了RA1.9，并保证RA是已关闭状态                  .
echo .   按任意键开始 ...      （需要ADB）                            .
echo ==================================================================
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo . 尝试列出安卓设备 ...                                     .
echo ------------------------------------------------------------
echo.

adb devices

echo.
echo ------------------------------------------------------------
echo . 如果上面没有成功列出正确的安卓设备，                     .
echo . 请一定 不要继续， 可 直接关闭本窗口 退出！               .
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo . 将执行 adb root ...                                      .
echo ------------------------------------------------------------
echo.
echo.

TIMEOUT /T 2 /NOBREAK > NUL
adb root
TIMEOUT /T 2 /NOBREAK > NUL
adb remount

echo.
echo ------------------------------------------------------------
echo . 如果上面adb root或adb remount没有成功，                  .
echo . 请一定 不要继续 ！                                       .
echo ------------------------------------------------------------
echo.
echo.

pause

echo ------------------------------------------
echo *** 安装Busybox ...
adb push %BB_FILENAME% /system/xbin/busybox
adb shell chmod a+x /system/xbin/busybox

echo ------------------------------------------
echo *** 推送压缩包 %EXT_DATA_FILE% ...
adb push %LOCAL_FILE_DIR%\%EXT_DATA_FILE% %TF_ROOT%/
echo ### 推送完成 .
echo ------
echo *** 解压缩 ...
adb shell "busybox tar zxf %TF_ROOT%/%EXT_DATA_FILE% -C %EXT_DATA_DIR%/"
echo ### 解压缩完成 .
echo ------
echo *** 检查TF卡上的RA数据占用的空间 ...
adb shell "du -h -d 1 %EXT_DATA_DIR%/RetroArch | grep '/RetroArch$'"
adb shell rm %TF_ROOT%/%EXT_DATA_FILE%
echo.

echo ------------------------------------------
echo *** 推送压缩包 %INT_DATA_MEDIA_FILE% ...
adb push %LOCAL_FILE_DIR%\%INT_DATA_MEDIA_FILE% %TF_ROOT%/ 
echo ### 推送完成 .
echo ------
echo *** 解压缩 ...
adb shell "busybox tar zxmof %TF_ROOT%/%INT_DATA_MEDIA_FILE% -C %INT_DATA_MEDIA_DIR%/;chmod 777 /data/media -R;"
echo ### 解压缩完成 .
echo ------
echo *** 检查内部存储中RA数据占用的空间-1 ...
adb shell "du -h -d 1 %INT_DATA_MEDIA_DIR%/RetroArch | grep '/RetroArch$'"
adb shell rm %TF_ROOT%/%INT_DATA_MEDIA_FILE%
echo.

echo ------------------------------------------
echo *** 推送压缩包 %INT_DATA_DATA_FILE% ...
adb push %LOCAL_FILE_DIR%\%INT_DATA_DATA_FILE%  %TF_ROOT%/
echo ### 推送完成 .
echo ------
echo *** 解压缩 ...
adb shell "uid=$(ls -ld %INT_DATA_DATA_DIR%/%INT_DATA_DATA_PKG% | cut -d ' ' -f 2);busybox tar zxmof %TF_ROOT%/%INT_DATA_DATA_FILE% -C %INT_DATA_DATA_DIR%/;chown $uid:$uid %INT_DATA_DATA_DIR%/%INT_DATA_DATA_PKG% -R"
echo ### 解压缩完成 .
echo ------
echo *** 检查内部存储中RA数据占用的空间-2 ...
adb shell "du -h -d 1 %INT_DATA_DATA_DIR%/com.retroarch | grep '/com.retroarch$'"
adb shell rm %TF_ROOT%/%INT_DATA_DATA_FILE%
echo.

echo ------------------------------------------
echo *** 推送压缩包 %INT_DATA_MEDIA_ANDR_FILE% ...
adb push %LOCAL_FILE_DIR%\%INT_DATA_MEDIA_ANDR_FILE%  %TF_ROOT%/
echo ### 推送完成 .
echo ------
echo *** 解压缩 ...
adb shell "busybox tar zxmof %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE% -C %INT_DATA_MEDIA_ANDR_DIR%/;chmod 777 /data/media -R;"
echo ### 解压缩完成 .
echo ------
echo *** 检查内部存储中RA数据占用的空间-3 ...
adb shell "du -h -d 1 %INT_DATA_MEDIA_ANDR_DIR%/com.retroarch | grep '/com.retroarch$'"
adb shell rm %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE%
echo.

echo ------------------------------------------

TIMEOUT /T 2 /NOBREAK > NUL
adb shell mount -o ro,remount /system
TIMEOUT /T 2 /NOBREAK > NUL
adb unroot

echo ------------------------------------------
echo ### 所有工作已完成 .
echo ### 已恢复RA的全套设置 .
echo ------------------------------------------

pause

::EOF