@echo off
chcp 65001 >nul
title ESATECH - Cập Nhật Phần Mềm Robot AGV E300
cd /d "%~dp0"

echo ======================================================================
echo       ESATECH - CẬP NHẬT PHẦN MỀM ROBOT AGV E300 SERIES
echo ======================================================================
echo.

:: 1. Kiem tra va xu ly file E300 moi them vao
set "APK_NEW_RAW=%~dp0E300XDY-3.3.49(1).apk.1.1"
set "APK_NEW_CLEAN=%~dp0E300XDY-3.3.49_moi_nhat.apk"
set "APK_OLD=%~dp0E300XDY-3.3.49.apk"

if exist "%APK_NEW_RAW%" (
    if not exist "%APK_NEW_CLEAN%" (
        echo [THÔNG BÁO] Phát hiện file E300 mới thêm: E300XDY-3.3.49(1).apk.1.1
        echo Đang chuẩn hóa đuôi file thành: E300XDY-3.3.49_moi_nhat.apk...
        copy /y "%APK_NEW_RAW%" "%APK_NEW_CLEAN%" >nul
        echo    -^> Chuẩn hóa định dạng file APK thành công!
        echo.
    )
)

:: Xac dinh danh sach file APK de lua chon
set "APK_TO_INSTALL="

if exist "%APK_NEW_CLEAN%" (
    echo ĐÃ TÌM THẤY CÁC BẢN PHẦN MỀM TRONG DỰ ÁN:
    echo   [1] Bản MỚI NHẤT bạn vừa thêm (E300XDY-3.3.49_moi_nhat.apk - 106,128 KB) [KHUYÊN DÙNG]
    if exist "%APK_OLD%" (
        echo   [2] Bản trước đó trong dự án (E300XDY-3.3.49.apk - 106,156 KB)
    )
    echo   [3] Thoát
    echo.
    set /p "FILE_CHOICE=Chọn bản APK muốn cài đặt [1, 2 hoặc 3] (Mặc định 1): "
    if "%FILE_CHOICE%"=="" set FILE_CHOICE=1
    if "%FILE_CHOICE%"=="3" (
        echo Đã hủy thao tác.
        pause
        exit /b 0
    )
    if "%FILE_CHOICE%"=="2" (
        set "APK_TO_INSTALL=%APK_OLD%"
    ) else (
        set "APK_TO_INSTALL=%APK_NEW_CLEAN%"
    )
) else if exist "%APK_OLD%" (
    set "APK_TO_INSTALL=%APK_OLD%"
) else (
    echo [LỖI] Không tìm thấy file APK nào trong thư mục dự án!
    echo Vui lòng đảm bảo file E300 nằm trong thư mục: %~dp0
    pause
    exit /b 1
)

echo.
echo ======================================================================
echo File APK sẽ cài đặt: 
echo -^> %APK_TO_INSTALL%
echo ======================================================================
echo.

:: 2. Tim kiem cong cu ADB
set "ADB_CMD=adb"
set "ADB_LOCAL=%~dp0Update\Update\Operating Documentation\platform-tools\platform-tools\adb\adb.exe"

if exist "%ADB_LOCAL%" (
    set "ADB_CMD=%ADB_LOCAL%"
) else (
    where adb >nul 2>nul
    if %errorlevel% neq 0 (
        echo [LỖI] Không tìm thấy công cụ adb.exe!
        pause
        exit /b 1
    )
)

echo [1/3] Công cụ kết nối ADB sẵn sàng tại:
echo       %ADB_CMD%
echo.

:: 3. Kiem tra ket noi voi Robot AGV
echo [2/3] Đang kiểm tra kết nối với Robot AGV qua cáp USB...
echo.
"%ADB_CMD%" devices
echo.

