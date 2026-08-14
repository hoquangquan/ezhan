# HƯỚNG DẪN SỬ DỤNG TRẠM ĐIỀU PHỐI (EZHAN RCS)

Toàn bộ hệ thống phần mềm này đã được đóng gói thành phiên bản **Portable (Không cần cài đặt)**. Java và Cơ sở dữ liệu MariaDB (thay thế cho MySQL) đều đã được nạp sẵn vào trong thư mục này.

Bạn hoàn toàn có thể copy toàn bộ thư mục `Robot central control system` sang bất kỳ máy tính Windows nào khác để sử dụng mà không cần phải tải hay cài đặt thêm phần mềm rườm rà.

---

## 1. Cách bật hệ thống

Có hai cách để bạn khởi động hệ thống:

**Cách 1: Dành cho người dùng phổ thông (Click chuột)**
1. Mở thư mục này và tìm file **`start.bat`**.
2. **Nháy đúp chuột (Double-click)** vào file `start.bat`.

**Cách 2: Dành cho kỹ thuật viên (Chạy bằng lệnh Terminal)**
1. Mở Terminal (PowerShell hoặc CMD) ngay tại thư mục này.
2. Gõ lệnh sau và ấn Enter:
   ```powershell
   .\start.bat
   ```

**Diễn biến sau khi bật:**
- Một màn hình màu đen (CMD) sẽ hiện lên, tự động khởi động 4 dịch vụ cốt lõi: MariaDB, Redis, Nginx, Ezhan.
- Hãy **chờ khoảng 10 - 60 giây**. Bạn sẽ thấy các thông báo "started successfully!".
- Ngay khi mọi thứ khởi động xong, hệ thống sẽ **tự động mở trình duyệt Web** (thường là Google Chrome hoặc Edge) và truy cập vào địa chỉ: 
  👉 **`http://127.0.0.1/index`** (hoặc `localhost/index`)
- Tại giao diện này, bạn có thể thực hiện đồng bộ bản đồ từ xe AGV (Sync Map) và cấu hình Hộp gọi (Call Box).

> **Lưu ý:** Không bấm dấu X tắt cái bảng màu đen (CMD) đi. Hãy thu nhỏ (Minimize) nó xuống thanh Taskbar. Nếu bạn tắt nó, phần mềm sẽ không thể tự động tắt các dịch vụ chạy ngầm được.

---

## 2. Cách tắt hệ thống

Khi không sử dụng nữa hoặc chuẩn bị tắt máy tính, bạn **TUYỆT ĐỐI KHÔNG** tắt ngang bằng dấu X của cửa sổ CMD đang chạy, vì như vậy Database sẽ bị treo ngầm.

Có hai cách để tắt hệ thống an toàn:

**Cách 1: Tắt bằng chuột**
1. Hãy về lại thư mục này, tìm file **`stop.bat`**.
2. **Nháy đúp chuột** vào `stop.bat`.

**Cách 2: Tắt bằng lệnh Terminal**
1. Mở Terminal (PowerShell hoặc CMD) ngay tại thư mục này.
2. Gõ lệnh sau và ấn Enter:
   ```powershell
   .\stop.bat
   ```

Hệ thống sẽ tự động quét và đóng toàn bộ Database, Java, Nginx và Redis một cách an toàn nhất.

---

## 3. Khắc phục sự cố thường gặp

- **Web không vào được:** Đảm bảo cổng mạng 80 và 8080 trên máy tính của bạn không bị phần mềm khác (như Skype, Zalo, XAMPP) chiếm dụng.
- **Báo lỗi Java:** Nếu bạn lỡ tay xóa thư mục `jdk-17`, phần mềm sẽ không thể chạy. Bạn sẽ cần tải lại OpenJDK 17.
- **Tài khoản đăng nhập mặc định (nếu có hỏi):** Thông thường là `admin` / `123456` hoặc `admin` / `admin`. (Tuỳ thuộc vào file cài đặt của hãng).
- **Collation Error:** Lỗi này đã được xử lý triệt để trong quá trình cài đặt tự động, bạn không cần quan tâm đến lỗi liên quan tới `utf8mb4_0900_ai_ci` nữa.
