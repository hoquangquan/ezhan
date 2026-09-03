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
  👉 **`http://127.0.0.1`** (hoặc `http://localhost`)
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

## 5. Hướng dẫn toàn tập cấu hình & vận hành Hộp gọi cứng (Callbox)

Để Hộp gọi vật lý (có màn hình OLED và 3 nút bấm K1, K2, K3) hoạt động và điều khiển được xe Robot AGV E300, bạn thực hiện theo quy trình 4 bước chuẩn hóa sau:

```text
[HỘP GỌI VẬT LÝ]  ──(1) Gửi Button ID qua WebSocket:8765──>  [MÁY CHỦ EZHAN RCS (PC)]
                                                                      │
                                                           (2) Tra cứu CSDL & đóng gói lệnh Task
                                                                      │
                                                                      ▼
[ROBOT AGV E300]  <──(3) Phát lệnh qua Task API:8068 (hoặc 8080)───────┘
```

---

### Bước 1: Cấu hình Mạng & Server trên Hộp gọi (Web nội bộ)
Bước này giúp Hộp gọi kết nối Wi-Fi và biết địa chỉ Máy tính điều phối để gửi nhận dữ liệu.

1. **Cấp nguồn Type-C** cho Hộp gọi.
2. Dùng điện thoại hoặc laptop kết nối vào Wi-Fi do Hộp gọi phát ra (Tên có dạng: `callbox7-SETUP`).
3. Mở trình duyệt Web truy cập: 👉 **`http://192.168.4.1`**
4. Thiết lập các mục sau:
   - **Callbox name:** Đặt tên chuẩn (VD: `callbox7`). Bấm **Save name**.
   - **Cloud server IP:** Điền **IP của Máy tính PC chạy Ezhan** (VD: `192.168.68.123` - xem bằng `ipconfig` trên PC). Bấm **Save server IP**.
   - **Network (Wi-Fi):** Chọn Wi-Fi xưởng (VD: `ESATECH`) và nhập mật khẩu Wi-Fi. Bấm **Connect**.
5. **Kiểm tra màn hình OLED của Hộp gọi:**
   - Dòng 1: `Name: callbox7`
   - Dòng 2: `WiFi: [Tên Wi-Fi]`
   - Dòng 3: `IP: [Số IP Hộp gọi nhận được từ router, VD: 192.168.68.129]`
   - Dòng 4: Bắt buộc phải hiện chữ **`CLOUD: OK`** (Xác nhận đã thông mạch với PC).

---

### Bước 2: Khai báo Hộp gọi & Cấu hình nút trên Web Ezhan RCS (`http://127.0.0.1`)

Mở Web Ezhan trên máy tính ➔ Vào menu **Quản lý thiết bị ➔ Cấu hình hộp gọi ➔ Bấm Sửa (Edit)**:

#### 1. Thông tin kết nối chung:
- **Tên hộp gọi:** `callbox7` (Khớp với tên ở Bước 1).
- **IP thiết bị:** Điền **IP của con xe Robot AGV** (VD: `192.168.68.103` - xem trên màn hình xe hoặc trang Device Details).
- **ICCID/IP:** Điền **IP của cái Hộp gọi** (VD: `192.168.68.129` - lấy từ dòng `IP:` trên màn hình OLED Hộp gọi).
- **Tên tác vụ liên kết (Global):** Để trống.

#### 2. Cấu hình bảng nút bấm (Button Configuration):
Hệ thống phân tách 2 chức năng rõ ràng:
- **`Trạm liên kết` (Station Binding):** Là trạm để **kích hoạt loa thông báo**. Khi xe đến trạm này, Hộp gọi sẽ phát loa: *"Robot đã đến nơi, vui lòng nhận hàng"*.
- **`Tác vụ liên kết` (Bound Task):** Là **lệnh điều khiển xe di chuyển**. Điền từ khóa TaskType chuẩn từ tài liệu API của hãng hoặc tên mẫu tác vụ.

| ID nút | Tên nút *(Hiển thị OLED)* | Tác vụ liên kết *(Theo API Doc)* | Trạm liên kết *(Vị trí kích hoạt loa)* |
| :---: | :---: | :--- | :--- |
| **1** | `giao` | **`delivery`** *(hoặc `Point-to-Point Movement`)* | `Esa_1_vekho` |
| **2** | `nhan` | **`delivery`** *(hoặc `Point-to-Point Movement`)* | `Esa_1_ahuy` |
| **3** | `sac` | **`Charge`** *(hoặc `charge`)* | `Esa_1_sac` |

➔ Bấm **Lưu (Xác nhận)**.

---

### Bước 3: Thiết lập Chế độ trên Màn hình Xe Robot AGV E300
*(Theo tài liệu E300 Series User Manual - Trang 49 & Trang 79)*

