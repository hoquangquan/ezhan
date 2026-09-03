# Hướng Dẫn Cập Nhật Phần Mềm Màn Hình HMI AGV E300 (File APK)

Tài liệu này được trích xuất và phân tích từ thư mục `Update` mà bạn vừa cung cấp.

Mục đích của gói cập nhật này là để **nâng cấp hoặc cài đặt lại phần mềm điều khiển cảm ứng (HMI - Android)** trên màn hình của xe AGV. Cụ thể, file ứng dụng được cập nhật là `E300XDY-3.3.48.apk` (thuộc package name `com.ezhan.amr`).

Dưới đây là các bước thao tác chi tiết theo đúng tài liệu kỹ thuật chuẩn (Application Deployment Guide):

## Chuẩn Bị Công Cụ
1. Máy tính chạy Windows.
2. Cáp kết nối USB.
3. Giải nén thư mục `platform-tools.zip` (chứa bộ công cụ kết nối Android ADB) nằm trong thư mục `Operating Documentation`.
4. (Tùy chọn) Thêm đường dẫn thư mục `platform-tools` vừa giải nén vào biến môi trường **Path** của Windows để tiện gõ lệnh ở mọi nơi.

## Quy Trình Cập Nhật Cụ Thể

### BƯỚC 1: Kết nối và Thiết lập trên xe AGV
- Khởi động xe AGV.
- Dùng cáp USB kết nối máy tính của bạn với cổng kết nối tương ứng trên thân xe/màn hình HMI.
- Trên màn hình HMI của AGV, vào **Settings (Cài đặt)** > **Accessibility (Trợ năng)**.
- Tìm mục **OTG to USB switch** và chuyển trạng thái sang **OFF** (Tắt) để cho phép kết nối nhận tín hiệu ADB từ máy tính.

### BƯỚC 2: Kiểm tra kết nối ADB
- Trên máy tính, mở cửa sổ Command Prompt (CMD).
- Gõ lệnh để kiểm tra xem ADB đã nhận diện được AGV chưa:
```bash
adb devices
```
- Nếu trả về danh sách thiết bị (VD: `xxxxxx device`), có nghĩa là kết nối đã thành công.

### BƯỚC 3: Cấp quyền Quản trị cao nhất (Root)
- Để có quyền can thiệp gỡ/cài ứng dụng hệ thống, gõ lệnh:
```bash
adb root
```
*(Lệnh này giúp chiếm quyền Administrator / Root User trên nền tảng Android của xe)*.

### BƯỚC 4: Gỡ cài đặt bản phần mềm cũ
- Gỡ bỏ phiên bản phần mềm HMI đang chạy hiện tại bằng lệnh:
```bash
adb uninstall com.ezhan.amr
```

### BƯỚC 5: Cài đặt bản cập nhật mới
- Cài đặt file APK mới (`E300XDY-3.3.48.apk`) bằng cách chỉ định đúng đường dẫn tới file này trên máy tính của bạn:
```bash
adb install "D:\ESATECH_TEST\New AGV\Update\Update\E300XDY-3.3.48.apk"
```
- Đợi dòng chữ **"Success"** xuất hiện. Việc cài đặt/cập nhật phần mềm trên HMI của AGV đã hoàn tất. Bạn có thể rút cáp và khởi động lại xe (nếu cần) để ứng dụng mới tự động chạy.
