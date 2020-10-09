@echo off
chcp 65001 > NUL
mode con cols=120 lines=30
title=REPLACE RA FONT
bin\ConSetBuffer.exe /Y=9999

echo Starting ... 启动中 ...

set FONT_DIR=font
set FONT_FILE=sarasa-ui-sc-regular.ttf
set RP2_FONT_DIR=/data/media/0

TIMEOUT /T 2 /NOBREAK > NUL

echo.
echo.
echo ==================================================================
echo . 本bat替换RA（1.5和1.9）的中文字体文件                          .
echo ==================================================================
echo .   请确认已安装RA，并且RA当前处于关闭状态                       .
echo .   请不要安装带有ra32或者aarch64字样的RA                        .
echo .   如果是全新安装的RA，可能需要启动一次RA，以自动建立相关目录   .
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
echo *** 替换中，请稍候 ...

adb push font\sarasa-ui-sc-regular.ttf /data/media/0/sarasa-ui-sc-regular.ttf

adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/switch/nxrgui.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/switch/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/xmb/monochrome/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/glui/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/ozone/bold.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.retroarch/assets/ozone/regular.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/flatui/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/retroactive/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/dot-art/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/neoactive/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/monochrome/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/xmb/systematic/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/glui/font.ttf
adb shell cp /data/media/0/sarasa-ui-sc-regular.ttf /data/data/com.gpsp/assets/zarch/Roboto-Condensed.ttf

adb shell chmod 777 /data/data/com.retroarch/assets/switch/nxrgui.ttf
adb shell chmod 777 /data/data/com.retroarch/assets/switch/font.ttf
adb shell chmod 777 /data/data/com.retroarch/assets/xmb/monochrome/font.ttf
adb shell chmod 777 /data/data/com.retroarch/assets/glui/font.ttf
adb shell chmod 777 /data/data/com.retroarch/assets/ozone/bold.ttf
adb shell chmod 777 /data/data/com.retroarch/assets/ozone/regular.ttf
adb shell chmod 777 /data/data/com.gpsp/assets/xmb/flatui/font.ttf
adb shell chmod 777 /data/data/com.gpsp/assets/xmb/retroactive/font.ttf
adb shell chmod 777 /data/data/com.gpsp/assets/xmb/dot-art/font.ttf
adb shell chmod 777 /data/data/com.gpsp/assets/xmb/neoactive/font.ttf
adb shell chmod 777 /data/data/com.gpsp/assets/xmb/monochrome/font.ttf
adb shell chmod 777 /data/data/com.gpsp/assets/xmb/systematic/font.ttf
adb shell chmod 777 /data/data/com.gpsp/assets/glui/font.ttf
adb shell chmod 777 /data/data/com.gpsp/assets/zarch/Roboto-Condensed.ttf

adb pull /sdcard/Android/data/com.retroarch/files/retroarch.cfg
copy /b retroarch.cfg+ra_cfg\ra_font_cfg.txt
adb push retroarch.cfg /sdcard/Android/data/com.retroarch/files/retroarch.cfg
del retroarch.cfg

echo ### 替换完成 .
echo ------------------------------------------

TIMEOUT /T 2 /NOBREAK > NUL
adb shell mount -o ro,remount /system
TIMEOUT /T 2 /NOBREAK > NUL
adb unroot

echo ------------------------------------------
echo ### 所有工作已完成 .
echo ------------------------------------------

pause

::EOF