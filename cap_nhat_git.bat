@echo off
chcp 65001 >nul
title ESATECH - Đồng Bộ Cập Nhật Dự Án Lên Git
cd /d "%~dp0"

echo ======================================================================
echo          ESATECH - ĐỒNG BỘ DỮ LIỆU DỰ ÁN AGV E300 LÊN GIT
echo ======================================================================
echo.

:: 1. Kiem tra Git co ton tai khong
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [LỖI] Máy tính chưa cài đặt Git hoặc chưa thêm Git vào biến môi trường PATH!
    pause
    exit /b 1
)

:: 2. Hien thi trang thai thay doi
echo [1/3] Kiểm tra các thay đổi trong dự án (git status):
git status --short
echo.

:: 3. Them tat ca thay doi
echo [2/3] Đang thêm các file thay đổi vào Git staging (git add .)...
git add .

:: 4. Commit cac thay doi
set COMMIT_MSG=docs & scripts: cap nhat quy trinh cai dat hop goi callbox va tool update E300
echo.
echo [3/3] Đang tạo commit: "%COMMIT_MSG%"
git commit -m "%COMMIT_MSG%"

echo.
:: 5. Push len remote repo neu co
echo Đang kiểm tra remote repository...
git remote -v >nul 2>nul
if %errorlevel% equ 0 (
    echo Đang đồng bộ đẩy dữ liệu lên Git Server (git push)...
    git push
    if %errorlevel% equ 0 (
        echo.
        echo ======================================================================
        echo    [THÀNH CÔNG] ĐÃ ĐẨY CÁC THAY ĐỔI LÊN GIT REPOSITORY AN TOÀN!
        echo ======================================================================
    ) else (
        echo.
        echo [LƯU Ý] Lệnh git push chưa hoàn tất (có thể do chưa đăng nhập hoặc mạng).
        echo Commit cục bộ đã được lưu thành công trên máy của bạn.
    )
) else (
    echo [THÔNG BÁO] Chưa cấu hình Git Remote. Các thay đổi đã được commit an toàn vào Git cục bộ.
)

echo.
pause
