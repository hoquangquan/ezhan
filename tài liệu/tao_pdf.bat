@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ======================================================================
echo    ESATECH - XUAT FILE PDF TAI LIEU ROBOT AGV E300 & CALLBOX
echo ======================================================================
echo Dang khoi chay trinh xuat PDF...

set "EDGE_PATH=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE_PATH%" (
    set "EDGE_PATH=C:\Program Files\Microsoft\Edge\Application\msedge.exe"
)

if not exist "%EDGE_PATH%" (
    echo [LOI] Khong tim thay trinh duyet Microsoft Edge tai duong dan tieu chuan.
    pause
    exit /b 1
)

:: 1. Xuat file Huong Dan Ket Noi Va Tao Ban Do
echo.
echo [1/2] Dang xuat: Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf ...
"%EDGE_PATH%" --headless --disable-gpu --run-all-compositor-stages-before-draw --no-pdf-header-footer --print-to-pdf="%~dp0Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf" "%~dp0Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.html"
if exist "%~dp0Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf" (
    echo    -^> [THANH CONG] Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf
) else (
    echo    -^> [LOI] Khong the tao file Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf
)

:: 2. Xuat file So Tay Xu Ly Su Co
echo.
echo [2/3] Dang xuat: So_Tay_Xu_Ly_Su_Co_AGV_E300.pdf ...
"%EDGE_PATH%" --headless --disable-gpu --run-all-compositor-stages-before-draw --no-pdf-header-footer --print-to-pdf="%~dp0So_Tay_Xu_Ly_Su_Co_AGV_E300.pdf" "%~dp0So_Tay_Xu_Ly_Su_Co_AGV_E300.html"
if exist "%~dp0So_Tay_Xu_Ly_Su_Co_AGV_E300.pdf" (
    echo    -^> [THANH CONG] So_Tay_Xu_Ly_Su_Co_AGV_E300.pdf
) else (
    echo    -^> [LOI] Khong the tao file So_Tay_Xu_Ly_Su_Co_AGV_E300.pdf
)

:: 3. Xuat file Ban Ve Kich Thuoc Hinh Hoc
echo.
echo [3/3] Dang xuat: Ban_Ve_Kich_Thuoc_Hinh_Hoc_AGV_E300.pdf ...
"%EDGE_PATH%" --headless --disable-gpu --run-all-compositor-stages-before-draw --no-pdf-header-footer --print-to-pdf="%~dp0Ban_Ve_Kich_Thuoc_Hinh_Hoc_AGV_E300.pdf" "%~dp0Ban_Ve_Kich_Thuoc_Hinh_Hoc_AGV_E300.html"
if exist "%~dp0Ban_Ve_Kich_Thuoc_Hinh_Hoc_AGV_E300.pdf" (
    echo    -^> [THANH CONG] Ban_Ve_Kich_Thuoc_Hinh_Hoc_AGV_E300.pdf
) else (
    echo    -^> [LOI] Khong the tao file Ban_Ve_Kich_Thuoc_Hinh_Hoc_AGV_E300.pdf
)

echo.
echo ======================================================================
echo    HOAN TAT XUAT CAC FILE PDF!
echo ======================================================================
timeout /t 5
