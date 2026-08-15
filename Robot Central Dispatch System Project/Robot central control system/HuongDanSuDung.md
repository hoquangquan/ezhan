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
  👉 **`http://127.0.0.1:8081/index`** (hoặc `localhost:8081/index`)
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
- **Tài khoản đăng nhập mặc định (nếu có hỏi):** Thông thường là `admin` / `123456` hoặc `admin` / `admin123`.
- **Collation Error:** Lỗi này đã được xử lý triệt để trong quá trình cài đặt tự động.

---

## 4. Lỗi 502 Bad Gateway (System interface 502 exception)

Nếu bạn mở trang Web lên và đăng nhập bị báo lỗi **"502 Bad Gateway"** hoặc **"系统接口502异常"**, nguyên nhân là do:
- **Lõi Máy chủ Java đã bị chết do Lỗi Bản quyền (License).**
- Giao diện bạn nhìn thấy chỉ là phần "Vỏ" (Nginx) của trang web, còn phần lõi xử lý dữ liệu ở phía sau đã ngừng hoạt động ngay lúc khởi động do sai mã máy.

**Cách khắc phục:**
1. Mở file `logs\ezhan.log` hoặc xem cửa sổ chạy lệnh CMD, bạn sẽ thấy mã máy tính của bạn bị báo lỗi (VD: `F9CD-5322-BC85-A0B7-5222`).
2. Nhắn mã máy này cho hãng/nhà cung cấp phần mềm để xin mã License mới.
3. Mở file `config/license.key`, xóa nội dung cũ và chép đoạn mã License mới vào.
4. Khởi động lại hệ thống bằng `start.bat`.

---

## 5. Hướng dẫn cấu hình Hộp gọi cứng (Hardware Callbox7)

Nếu bạn dùng Hộp gọi vật lý của Ezhan (có màn hình OLED nhỏ và các nút bấm K1, K2, K3), bạn cần trỏ IP của nó về Máy chủ PC.

**Bước 1: Lấy IP của Máy chủ PC**
- Trên máy tính Laptop chạy phần mềm, mở PowerShell và gõ lệnh `ipconfig` để lấy địa chỉ IPv4 của Wi-Fi/LAN (Ví dụ: `192.168.68.132`).

**Bước 2: Vào giao diện Web của Hộp gọi**
- Cấp nguồn cho Hộp gọi. Đảm bảo nó đã kết nối cùng mạng Wi-Fi với PC (nhìn trên màn hình OLED của hộp gọi, dòng `WIFI:` phải có tên mạng và dòng `IP:` phải hiện số IP, ví dụ `192.168.68.135`).
- Mở trình duyệt Web trên PC, gõ trực tiếp địa chỉ IP của Hộp gọi vào thanh địa chỉ:
  👉 **`http://192.168.68.135`** (Thay bằng số IP thực tế hiển thị trên màn hình hộp gọi).
- Giao diện **Callbox WiFi Setup** sẽ hiện ra.

**Bước 3: Trỏ IP về Máy chủ PC**
- Tại ô **Cloud server IP**, xóa số IP bị sai đi và điền chính xác địa chỉ IP của Máy chủ PC ở Bước 1 (Ví dụ: `192.168.68.132`).
- Bấm nút xanh **Save server IP**. Hộp gọi sẽ tự khởi động lại.

*(Lưu ý: Hộp gọi chỉ kết nối thành công và hiện chữ `CLOUD: ON` trên màn hình OLED sau khi Máy chủ PC đã cập nhật License ở Phần 4 và đang chạy bình thường).*