Để Robot chấp nhận thực thi lệnh điều phối từ xa:
1. **Mở App trên Robot:** Chạm vào màn hình Robot, mở ứng dụng Ezhan AMR.
2. **Vào đúng Bản đồ:** Chọn bản đồ **`Esa_1`** ➔ Bấm **Enter Map (Vào bản đồ)** để Robot hoàn tất tự định vị (Relocalization).
3. **Chuyển Chế độ Vận hành:**
   * Trên màn hình chính của Robot, chuyển sang **`Delivery Mode` (Chế độ giao hàng)**.
4. **Kiểm tra an toàn phần cứng:**
   * Đảm bảo nút dừng khẩn cấp E-Stop không bị xoay khóa.
   * Thanh cản va chạm (Collision Bar) quanh gầm xe không bị cấn vào tường/vật cản.
   * Bánh xe không bị khóa (`Wheel Status: Bình thường`).
   * Đảm bảo Robot đang ở trạng thái **Rảnh rỗi (Idle)**, không bị vướng ngậm chấu sạc.

---

### Bước 4: Vận hành & Gọi xe thực tế

1. **Gọi xe về sạc:**
   - Đặt xe Robot đứng ở vị trí khác trạm sạc (VD: trạm kho `Esa_1_vekho`).
   - Ra Hộp gọi bấm **Nút 3 (Nút `sac`)**:
     * Hộp gọi phát loa: *"Đã nhận lệnh"*.
     * Robot nhận tác vụ `Charge`, tự động mở phanh và di chuyển từ `Esa_1_vekho` về trạm sạc `Esa_1_sac`.
     * Khi xe cập bến trạm sạc `Esa_1_sac`, Hộp gọi tại trạm sạc sẽ phát loa: *"Robot đã đến nơi, vui lòng nhận hàng"*.
2. **Giao hàng đến trạm kho:**
   - Đặt xe ở trạm sạc (hoặc trạm chờ), ra Hộp gọi bấm **Nút 1 (Nút `giao`)**:
     * Robot nhận tác vụ `delivery`, tự động rời trạm sạc chạy sang trạm kho `Esa_1_vekho`.

---

## 6. Phân biệt 3 loại địa chỉ IP (Tránh nhầm lẫn gây mất kết nối)

Trong hệ thống Ezhan RCS, có **3 thiết bị độc lập** giao tiếp với nhau qua mạng Wi-Fi. Bạn cần phân biệt rõ ràng 3 số IP này:

1. **IP Máy tính (Server PC):**
   - Là IP của máy tính đang chạy phần mềm Ezhan (Ví dụ: `192.168.68.123`).
   - *Cách lấy:* Mở PowerShell/CMD gõ `ipconfig`.
   - *Nơi dùng:* Điền vào ô **Cloud Server IP** trên trang cài đặt `192.168.4.1` của Hộp gọi.

2. **IP Xe Robot (AGV/AMR E300):**
   - Là IP hiển thị trên màn hình cảm ứng của con xe (Ví dụ: `192.168.68.103`).
   - *Nơi dùng:*
     + Trên Web Ezhan, vào **Quản lý thiết bị ➔ Danh sách thiết bị ➔ Sửa**. Ô **IP thiết bị** PHẢI là IP của con xe.
     + Trên Web Ezhan, vào **Quản lý thiết bị ➔ Cấu hình hộp gọi ➔ Sửa**. Ô **IP thiết bị** cũng PHẢI là IP của con xe.

3. **IP Hộp gọi (Callbox):**
   - Là IP hiển thị trên dòng `IP:` của màn hình OLED nhỏ trên hộp gọi (Ví dụ: `192.168.68.129`).
   - *Nơi dùng:* Trên Web Ezhan, vào **Quản lý thiết bị ➔ Cấu hình hộp gọi ➔ Sửa**. Ô **ICCID/IP** PHẢI là IP của hộp gọi.

> 💡 **Khuyến cáo:** Nếu cục phát Wi-Fi (Router) bị khởi động lại, IP của các thiết bị này có thể bị nhảy số mới (do DHCP). Tốt nhất nên gán IP tĩnh (Static IP / DHCP Reservation theo địa chỉ MAC) trên Router cho cả 3 thiết bị để không bao giờ bị đổi IP.

---

## 7. Lưu ý quan trọng về Tường lửa & Dịch vụ MQTT
1. **Windows Firewall:** Tường lửa của Windows có thể chặn cổng MQTT 1883 hoặc WebSocket 8765. Nếu Hộp gọi không hiện tên nút, hãy tắt Windows Defender Firewall hoặc mở Allow cổng TCP `1883`, `8765`, `8080`.
2. **Mosquitto Configuration:** File `mosquitto.conf` trong `C:\Program Files\mosquitto\` cần có 2 dòng:
   ```conf
   listener 1883 0.0.0.0
   allow_anonymous true
   ```
