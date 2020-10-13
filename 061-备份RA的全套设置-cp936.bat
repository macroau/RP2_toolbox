@echo off
chcp 936 > NUL
mode con cols=120 lines=30
title=BAK RA
bin\ConSetBuffer.exe /Y=9999

echo Starting ... 启动中 ...

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
echo . 本bat将备份RA1.9的全部设置                                     .
echo ==================================================================
echo .   备份过程会排除某些可能没有必要备份的文件和目录               .
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

md %LOCAL_FILE_DIR%

echo ------------------------------------------
echo *** 检查TF卡上的RA数据占用的空间 ...
adb shell "du -h -d 1 %EXT_DATA_DIR%/RetroArch | grep '/RetroArch$'"
echo ------
echo *** 压缩TF卡上的RA数据 ...
echo --- 排除 文件夹：cheats, logs, playlists, saves, screenshots, states, temp, thumbnails
adb shell "cd %EXT_DATA_DIR%/ ;busybox tar zcf %TF_ROOT%/%EXT_DATA_FILE% RetroArch --exclude RetroArch/cheats --exclude RetroArch/logs --exclude RetroArch/playlists --exclude RetroArch/saves --exclude RetroArch/screenshots --exclude RetroArch/states --exclude RetroArch/temp --exclude RetroArch/thumbnails"
echo ### 压缩完成 .
echo ------
adb shell busybox ls -lh %TF_ROOT%/%EXT_DATA_FILE%
echo ------
echo *** 拉取压缩包 %EXT_DATA_FILE% ...
adb pull %TF_ROOT%/%EXT_DATA_FILE% %LOCAL_FILE_DIR%
echo ### 拉取完成 .
adb shell rm %TF_ROOT%/%EXT_DATA_FILE%
echo.

echo ------------------------------------------
echo *** 检查内部存储中RA数据占用的空间-1 ...
adb shell "du -h -d 1 %INT_DATA_MEDIA_DIR%/RetroArch | grep '/RetroArch$'"
echo ------
echo *** 压缩内部存储中的RA数据-1 ...
echo --- 排除 文件夹：cheats, logs, playlists, saves, screenshots, states, temp, thumbnails
adb shell "cd %INT_DATA_MEDIA_DIR%/ ;busybox tar zcf %TF_ROOT%/%INT_DATA_MEDIA_FILE% RetroArch --exclude RetroArch/cheats --exclude RetroArch/logs --exclude RetroArch/playlists --exclude RetroArch/saves --exclude RetroArch/screenshots --exclude RetroArch/states --exclude RetroArch/temp --exclude RetroArch/thumbnails"
echo ### 压缩完成 .
echo ------
adb shell busybox ls -lh %TF_ROOT%/%INT_DATA_MEDIA_FILE%
echo ------
echo *** 拉取压缩包 %INT_DATA_MEDIA_FILE% ...
adb pull %TF_ROOT%/%INT_DATA_MEDIA_FILE% %LOCAL_FILE_DIR%
echo ### 拉取完成 .
adb shell rm %TF_ROOT%/%INT_DATA_MEDIA_FILE%
echo.

echo ------------------------------------------
echo *** 检查内部存储中RA数据占用的空间-2 ...
adb shell "du -h -d 1 %INT_DATA_DATA_DIR%/com.retroarch | grep '/com.retroarch$'"
echo ------
echo *** 压缩内部存储中的RA数据-2 ...
echo --- 排除 文件夹：cache, lib    排除 文件： *.lpl
adb shell "cd %INT_DATA_DATA_DIR%/ ;busybox tar zcf %TF_ROOT%/%INT_DATA_DATA_FILE% com.retroarch --exclude *.lpl --exclude com.retroarch/cache --exclude com.retroarch/lib"
echo ### 压缩完成 .
echo ------
adb shell busybox ls -lh %TF_ROOT%/%INT_DATA_DATA_FILE%
echo ------
echo *** 拉取压缩包 %INT_DATA_DATA_FILE% ...
adb pull %TF_ROOT%/%INT_DATA_DATA_FILE% %LOCAL_FILE_DIR%
echo ### 拉取完成 .
adb shell rm %TF_ROOT%/%INT_DATA_DATA_FILE%
echo.

echo ------------------------------------------
echo *** 检查内部存储中RA数据占用的空间-3 ...
adb shell "du -h -d 1 %INT_DATA_MEDIA_ANDR_DIR%/com.retroarch | grep '/com.retroarch$'"
echo ------
echo *** 压缩内部存储中的RA数据-3 ...
adb shell "cd %INT_DATA_MEDIA_ANDR_DIR%/ ;busybox tar zcf %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE% com.retroarch"
echo ### 压缩完成 .
echo ------
adb shell busybox ls -lh %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE%
echo ------
echo *** 拉取压缩包 %INT_DATA_MEDIA_ANDR_FILE% ...
adb pull %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE% %LOCAL_FILE_DIR%
echo ### 拉取完成 .
adb shell rm %TF_ROOT%/%INT_DATA_MEDIA_ANDR_FILE%
echo.

echo ------------------------------------------

TIMEOUT /T 2 /NOBREAK > NUL
adb shell mount -o ro,remount /system
TIMEOUT /T 2 /NOBREAK > NUL
adb unroot

echo ------------------------------------------
echo ### 所有工作已完成 .
echo ### 共拉取4个文件，
echo ### %EXT_DATA_FILE%
echo ### %INT_DATA_MEDIA_FILE%
echo ### %INT_DATA_DATA_FILE%
echo ### %INT_DATA_MEDIA_ANDR_FILE%
echo ------------------------------------------
dir %LOCAL_FILE_DIR%
echo ------------------------------------------

pause

::EOF