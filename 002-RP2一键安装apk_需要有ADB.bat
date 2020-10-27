@echo off
chcp 65001 > NUL
mode con cols=120 lines=30
title=ADB install apk
::color B0
color 20
echo Starting ... 启动中 ...

set TEMP_FILE=/storage/sdcard0/adb_install_apk_temp.apk

::set TEMP=%1
::set "TEMP=%TEMP: =%" 
::if "%TEMP%"=="" goto exit
echo "%1" | findstr /c:APK /i > NUL

if errorlevel 1 (
  echo. Need apk file.
  echo . 请把需要安装的apk文件拖放到这个bat批处理文件上！  .
  goto exit
) ELSE (
  echo. OK!
)


echo.
echo ==================================================
echo . 将安装 %1 ... 
echo ==================================================
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

adb push %1 %TEMP_FILE%

echo *** 传输完毕，开始安装，请稍后 ...

adb shell pm install -r %TEMP_FILE%
adb shell rm %TEMP_FILE%

echo.
echo ==================================================
echo . 安装完成！   按任意键退出，或直接关闭窗口。    .
echo ==================================================
echo.

:exit

pause

::EOF