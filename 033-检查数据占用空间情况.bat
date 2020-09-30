@echo off
chcp 65001 > NUL
mode con cols=80 lines=85
title=检查数据占用空间情况
::color B0
color 1F
echo Starting ... 启动中 ...

echo.
echo.
adb shell df /data/media /data/data /data/app
echo.
echo.

echo ------------------------------------------------------
echo + Used 一列是数据占用的空间。                        +
echo ------------------------------------------------------
echo.
echo.

echo.
echo.
TIMEOUT /T 2 /NOBREAK > NUL
adb shell df /data
echo.
echo.

echo ------------------------------------------------------
echo + Free 一列是内部存储器的剩余空间。                  +
echo + 如果要将各挂载点文件中的数据恢复到内部存储器，     +
echo + 需要确定内部存储器的剩余空间足够！                 +
echo ------------------------------------------------------
echo.
echo.

pause