:CHECK_DEVICE
"%ADB_CMD%" devices > "%TEMP%\adb_devices_check.txt"
findstr /R "device$" "%TEMP%\adb_devices_check.txt" >nul
if %errorlevel% neq 0 (
    echo ----------------------------------------------------------------------
    echo [CẢNH BÁO] CHƯA TÌM THẤY XE AGV KẾT NỐI QUA CÁP USB!
    echo.
    echo Vui lòng kiểm tra 2 bước phần cứng sau:
    echo 1. Cáp USB: Cắm cáp USB 2 đầu đực (Type-A sang Type-A) nối PC với
    echo    cổng USB ở cạnh dưới màn hình Robot AGV.
    echo 2. Chế độ OTG trên màn hình xe AGV:
    echo    Vào: Cài đặt (Settings) -^> Hiển thị (Display) -^> Bật "otgmode control"
    echo    (Chuyển sang ON để mở cổng nhận diện ADB theo đúng chuẩn hãng).
    echo ----------------------------------------------------------------------
    echo.
    echo Nhấn phím bất kỳ sau khi đã cắm cáp và bật OTG để kiểm tra lại kết nối...
    pause >nul
    "%ADB_CMD%" devices
    echo.
    "%ADB_CMD%" devices > "%TEMP%\adb_devices_check.txt"
    findstr /R "device$" "%TEMP%\adb_devices_check.txt" >nul
    if %errorlevel% neq 0 (
        echo Van chua tim thay thiet bi. Vui long kiem tra lai day cap va thu lai!
        goto CHECK_DEVICE
    )
)
del "%TEMP%\adb_devices_check.txt" 2>nul

echo    -^> [KẾT NỐI THÀNH CÔNG] Đã nhận diện Robot AGV!
echo.

:: 4. Chon kieu cai dat
echo ======================================================================
echo CHỌN PHƯƠNG ÁN CÀI ĐẶT LÊN XE AGV:
echo.
echo   [1] Cài đè / Nâng cấp trực tiếp (KHUYÊN DÙNG - Giữ nguyên bản đồ & cài đặt)
echo   [2] Cài đặt sạch (Gỡ com.ezhan.amr cũ rồi cài đặt mới 100%%)
echo   [3] Thoát
echo ======================================================================
set /p "MODE_CHOICE=Nhập lựa chọn của bạn [1, 2 hoặc 3] (Mặc định 1): "
if "%MODE_CHOICE%"=="" set MODE_CHOICE=1

if "%MODE_CHOICE%"=="3" (
    echo Đã hủy thao tác.
    pause
    exit /b 0
)

echo.
echo [3/3] Đang lấy quyền quản trị cao nhất (Root)...
"%ADB_CMD%" root
timeout /t 2 >nul

if "%MODE_CHOICE%"=="2" (
    echo.
    echo Đang gỡ bỏ phiên bản phần mềm cũ (com.ezhan.amr)...
    "%ADB_CMD%" uninstall com.ezhan.amr
    echo.
    echo Đang cài đặt file APK mới...
    "%ADB_CMD%" install "%APK_TO_INSTALL%"
) else (
    echo.
    echo Đang cài đặt đè / nâng cấp giữ nguyên dữ liệu (-r -d)...
    "%ADB_CMD%" install -r -d "%APK_TO_INSTALL%"
)

echo.
if %errorlevel% equ 0 (
    echo ======================================================================
    echo    [HOÀN TẤT] CẬP NHẬT PHẦN MỀM AGV E300 THÀNH CÔNG RỰC RỠ!
    echo ======================================================================
    echo.
    echo Đang tự động khởi động ứng dụng trên màn hình Robot...
    "%ADB_CMD%" shell monkey -p com.ezhan.amr -c android.intent.category.LAUNCHER 1 >nul 2>nul
    echo -^> Ứng dụng mới đã được kích hoạt trên màn hình cảm ứng AGV.
) else (
    echo ======================================================================
    echo [LỖI] Quá trình cài đặt gặp sự cố! Vui lòng kiểm tra lại thông báo trên.
    echo ======================================================================
)

echo.
pause
