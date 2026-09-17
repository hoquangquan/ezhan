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

:: Tu dong tao thu muc anh va sao chep anh chup thuc te MOXA
if not exist "%~dp0images" mkdir "%~dp0images"
if exist "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789638793774.png" (
    copy /y "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789638793774.png" "%~dp0images\moxa_step0_home.png" >nul
)
if exist "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789638953516.png" (
    copy /y "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789638953516.png" "%~dp0images\moxa_step1_ip.png" >nul
)
if exist "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789638998506.png" (
    copy /y "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789638998506.png" "%~dp0images\moxa_step2_wifi.png" >nul
)
if exist "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789639397244.png" (
    copy /y "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789639397244.png" "%~dp0images\moxa_step2_detail.png" >nul
)
if exist "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789639661654.png" (
    copy /y "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789639661654.png" "%~dp0images\moxa_step2_security.png" >nul
)
if exist "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789639845878.png" (
    copy /y "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789639845878.png" "%~dp0images\moxa_step2_roaming.png" >nul
)
if exist "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789640562164.png" (
    copy /y "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789640562164.png" "%~dp0images\moxa_step3_serial.png" >nul
)
if exist "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789640714596.png" (
    copy /y "C:\Users\Admin\.gemini\antigravity-ide\brain\b2b9aca2-e98c-4a50-8269-76e032b553a2\.user_uploaded\media_1789640714596.png" "%~dp0images\moxa_step4_review.png" >nul
)

:: 1. Xuat file Huong Dan Ket Noi Va Tao Ban Do
echo.
echo [1/3] Dang xuat: Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf ...
"%EDGE_PATH%" --headless --disable-gpu --allow-file-access-from-files --run-all-compositor-stages-before-draw --no-pdf-header-footer --print-to-pdf="%~dp0Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf" "%~dp0Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.html"
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
