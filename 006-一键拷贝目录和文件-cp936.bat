@echo off
chcp 936 > NUL
title=FILES and DIRS copy
bin\ConSetBuffer.exe /Y=9999

echo Starting ... 启动中 ...


set TEMP_FILE=/sdcard/adb_temp_file
set DIR=adbfiles
:: ADB_DIR是RP2上的目标文件夹，不可以含中文
set ADB_DIR=/sdcard/temp

if '%1' neq '' (
set ADB_DIR=%1
) 

echo.
echo ------------------------------------------------------------
echo .   本脚本将会拷贝当前目录下的 %DIR% 子目录下的文件，以及 .
echo . 其子目录下的文件到RP2的 %ADB_DIR% 目录下   .
echo ------------------------------------------------------------

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

adb shell "mkdir -p '%ADB_DIR%'"
if %ERRORLEVEL% neq 0 (
echo ERRORLEVEL: %ERRORLEVEL%
goto exit
)

echo.
echo ------------------------------------------------------------
echo . 开始传输文件，请稍候 ...                            
echo ------------------------------------------------------------
echo.

cd %DIR%
if %ERRORLEVEL% neq 0 (
echo ERRORLEVEL: %ERRORLEVEL%
goto exit
)

for %%j in (*) do ( 
echo *** 开始传输 %%j ，请稍后 ...

adb push "%%j" %TEMP_FILE%

echo *** 传输完毕，开始安装，请稍后 ...

adb shell "mv %TEMP_FILE% %ADB_DIR%/'%%j'"

echo ### 安装完成 .
echo.
)

cd..

echo.
echo ------------------------------------------------------------
echo . 开始推送子文件夹，请稍候                                .
echo ------------------------------------------------------------
echo.

cd %DIR%
if %ERRORLEVEL% neq 0 (
echo ERRORLEVEL: %ERRORLEVEL%
goto exit
)

for /d %%i in (*) do (
echo *** 在RP2建立文件夹： %ADB_DIR%/%%i ...
adb shell "mkdir -p %ADB_DIR%/'%%i'"
echo ### 建立完毕 .
echo ----
echo.
echo.

cd %%i

for %%j in (*) do ( 
echo *** 开始推送子目录中的文件： %%j ...
echo *** 可能需要一点时间，推送文件需要的时间取决于OBB文件的大小，请耐心等待 ...
adb push "%%j" %TEMP_FILE%
adb shell "mv %TEMP_FILE% %ADB_DIR%/'%%j'"

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
echo . 拷贝完成！   按任意键退出，或直接关闭窗口。    .
echo ==================================================
echo.

:exit

pause

::EOF