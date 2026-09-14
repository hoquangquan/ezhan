@echo off
chcp 65001 >nul
title ESATECH - Trich Xuat Log Navigation Debug AGV E300
cls

echo ======================================================================
echo          ESATECH - TRICH XUAT LOG DIEU HUONG TU XE AGV E300
echo ======================================================================
echo.

set "ADB_DIR=C:\Users\Admin\Downloads\EZHAN\EZHAN\Update\Update\Operating Documentation\platform-tools\platform-tools\adb"
set "PATH=%ADB_DIR%;%PATH%"

set "LOCAL_LOG_DIR=%~dp0logs"
if not exist "%LOCAL_LOG_DIR%" mkdir "%LOCAL_LOG_DIR%"

echo [1/4] Kiem tra ket noi voi xe AGV qua cong USB...
adb devices
echo.

echo [2/4] Xin quyen he thong tren xe [adb root]...
adb root
echo.

echo [3/4] Dang keo log navigation_debug tu xe AGV ve may tinh...
adb pull /storage/emulated/0/Android/data/com.ezhan.amr/files/navigation_debug/ "%LOCAL_LOG_DIR%"

if %errorlevel% equ 0 goto :SUCCESS
goto :FAILED

:SUCCESS
echo.
echo ======================================================================
echo [THANH CONG] Da keo toan bo log navigation_debug ve may tinh!
echo Thu muc luu: %LOCAL_LOG_DIR%
echo.
echo [4/4] Dang tu dong mo thu muc logs...
echo ======================================================================
explorer "%LOCAL_LOG_DIR%"
echo.
echo CAC BUOC TIEP THEO:
echo 1. Nen thu muc navigation_debug thanh file .zip
echo 2. Gui file .zip nay truc tiep cho winwin
echo ======================================================================
goto :DONE

:FAILED
echo.
echo ======================================================================
echo [CHUA KEO DUOC LOG - CHUA NHAN XE]
echo List of devices attached dang bi trong!
echo.
echo NGUYEN NHAN VA HUONG XU LY:
echo 1. Kiem tra cap USB da cam chac chan giua may tinh va man hinh xe AGV.
echo 2. Tren man hinh xe AGV: Vao Settings - Accessibility
echo    - Chuyen "OTG to USB switch" sang OFF [Bat buoc phai OFF de nhan PC].
echo 3. Neu tren man hinh xe hien hop thoai "Allow USB Debugging?", hay bam OK.
echo ======================================================================
goto :DONE

:DONE
echo.
pause
