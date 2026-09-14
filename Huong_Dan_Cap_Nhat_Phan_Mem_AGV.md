# Hướng Dẫn Cập Nhật Phần Mềm Màn Hình HMI AGV E300 (File APK)

Tài liệu này được trích xuất và phân tích từ thư mục `Update` mà bạn vừa cung cấp.

Mục đích của gói cập nhật này là để **nâng cấp hoặc cài đặt lại phần mềm điều khiển cảm ứng (HMI - Android)** trên màn hình của xe AGV. Cụ thể, file ứng dụng được cập nhật là `E300XDY-3.3.49.apk` (thuộc package name `com.ezhan.amr`), bản trước đó là `E300XDY-3.3.48.apk`.

Dưới đây là các bước thao tác chi tiết theo đúng tài liệu kỹ thuật chuẩn (Application Deployment Guide):

## Chuẩn Bị Công Cụ
1. Máy tính chạy Windows.
2. Cáp kết nối USB 2 đầu đực (Type-A sang Type-A).
3. Đã có công cụ kết nối Android ADB trong thư mục `Update\Update\Operating Documentation\platform-tools\platform-tools\adb`.
4. File cài đặt mới: `E300XDY-3.3.49.apk` (106 MB).

## Quy Trình Cập Nhật Cụ Thể

### BƯỚC 1: Kết nối và Thiết lập trên xe AGV
- Khởi động xe AGV.
- Dùng cáp USB kết nối máy tính của bạn với cổng kết nối ở cạnh dưới màn hình HMI.
- Trên màn hình HMI của AGV, vào **Settings (Cài đặt)** > **Display (Hiển thị)**.
- Tìm mục **otgmode control** và chuyển trạng thái sang **ON** (Bật) theo đúng hướng dẫn của hãng để mở cổng nhận tín hiệu ADB từ máy tính.

### BƯỚC 2: Kiểm tra kết nối ADB
- Trên máy tính, mở cửa sổ Command Prompt hoặc PowerShell.
- Gõ lệnh để kiểm tra xem ADB đã nhận diện được AGV chưa:
```bash
adb devices
```
- Nếu trả về danh sách thiết bị (VD: `e814d582e2a5cc73 device`), có nghĩa là kết nối đã thành công.

### BƯỚC 3: Cấp quyền Quản trị cao nhất (Root)
- Để có quyền can thiệp gỡ/cài ứng dụng hệ thống, gõ lệnh:
```bash
adb root
```

### BƯỚC 4: Lựa chọn Cài đặt

#### 👉 Lựa chọn 1 (Khuyên dùng - Nâng cấp đè giữ nguyên bản đồ & cấu hình):
```bash
adb install -r -d "C:\Users\Admin\Downloads\EZHAN\EZHAN\E300XDY-3.3.49.apk"
```

#### 👉 Lựa chọn 2 (Cài đặt sạch - Gỡ sạch bản cũ rồi cài mới):
```bash
adb uninstall com.ezhan.amr
adb install "C:\Users\Admin\Downloads\EZHAN\EZHAN\E300XDY-3.3.49.apk"
```

### BƯỚC 5: Tự động hóa qua File 1-Click (Khuyên dùng)
Bạn chỉ cần nhấp đúp chạy 1 trong 2 file script sau trong thư mục gốc dự án:
- 🚀 **[update_E300.bat](file:///c:/Users/Admin/Downloads/EZHAN/EZHAN/update_E300.bat)** (Script chuyên dụng cập nhật nhanh)
- 🚀 **[cai_dat_apk_E300XDY.bat](file:///c:/Users/Admin/Downloads/EZHAN/EZHAN/cai_dat_apk_E300XDY.bat)**

> [!TIP]
> **Tự động xử lý file mới thêm:** Nếu bạn thêm file có đuôi tải về như `E300XDY-3.3.49(1).apk.1.1`, script sẽ **tự động chuẩn hóa thành file APK chuẩn** (`E300XDY-3.3.49_moi_nhat.apk`) và ưu tiên cài đặt bản mới nhất này cho bạn!

