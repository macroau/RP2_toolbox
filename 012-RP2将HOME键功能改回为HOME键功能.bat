@echo off
chcp 65001 > NUL
mode con cols=80 lines=85
title=Change HOME back to HOME
color B0
::color 1F
echo Starting ... 启动中 ...
.\ConSetBuffer.exe /Y=9999

echo.
echo ============================================================
echo + 本bat脚本将修改如下文件                                  +
echo +   /system/usr/keylayout/Vendor_2020_Product_0111.kl      +
echo + 以将 HOME 键功能改回为 【HOME键】。                      +
echo +                                                          +
echo +   本bat脚本运行前，需要先成功安装BusyBox！               +
echo +                                  -------                 +
echo + 确定请继续，否则请关闭窗口！                             +
echo ============================================================
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo + 尝试列出安卓设备 ...                                     +
echo ------------------------------------------------------------
echo.

adb devices

echo.
echo ------------------------------------------------------------
echo + 如果上面没有成功列出正确的安卓设备，                     +
echo + 请一定 不要继续， 可 直接关闭本窗口 退出！               +
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo.
echo ------------------------------------------------------------
echo + 将执行 adb root ...                                      +
echo ------------------------------------------------------------
echo.
echo.

TIMEOUT /T 2 /NOBREAK > NUL
adb root
TIMEOUT /T 2 /NOBREAK > NUL
adb remount

echo.
echo ------------------------------------------------------------
echo + 如果上面adb root或adb remount没有成功，                  +
echo + 请一定 不要继续， 可 直接关闭本窗口 退出！               +
echo ------------------------------------------------------------
echo.
echo.

pause

echo.
echo ------------------------------------------------------------
echo + 修改 /system/usr/keylayout/Vendor_2020_Product_0111.kl   +
echo ------------------------------------------------------------
echo.

::修改
adb shell "busybox sed -i 's/^key 0x66 \+[A-Z]\+ *$/key 0x66  HOME/' /system/usr/keylayout/Vendor_2020_Product_0111.kl"

echo.
echo --------------------------------------------
echo + 修改完成 ！                              +
echo --------------------------------------------
echo.
echo.
echo ==================================================
echo + 所有工作已完成，可以回滚屏幕检查有无错误信息。 +
echo + 按任意键将自动重启RP2，以使得修改 HOME键 功能  +
echo + 改回为 【HOME键】 生效。                       +
echo ==================================================
echo.
echo.

pause

adb reboot

echo.
echo.
echo --------------------------------------------
echo +   重启 RP2 ...                           +
echo --------------------------------------------
echo.
echo.

pause

::EOF