@echo off
chcp 936 > NUL
title=APK and OBB installer
bin\ConSetBuffer.exe /Y=9999

echo Starting ... 启动中 ...

set RP2_OBB_DIR=/sdcard/Android/obb
set TEMP_FILE=/rsdcard/adb_install_apk_temp.apk
set APK_DIR=apk
set OBB_DIR=obb

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
echo . 开始传输apk并安装，请稍候 ...                            .
echo ------------------------------------------------------------
echo.

cd %APK_DIR%

for %%j in (*) do ( 
echo *** 开始传输 %%j ，请稍后 ...

adb push "%%j" %TEMP_FILE%

echo *** 传输完毕，开始安装，请稍后 ...

adb shell pm install -r %TEMP_FILE%
adb shell rm %TEMP_FILE%

echo ### 安装完成 .
echo.

)

cd..

echo.
echo ------------------------------------------------------------
echo . 开始推送OBB文件，请稍候                                .
echo ------------------------------------------------------------
echo.

cd %OBB_DIR%

for /d %%i in (*) do (
echo *** 在RP2建立文件夹： %RP2_OBB_DIR%/%%i ...
echo ### 建立完毕 .
echo ----
echo.
echo.
adb shell mkdir -p %RP2_OBB_DIR%/%%i

cd %%i

for %%j in (*) do ( 
echo *** 开始推送OBB文件： %%j ...
echo *** 可能需要一点时间，推送文件需要的时间取决于OBB文件的大小，请耐心等待 ...
adb push "%%j" %RP2_OBB_DIR%/%%i/
echo ### 推送完成 .
echo ----
echo.
echo.
)

cd ..
)

cd..

echo.
echo ==================================================
echo . 安装完成！   按任意键退出，或直接关闭窗口。    .
echo ==================================================
echo.

:exit

pause

::EOF