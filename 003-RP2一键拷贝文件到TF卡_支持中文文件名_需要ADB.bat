@echo off
chcp 65001 > NUL
mode con cols=120 lines=30
title=ADB COPY

echo Starting ... 启动中 ...

if '%1'=='' (
echo .  将需要拷贝的文件拖放到这个批处理上面  .
goto exit
)

set FILENAME=%~n1%~x1
set FILENAME_EXT=%~x1

:: RP2上的目标目录，如不存在会自动建立，可更改 ...
set TF_ROOT=/sdcard/RetroArch/assets/xmb/monochrome/png
:: ------------------------------- 

::set TEMP_FILE=adb_push_temp%FILENAME_EXT%
set TEMP_FILE=adb_push_temp_file



echo.
echo ==================================================
echo . 即将拷贝《%FILENAME%》文件到 TF卡如下目录：    .
echo .   %TF_ROOT%                                    .
echo ==================================================
echo . 本批处理脚本解决了（绕开了）                   .
echo . 直接adb push无法传输中文文件名文件的问题。     .
echo .   RP2上的目标目录可以更改为其他目录，          .
echo . 可直接修改bat文件里如下语句：                  .
echo .   set TF_ROOT=/rsdcard/Roms/000                .
echo .               -----------------为期望的目录    .
echo --------------------------------------------------
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
echo . 请一定 直接关闭本窗口 退出！                             .
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo ------------------------------------------------------------
echo . 开始传输apk并安装，请稍候                                .
echo ------------------------------------------------------------
echo.


echo *** 开始传输 "%1" ，请稍后 ...

adb shell "mkdir -p %TF_ROOT%"
adb push %1 %TF_ROOT%/%TEMP_FILE%


echo *** 传输完毕，请稍后 ...

adb shell "mv %TF_ROOT%/%TEMP_FILE% %TF_ROOT%/'%FILENAME%'"


echo.
echo ==================================================
echo . 拷贝完成！   按任意键退出，或直接关闭窗口。    .
echo ==================================================
echo.

:exit

pause

::EOF