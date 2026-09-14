@echo off
chcp 65001 >nul
title ESATECH - Cai Dat Cap Nhat APK E300XDY-3.3.49 cho AGV E300
cd /d "%~dp0"

echo ======================================================================
echo    ESATECH - NÂNG CẤP PHẦN MỀM AGV E300 (PHIÊN BẢN E300XDY-3.3.49)
echo ======================================================================
echo.

:: 1. Kiem tra va xu ly file APK
set "APK_NEW_RAW=%~dp0E300XDY-3.3.49(1).apk.1.1"
set "APK_NEW_CLEAN=%~dp0E300XDY-3.3.49_moi_nhat.apk"
set "APK_OLD=%~dp0E300XDY-3.3.49.apk"

if exist "%APK_NEW_RAW%" (
    if not exist "%APK_NEW_CLEAN%" (
        echo [THONG BAO] Phat hien file E300 moi them: E300XDY-3.3.49(1).apk.1.1
        echo Dang chuan hoa ten file thanh: E300XDY-3.3.49_moi_nhat.apk...
        copy /y "%APK_NEW_RAW%" "%APK_NEW_CLEAN%" >nul
        echo    -^> Chuan hoa dinh dang APK thanh cong!
        echo.
    )
)

set "APK_FILE="
if exist "%APK_NEW_CLEAN%" (
    echo CAC BAN PHAN MEM E300 HIEN CO:
    echo   [1] Ban MOI NHAT ban vua them (E300XDY-3.3.49_moi_nhat.apk) [KHUYEN DUNG]
    if exist "%APK_OLD%" (
        echo   [2] Ban truoc do trong du an (E300XDY-3.3.49.apk)
    )
    echo   [3] Thoat
    echo.
    set /p "BUILD_CHOICE=Chon ban muon cai dat [1, 2 hoac 3] (Mac dinh 1): "
    if "%BUILD_CHOICE%"=="" set BUILD_CHOICE=1
    if "%BUILD_CHOICE%"=="3" exit /b 0
    if "%BUILD_CHOICE%"=="2" (
        set "APK_FILE=%APK_OLD%"
    ) else (
        set "APK_FILE=%APK_NEW_CLEAN%"
    )
) else if exist "%APK_OLD%" (
    set "APK_FILE=%APK_OLD%"
) else (
    echo [LOI] Khong tim thay file APK nao trong thu muc:
    echo       %~dp0
    pause
    exit /b 1
)

echo [1/4] File APK duoc chon de cai dat:
echo       %APK_FILE%
echo.

:: 2. Tim kiem adb.exe
set "ADB_CMD=adb"
set "ADB_LOCAL=%~dp0Update\Update\Operating Documentation\platform-tools\platform-tools\adb\adb.exe"

if exist "%ADB_LOCAL%" (
    set "ADB_CMD=%ADB_LOCAL%"
) else (
    where adb >nul 2>nul
    if %errorlevel% neq 0 (
        echo [LOI] Khong tim thay cong cu adb.exe!
        pause
        exit /b 1
    )
)

echo [2/4] Su dung cong cu ADB tai:
echo       %ADB_CMD%
echo.

:: 3. Kiem tra ket noi voi Robot AGV
echo [3/4] Dang kiem tra ket noi voi Robot AGV...
echo.
"%ADB_CMD%" devices
echo.

:: Luu ket qua adb devices vao file tam de phan tich
"%ADB_CMD%" devices > "%TEMP%\adb_devices_check.txt"
findstr /R "device$" "%TEMP%\adb_devices_check.txt" >nul
if %errorlevel% neq 0 (
    echo ----------------------------------------------------------------------
    echo [CANH BAO] CHUA TIM THAY XE AGV KET NOI QUA CAP USB!
    echo.
    echo Vui long kiem tra 2 buoc phan cung sau:
    echo 1. Cap USB: Cam cap USB 2 dau duc (Type-A sang Type-A) noi giua PC
    echo    va cong USB o canh duoi man hinh Robot AGV.
    echo 2. Che do OTG: Tren man hinh xe vao:
    echo    Cai dat (Settings) -> Hien thi (Display) -> Bat "otgmode control"
    echo    (Chuyen sang ON theo dung huong dan cua hang de mo cong nhan ADB).
    echo ----------------------------------------------------------------------
    echo.
    echo Bam phim bat ky de kiem tra lai ket noi...
    pause >nul
    "%ADB_CMD%" devices > "%TEMP%\adb_devices_check.txt"
    findstr /R "device$" "%TEMP%\adb_devices_check.txt" >nul
    if %errorlevel% neq 0 (
        echo Van chua tim thay thiet bi. Vui long kiem tra lai day cap va thu lai sau!
        del "%TEMP%\adb_devices_check.txt" 2>nul
        pause
        exit /b 1
    )
)
del "%TEMP%\adb_devices_check.txt" 2>nul

echo    -> [THANH CONG] Xe AGV da ket noi va san sang!
echo.

:: 4. Chon phuong an cai dat
echo ======================================================================
echo CHON PHUONG AN CAI DAT PHIEN BAN E300XDY-3.3.49:
echo.
echo   [1] Cai de / Nang cap truc tiep (KHUYEN DUNG - Giu nguyen ban do & cai dat)
echo   [2] Cai dat sach (Go phan mem com.ezhan.amr cu roi cai dat moi 100%%)
echo   [3] Thoat
echo ======================================================================
set /p "CHOICE=Nhap lua chon cua ban [1, 2 hoac 3] (Mac dinh 1): "
if "%CHOICE%"=="" set CHOICE=1

if "%CHOICE%"=="3" (
    echo Da huy thao tac.
    exit /b 0
)

echo.
echo Dang lay quyen quan tri cao nhat (Root)...
"%ADB_CMD%" root
timeout /t 2 >nul

if "%CHOICE%"=="2" (
    echo.
    echo Dang go bo phien ban phan mem cu (com.ezhan.amr)...
    "%ADB_CMD%" uninstall com.ezhan.amr
    echo.
    echo Dang cai dat file APK moi E300XDY-3.3.49.apk...
    "%ADB_CMD%" install "%APK_FILE%"
) else (
    echo.
    echo Dang cai dat de / nang cap giu nguyen du lieu (-r -d)...
    "%ADB_CMD%" install -r -d "%APK_FILE%"
)

echo.
if %errorlevel% equ 0 (
    echo ======================================================================
    echo    [HOAN TAT] NÂNG CẤP PHẦN MỀM AGV E300XDY-3.3.49 THÀNH CÔNG!
    echo ======================================================================
    echo.
    echo Dang khoi dong ung dung tren man hinh Robot...
    "%ADB_CMD%" shell monkey -p com.ezhan.amr -c android.intent.category.LAUNCHER 1 >nul 2>nul
    echo Ung dung moi da duoc mo tren man hinh xe AGV.
) else (
    echo ======================================================================
    echo [LOI] Qua trinh cai dat gap su co! Vui long kiem tra lai thong bao tren.
    echo ======================================================================
)

echo.
pause
