@echo off
chcp 65001 >nul
title ESATECH - Trich Xuat Log AGV E300 Qua Cong Mang Ethernet [LAN / IP]
cls

echo ======================================================================
echo       ESATECH - TRÍCH XUẤT LOG QUA CỔNG MẠNG ETHERNET (LAN / IP)
echo ======================================================================
echo.

set "ADB_DIR=C:\Users\Admin\Downloads\EZHAN\EZHAN\Update\Update\Operating Documentation\platform-tools\platform-tools\adb"
set "PATH=%ADB_DIR%;%PATH%"

set "LOCAL_LOG_DIR=%~dp0logs"
if not exist "%LOCAL_LOG_DIR%" mkdir "%LOCAL_LOG_DIR%"

echo [BUOC 1] Nhap dia chi IP cua xe Robot AGV:
echo (Ban co the xem dia chi IP nay tren man hinh xe hoac trang Web RCS)
echo.
set /p ROBOT_IP="Nhap dia chi IP cua Robot (vi du: 192.168.1.103): "

if "%ROBOT_IP%"=="" (
    echo [LOI] Ban chua nhap dia chi IP!
    pause
    exit /b 1
)

echo.
echo [BUOC 2] Dang ket noi ADB den Robot tai dia chi %ROBOT_IP%:5555...
adb disconnect >nul 2>nul
adb connect %ROBOT_IP%:5555

echo.
echo [BUOC 3] Kiem tra danh sach thiet bi ADB:
adb devices
echo.

echo [BUOC 4] Yeu cau quyen he thong tren xe (adb root)...
adb -s %ROBOT_IP%:5555 root
timeout /t 2 >nul
adb connect %ROBOT_IP%:5555 >nul 2>nul

echo.
echo [BUOC 5] Dang keo log navigation_debug tu xe ve may tinh qua mang Ethernet...
adb -s %ROBOT_IP%:5555 pull /storage/emulated/0/Android/data/com.ezhan.amr/files/navigation_debug/ "%LOCAL_LOG_DIR%"

if %errorlevel% equ 0 goto :SUCCESS
goto :FAILED

:SUCCESS
echo.
echo ======================================================================
echo [THANH CONG] Da keo toan bo log navigation_debug ve may tinh qua mang!
echo Thu muc luu: %LOCAL_LOG_DIR%
echo.
echo Dang tu dong mo thu muc logs...
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
echo [CHUA KEO DUOC LOG QUA MANG ETHERNET]
echo.
echo NGUYEN NHAN PHO BIEN:
echo 1. Nhap sai dia chi IP cua robot (kiem tra lai IP tren man hinh xe).
echo 2. Cong 5555 cua Android tren xe chua duoc mo qua mang.
echo.
echo GIAI PHAP CHUAN CUA HANG (WINWIN):
echo - Su dung cap USB (loai cap truyen du lieu).
echo - Tren man hinh xe: Vao Settings - Accessibility
echo   --> Gat muc "OTG to USB switch" sang OFF [Bat buoc].
echo - Chay file lay_log_navigation.bat de keo truc tiep qua USB.
echo ======================================================================
goto :DONE

:DONE
echo.
pause
