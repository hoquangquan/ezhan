@echo off
chcp 65001 >nul
title ESATECH - Cai Dat Moi Truong ADB cho AGV E300
echo ======================================================================
echo       ESATECH - CAI DAT MOI TRUONG ANDROID ADB VAO WINDOWS PATH
echo ======================================================================
echo.

set "ADB_DIR=C:\Users\Admin\Downloads\EZHAN\EZHAN\Update\Update\Operating Documentation\platform-tools\platform-tools\adb"

if not exist "%ADB_DIR%\adb.exe" (
    echo [LOI] Khong tim thay file adb.exe tai:
    echo %ADB_DIR%
    pause
    exit /b 1
)

echo [1/3] Da tim thay file adb.exe tai:
echo       %ADB_DIR%
echo.

echo [2/3] Dang them duong dan ADB vao bien moi truong User PATH cua Windows...
powershell -NoProfile -Command ^
    "$dir = 'C:\Users\Admin\Downloads\EZHAN\EZHAN\Update\Update\Operating Documentation\platform-tools\platform-tools\adb';" ^
    "$userPath = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "$paths = ($userPath -split ';') | Where-Object { $_ -and (Test-Path $_) };" ^
    "if ($paths -notcontains $dir) {" ^
    "    $newPath = if ([string]::IsNullOrWhiteSpace($userPath)) { $dir } else { $userPath.TrimEnd(';') + ';' + $dir };" ^
    "    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User');" ^
    "    Write-Host '   -> [THANH CONG] Da them duong dan ADB vao User PATH!' -ForegroundColor Green;" ^
    "} else {" ^
    "    Write-Host '   -> [INFO] Duong dan ADB da co san trong User PATH.' -ForegroundColor Yellow;" ^
    "}"

echo.
echo [3/3] Kiem tra phien ban ADB:
set "PATH=%PATH%;%ADB_DIR%"
"%ADB_DIR%\adb.exe" version

echo.
echo ======================================================================
echo [HOAN TAT] Cai dat moi truong ADB thanh cong!
echo.
echo TU NAY BAN CO THE:
echo 1. Mo bat ky cua so CMD hoac PowerShell moi nao.
echo 2. Go truc tiep: adb devices (de ket noi xe AGV).
echo 3. Go: adb install ... (de cai dat file APK cap nhat phan mem).
echo ======================================================================
echo.
pause
