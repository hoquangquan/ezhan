@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ======================================================================
echo    ESATECH - XUAT FILE PDF SO TAY XU LY SU CO AGV E300
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

:: Lay duong dan tuyet doi dang file URL
set "HTML_FILE=%~dp0So_Tay_Xu_Ly_Su_Co_AGV_E300.html"
set "PDF_FILE=%~dp0So_Tay_Xu_Ly_Su_Co_AGV_E300.pdf"

echo Dang chuyen doi:
echo    Nguon: %HTML_FILE%
echo    Dich:  %PDF_FILE%

"%EDGE_PATH%" --headless --disable-gpu --run-all-compositor-stages-before-draw --no-pdf-header-footer --print-to-pdf="%PDF_FILE%" "%HTML_FILE%"

if exist "%PDF_FILE%" (
    echo ======================================================================
    echo [THANH CONG] Da xuat thanh cong file PDF!
    echo Vi tri file: %PDF_FILE%
    echo ======================================================================
) else (
    echo [LOI] Chua tao duoc file PDF.
)
timeout /t 5
