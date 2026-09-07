# SỔ TAY KỸ THUẬT & XỬ LÝ SỰ CỐ THỰC TẾ ROBOT AGV E300 & HỘP GỌI CALLBOX

Tài liệu này tổng hợp toàn bộ các tình huống, nguyên nhân kỹ thuật chuyên sâu và quy trình khắc phục sự cố thực tế phát sinh trong quá trình vận hành Robot AGV E300 cùng Hệ thống điều phối trung tâm Ezhan RCS và Hộp gọi không dây (Callbox).

---

## 📌 MỤC LỤC TỔNG HỢP CÁC TÌNH HUỐNG

1. **[Tình huống 1](#1-tình-huống-1-hộp-gọi-báo-đã-nhận-lệnh-nhưng-robot-hoàn-toàn-đứng-im)**: Hộp gọi phát loa *"Đã nhận lệnh"* nhưng Robot hoàn toàn đứng im.
2. **[Tình huống 2](#2-tình-huống-2-hộp-gọi-báo-gửi-nhiệm-vụ--nhiệm-vụ-thất-bại)**: Hệ thống báo *"Gửi nhiệm vụ ➔ Nhiệm vụ thất bại"*.
3. **[Tình huống 3](#3-tình-huống-3-vừa-kết-thúc-task-bấm-lệnh-mới-xe-khựng-lại-đèn-xanh-dương--phải-cancel-bấm-lần-2-mới-chạy)**: Xe vừa xong việc, bấm lệnh mới thì bị khựng (đèn xanh dương), phải Cancel bấm lần 2 mới chạy.
4. **[Tình huống 4](#4-tình-huống-4-robot-bị-từ-chối-lệnh-do-độ-định-vị-thấp-position-confidence--50)**: Robot bị từ chối lệnh do Độ định vị thấp (`Position Confidence < 50%`).
5. **[Tình huống 5](#5-tình-huống-5-router-wi-fi-tự-đổi-địa-chỉ-ip-khiến-mất-kết-nối-hệ-thống)**: Router Wi-Fi tự đổi địa chỉ IP (DHCP) khiến đứt gãy liên lạc giữa Hộp gọi - Server - Robot.
6. **[Tình huống 6](#6-tình-huống-6-phân-biệt-dòng-xe-gt-và-bz-trong-cấu-hình-hộp-gọi)**: Chọn sai loại xe (`GT` thay vì `BZ`) trong cấu hình Hộp gọi.
7. **[Tình huống 7](#7-tình-huống-7-khởi-chạy-ezhanjar-v2-bị-văng-lỗi-cơ-sở-dữ-liệu-hoặc-license)**: Khởi chạy `Ezhan.jar` V2 bị văng lỗi Druid SQL hoặc lỗi License.
8. **[Tình huống 8](#8-tình-huống-8-cấu-hình-cơ-chế-sạc-tự-động-và-căn-chỉnh-lùi-sạc-chuẩn-xác)**: Cấu hình cơ chế Sạc tự động và căn chỉnh lùi sạc chuẩn xác.
9. **[Tình huống 9](#9-tình-huống-9-xe-né-vật-cản-đi-vào-khe-hẹpgóc-kẹt-và-không-tự-thoát-ra-được)**: Xe né vật cản đi vào khe hẹp/góc kẹt và không tự thoát ra được.
10. **[Tình huống 10](#10-tình-huống-10-gặp-vật-cản-bất-ngờxe-khác-chắn-đường-xe-bật-đèn-đỏ-đứng-im--vật-cản-đi-ra-xe-vẫn-bị-khóa-đèn-đỏ)**: Gặp vật cản bất ngờ/xe khác chắn đường, xe bật đèn đỏ đứng im – Vật cản đi ra xe vẫn bị khóa đèn đỏ.
11. **[Tình huống 11](#11-tình-huống-11-quy-tắc-vận-hành--các-trường-hợp-di-chuyển-tiến--lùi-của-robot-e300)**: Quy tắc vận hành & Các trường hợp Di chuyển Tiến / Lùi của Robot E300.
12. **[Tình huống 12](#12-tình-huống-12-quy-trình--xử-lý-sự-cố-nhận-diện-nâng--hạ-kệ-hàng-lift--jacking-mode)**: Quy trình & Xử lý sự cố Nhận diện Nâng / Hạ Kệ hàng (Lift / Jacking Mode).

---

## 1. TÌNH HUỐNG 1: Hộp gọi báo "Đã nhận lệnh" nhưng Robot hoàn toàn đứng im

### 🔴 Hiện tượng:
* Ấn nút K1, K2 hoặc K3 trên Hộp gọi cứng.
* Hộp gọi phát loa thông báo: *"Đã nhận lệnh"*.
* Tuy nhiên xe Robot không hề có phản ứng, màn hình cảm ứng của xe trơ ra không nhận được lệnh.

### 🔍 Nguyên nhân cốt lõi:
1. **Tiếng loa "Đã nhận lệnh" là của Hộp gọi ➔ Máy tính:** Tín hiệu nút bấm mới chỉ đi từ Hộp gọi lên Server PC qua cổng WebSocket 8765. Tiếng loa chứng minh Hộp gọi thông với Máy tính, CHƯA chứng minh lệnh đã tới Robot.
2. **Hộp gọi bị trả về cấu hình rỗng (`"none"`):** Nếu IP/ICCID của Hộp gọi bị đổi mà CSDL trên Server lưu số cũ, Server phản hồi về Hộp gọi: `{"1":"none", "2":"none", "3":"none"}` ➔ Nút bấm không chứa lệnh điều khiển nào.
3. **Ô `Tác vụ liên kết` điền sai từ khóa:** Điền chữ `delivery` hoặc `Charge` khiến hệ thống tìm kiếm "Chuỗi tác vụ" (Task Chain) thay vì lệnh điều chuyển trạm điểm.

### 🛠 Quy trình khắc phục:
1. **Kiểm tra Cấu hình hộp gọi trên Web (`http://127.0.0.1`):**
   * Vào **Quản lý thiết bị ➔ Cấu hình hộp gọi ➔ Bấm Sửa (Edit)**.
   * Đảm bảo ô **`IP thiết bị`** đúng với IP thực tế hiện tại của Robot (xem trên màn hình xe).
   * Đảm bảo ô **`ICCID/IP`** đúng với IP thực tế hiển thị trên OLED Hộp gọi.
2. **Sửa ô `Tác vụ liên kết` (Bind Task Name):**
   * **Cách tốt nhất:** Điền **Tác vụ liên kết trùng tên với Trạm liên kết** (Ví dụ: Nút 1: `Esa_1_ahuy` | Nút 3: `Esa_1_sac`) hoặc **ĐỂ TRỐNG** ô Tác vụ liên kết để hệ thống gọi lệnh điều chuyển điểm trực tiếp.
3. Bấm **Lưu (Xác nhận)** ➔ Ra bấm lại nút Hộp gọi.

---

## 2. TÌNH HUỐNG 2: Hộp gọi báo "Gửi nhiệm vụ ➔ Nhiệm vụ thất bại"

### 🔴 Hiện tượng:
* Bấm nút trên Hộp gọi, hệ thống phản hồi: *"Gửi nhiệm vụ"* sau đó thông báo ngay *"Nhiệm vụ thất bại"*.

### 🔍 Nguyên nhân cốt lõi:
1. **Xe đang đứng ngay tại trạm đích:** Xe đang đỗ tại Trạm sạc `Esa_1_sac` mà bạn bấm nút gọi về sạc ➔ Bộ điều hướng thấy tọa độ hiện tại trùng với điểm đến nên báo hoàn thành/từ chối nhiệm vụ.
2. **Tên trạm không tồn tại trên bản đồ Robot:** Ví dụ trong Hộp gọi gán là `Esa_1_sac` nhưng trên bản đồ xe lại lưu tên có dấu tiếng Việt `Esa_1_Điểm sạc` ➔ Robot tìm không thấy trạm trên đồ thị SLAM.
3. **Robot chưa vào bản đồ:** Trên màn hình xe chưa bấm **Enter Map** hoặc xe đang ở chế độ Manual (Thủ công).

### 🛠 Quy trình khắc phục:
1. **Kéo xe ra xa trạm đích 2 - 3 mét:** Đảm bảo xe đứng tự do trên sàn trống trước khi bấm gọi lệnh.
2. **Đối chiếu tên trạm:**
   * Mở Web ➔ Vào mục **Trạng thái thiết bị ➔ Xem chi tiết xe AMR003**.
   * Xem dòng **`Vị trí hiện tại`** khi xe đỗ tại trạm đang hiển thị chữ gì (copy chính xác 100% chữ đó vào ô *Trạm liên kết* trong Cấu hình hộp gọi).
3. **Trên màn hình Robot:** Vào ứng dụng Ezhan AMR ➔ Chọn đúng bản đồ `Esa_1` ➔ Bấm **Enter Map** ➔ Chuyển sang **Delivery Mode**.

---

## 3. TÌNH HUỐNG 3: Vừa kết thúc Task, bấm lệnh mới xe khựng lại (đèn xanh dương) – Phải Cancel bấm lần 2 mới chạy

### 🔴 Hiện tượng:
* Robot vừa chạy giao hàng đến nơi và kết thúc nhiệm vụ.
* Xe đang đứng rảnh, bạn bấm `Charge Task` hoặc `Go to Standby`:
  * Lần bấm 1: Xe nhận lệnh, vừa nhích bánh thì dừng khựng lại, dải đèn LED vẫn sáng **Màu xanh dương**.
  * Phải bấm nút đỏ **`Cancel Task`**, sau đó bấm `Charge Task` lần 2 thì xe mới chịu chạy bình thường.

### 🔍 Nguyên nhân cốt lõi:
* **Bộ đếm thời gian dừng chờ tại trạm (Delivery Stay Duration):** Mặc định trên phần mềm xe cài đặt thời gian dừng chờ bốc dỡ hàng là **`30s` hoặc `60s`**.
* Khi xe vừa đến nơi, bộ đếm này đang kích hoạt chạy ngầm đếm ngược (đèn xanh dương). Khi có lệnh mới chen ngang, tiến trình cũ chưa giải phóng phanh hoàn toàn nên xe bị khựng lại.
* Khi bấm `Cancel Task`, hệ thống ép xóa sạch bộ đếm của tác vụ cũ, đưa xe về `Idle` tuyệt đối nên lần bấm thứ 2 xe mới chạy.

### 🛠 Quy trình khắc phục (Để bấm 1 lần là chạy ngay):
1. Trên màn hình cảm ứng của Robot E300:
   * Vào **System Settings (Cài đặt hệ thống)** ➔ Chọn **Basic Settings (Cài đặt cơ bản)**.
2. Tìm tham số: **`Delivery Stay Duration` (Thời gian lưu lại trạm)**:
   * Chỉnh con số từ `30s`/`60s` giảm thẳng về **`0s`** (hoặc `3s`).
3. Bấm **`Save settings` (Lưu cài đặt)**.
4. 👉 *Kết quả:* Vừa đến nơi bốc hàng xong, xe giải phóng phanh ngay lập tức. Bấm lệnh mới 1 phát là xe quay đầu chạy luôn!

---

## 4. TÌNH HUỐNG 4: Robot bị từ chối lệnh do Độ định vị thấp (`Position Confidence < 50%`)

### 🔴 Hiện tượng:
* Trên Web mục Trạng thái thiết bị hiển thị dòng: **`Position Confidence: 45.4%`** (hoặc dưới 50%).
* Xe nhận lệnh nhưng không chịu chạy hoặc báo lỗi mất định vị (Navigation Lost).

### 🔍 Nguyên nhân & Cơ chế an toàn:
* Trong thuật toán định vị Laser SLAM, khi độ tin cậy định vị `< 50%`, robot tự đánh giá là *xe đang bị mất phương hướng/lạc tọa độ*.
* Để chống đâm va vào tường hoặc công nhân, xe sẽ **tự động ngắt động cơ và từ chối mọi lệnh di chuyển tự động**.

### 🛠 Quy trình khắc phục:
1. Trên màn hình cảm ứng của Robot: Bấm nút **`Định vị lại` (Relocalization / 重定位)**.
2. Dùng cần gạt ảo (Joystick) hoặc tay cầm điều khiển lái xe di chuyển một đoạn ngắn (2 - 3 mét) lại gần các góc tường hoặc vật thể cố định để Lidar quét lại đặc trưng môi trường.
3. Khi dòng `Position Confidence` trên màn hình xe xanh lên **> 70%** (hoặc > 80%), xe sẽ lập tức sẵn sàng nhận lệnh chạy tự động.

---

## 5. TÌNH HUỐNG 5: Router Wi-Fi tự đổi địa chỉ IP khiến mất kết nối hệ thống

### 🔴 Hiện tượng:
* Hôm trước hệ thống chạy bình thường, hôm sau bật máy lên thì xe báo Offline hoặc Hộp gọi không điều khiển được xe nữa.

### 🔍 Nguyên nhân cốt lõi:
* Router Wi-Fi cấp IP động (DHCP), mỗi ngày khởi động lại hoặc hết hạn lease time, Router cấp một dải IP mới:
  * Xe từ `.103` nhảy sang `.127` rồi `.118`.
  * Hộp gọi từ `.129` nhảy sang `.142`.
  * Máy tính PC Server từ `.100` nhảy sang `.126`.
* Trong CSDL, máy tính vẫn gửi lệnh vào IP cũ đã chết nên xe không nhận được.

### 🛠 Quy trình khắc phục triệt để:
**BẮT BUỘC CỐ ĐỊNH IP TĨNH (STATIC IP) CHO 3 THIẾT BỊ:**

| Thiết bị | IP Khuyến nghị | Cách thiết lập |
| :--- | :--- | :--- |
| **Máy tính Server PC** | `192.168.1.100` *(hoặc `.68.100`)* | Vào *Network Connections* trên Windows ➔ Cài Static IPv4. |
| **Robot AMR E300** | `192.168.1.61` *(hoặc `.68.103`)* | Vào Cài đặt Wi-Fi trên màn hình Robot ➔ Chuyển DHCP sang Static IP. |
| **Hộp gọi Callbox** | `192.168.1.35` *(hoặc `.68.129`)* | Kết nối Wi-Fi `Callbox_xxxx` ➔ Truy cập `192.168.4.1` gán IP tĩnh. |

*(Hoặc truy cập trang quản trị Router Wi-Fi, vào mục DHCP Address Reservation để khóa cứng địa chỉ MAC của 3 thiết bị).*

---

## 6. TÌNH HUỐNG 6: Phân biệt dòng xe `GT` và `BZ` trong Cấu hình Hộp gọi

### 🔴 Hiện tượng:
* Trong Cấu hình hộp gọi có cột **`Loại thiết bị` (Device Type)** gồm các lựa chọn: `GT`, `BZ` hoặc để trống.

### 🔍 Nguyên tắc kỹ thuật:
* **`BZ` (Standard Delivery AMR):** Dành riêng cho **Dòng xe AGV E300 tiêu chuẩn** (chuyên chở hàng mặt sàn, thùng hàng, khay linh kiện).
* **`GT` (Jacking / Forklift AMR):** Dành riêng cho **Dòng xe AGV kích nâng / nâng pallet** (có cơ cấu nâng hạ thủy lực chui gầm kệ).
* ⚠️ Nếu xe E300 nhưng chọn `GT`, hệ thống điều phối sẽ kích hoạt hàm gọi nâng kệ (`jackTask`) thay vì hàm chạy giao hàng (`deliveryTask`), dẫn đến xe không chạy được.

### 🛠 Quy trình khắc phục:
* Trong bảng nút bấm của Cấu hình hộp gọi: Luôn chọn cột **`Loại thiết bị = BZ`** (hoặc chọn dòng đầu tiên/để trống).

---

## 7. TÌNH HUỐNG 7: Khởi chạy Ezhan.jar V2 bị văng lỗi Cơ sở dữ liệu hoặc License

### 🔴 Hiện tượng:
* Khi chạy `start.bat` của phiên bản mới V2, cửa sổ Java báo lỗi:
  * `alibaba.druid.filter.FilterChainImpl.preparedStatement_execute...`
  * Hoặc `Ezhan.jar process exited unexpectedly`.

### 🔍 Nguyên nhân:
1. **Lỗi thiếu cột CSDL:** Bản `Ezhan.jar` V2 cần đọc các trường mới trong CSDL (`device_type`, `auto_assign`, `call_location`, `amr_charging_pile`). Nếu CSDL chưa được nâng cấp, ứng dụng sẽ crash khi khởi động.
2. **Lỗi License sai máy:** Dùng file `license.key` mẫu của hãng (tạo theo địa chỉ MAC máy của kỹ sư bên Trung Quốc) thay vì mã License được tạo theo phần cứng máy tính của bạn.

### 🛠 Quy trình khắc phục:
1. **Nâng cấp CSDL:** Chạy file SQL [`update_schema.sql`](file:///C:/Users/Admin/Downloads/EZHAN/EZHAN/Robot%20Central%20Dispatch%20System%20Project2/update_schema.sql) vào cơ sở dữ liệu `Ezhan` trong MariaDB.
2. **Dùng đúng License:** Đảm bảo file [`config/license.key`](file:///C:/Users/Admin/Downloads/EZHAN/EZHAN/Robot%20Central%20Dispatch%20System%20Project2/config/license.key) chứa đúng chuỗi mã bản quyền được cấp cho máy tính của bạn (bắt đầu bằng `FuQhRezj...`).

---

## 8. TÌNH HUỐNG 8: Cấu hình cơ chế Sạc tự động và Căn chỉnh lùi sạc chuẩn xác

### 🔴 Yêu cầu kỹ thuật:
* Xe tự động biết đường lùi vào trạm sạc cắm chấu chính xác từng milimet mà không bị đâm lệch chấu sạc.

### 🛠 Quy trình thiết lập 3 bước chuẩn:

#### Bước 1: Khai báo Điểm sạc chuẩn trên màn hình xe (Trang 44 User Manual)
1. Bấm nút E-Stop, dùng tay đẩy xe lùi sao cho 2 bản cực đồng ở đuôi xe áp sát chấu sạc của trạm sạc (khoảng cách **`2 - 5 cm`**).
2. Nhả E-Stop ➔ Vào **Location ➔ Special Locations ➔ Bấm `Update` tại dòng `Charge`**.
3. Ra màn hình chính bấm **`Return to charge`** để xe tự lùi cắm sạc vào trạm.
4. Khi màn hình hiện biểu tượng **Tia sét (Đang sạc)** ➔ Vào lại `Special Locations` bấm **`Update`** lần 2 để chốt tọa độ tuyệt đối.

#### Bước 2: Thiết lập điểm Tiền trạm sạc (Pre-charging Point)
* Đặt 1 điểm dừng phía trước trạm sạc cách chấu sạc **`0.8m - 1.0m`** với mũi tên hướng thẳng vào trạm sạc.
* *Tác dụng:* Xe chạy đến điểm này trước ➔ Xoay 180 độ quay đuôi xe lại ➔ Lùi thẳng tắp vào chấu sạc an toàn.

#### Bước 3: Kích hoạt Ngưỡng sạc tự động (Trang 70 User Manual)
* Vào **System Settings ➔ Basic Settings**:
  * Gạt **`Autonomous Charging = ON`** (Bật tự động sạc).
  * Cài đặt **`Automatic Charging Threshold = 20%`** (Tự động về sạc khi pin dưới 20%).
  * Bấm **`Save settings`**.

---

## 9. TÌNH HUỐNG 9: Xe né vật cản đi vào khe hẹp/góc kẹt và không tự thoát ra được

### 🔴 Hiện tượng:
* Xe đang trên đường làm nhiệm vụ thì gặp vật cản (người đi bộ hoặc thùng hàng chắn đường).
* Tính năng tự động né vật cản (Obstacle Detour) kích hoạt, xe đánh lái đi vòng để tìm đường khác.
* Tuy nhiên, xe lại rẽ chui vào **khe hẹp giữa 2 máy móc, gầm bàn hoặc ngõ cụt**, sau đó xe dừng lại báo lỗi hoặc loay hoay không đủ bán kính để quay đầu đi tiếp.

### 🔍 Nguyên nhân kỹ thuật:
1. **Bản đồ chưa vẽ Tường ảo (Virtual Wall):** Trên bản đồ SLAM, các khoảng trống giữa các chân máy, góc tường chết vẫn được tính là "vùng có thể đi được" (vùng màu trắng). Khi đường chính bị chặn, thuật toán định tuyến tự do (Free Path Navigation) sẽ tự động tìm mọi khoảng trống để đi xuyên qua.
2. **Điểm mù cảm biến khi xoay trong không gian hẹp (Trang 14 & 27 User Manual):** Cảm biến Lidar chính và Camera 3D nằm ở phía trước đầu xe (góc quét 240°). Khi xe chui vào khe hẹp và cố gắng xoay đuôi để quay đầu, hai bên hông và đuôi xe là điểm mù, xe phát hiện khoảng cách an toàn quá gần nên kích hoạt khóa dừng khẩn cấp để tránh va quẹt.
3. **Chế độ dẫn hướng đang để `Free Path Mode` (Đường đi tự do):** Xe được phép tự ý đổi hướng linh hoạt toàn bản đồ thay vì bám theo luồng đường chạy cố định.

### 🛠 3 Giải pháp xử lý triệt để:
1. **Vẽ Tường ảo (`Virtual Wall`) bịt kín các ngách hẹp (Khuyên dùng):** Dùng công cụ *Draw Area ➔ Virtual Wall* trên màn hình Map để vẽ ranh giới đỏ ngăn xe không bao giờ lách vào khe máy.
2. **Chuyển sang `FIXED PATH MODE`:** Vào *System Settings ➔ Basic Settings ➔ Navigation Mode Selection* chọn `FIXED PATH MODE`. Gặp vật cản xe chỉ dừng chờ hoặc né trong phạm vi làn đường, không tự ý rẽ lung tung.
3. **Cứu hộ nhanh khi đang bị kẹt:** Nhấn nút E-Stop hông xe ➔ Kéo xe thẳng ra trục đường chính ➔ Nhả E-Stop ➔ Bấm nút xanh **`Resume Task`** trên màn hình xe (hoặc trên Web) để xe tiếp tục chạy nốt hành trình.

---

## 10. TÌNH HUỐNG 10: Gặp vật cản bất ngờ/xe khác chắn đường, xe bật đèn ĐỎ đứng im – Vật cản đi ra xe vẫn bị khóa đèn ĐỎ

### 🔴 Hiện tượng:
* Xe đang chạy thì gặp vật cản bất ngờ (người lao ra quá sát, hoặc con Robot khác đang đỗ chắn đúng trạm đích).
* Dải đèn LED của xe bật sáng **MÀU ĐỎ** và xe đứng yên.
* Khi người hoặc con xe kia đã đi ra khỏi vị trí, con xe này **vẫn tiếp tục đứng im và dải đèn LED vẫn giữ nguyên MÀU ĐỎ**, không chịu tự chạy tiếp.

### 🔍 Nguyên nhân kỹ thuật & Cơ chế an toàn (Trang 10, 22 & 79 User Manual):
1. **Cảm biến va chạm cơ khí Bumper bị kích hoạt (Hardware Collision Latch):**
   * Nếu người hoặc vật cản xuất hiện quá sát (< 0.2m) làm chạm nhẹ vào **Thanh cảm biến va chạm (Safety Bumper)** ở chân xe ➔ Hệ thống kích hoạt ngắt phần cứng Cấp độ 2 (Hardware Interlock).
   * ⚠️ **Quy chuẩn an toàn máy móc công nghiệp:** Khi Bumper đã bị kích hoạt, hệ thống **NGHIÊM CẤM tự động chạy tiếp** mà bắt buộc phải có người xác nhận (Manual Reset), nhằm đảm bảo an toàn tuyệt đối (tránh trường hợp xe tự lao đi tiếp khi đang kẹt người/vật thể bên dưới gầm xe).
2. **Lỗi Quá thời gian chờ lộ trình (Route Controller Timeout / Soft E-stop):**
   * Nếu điểm đến bị con xe khác chặn đường quá lâu (vượt quá thời gian chờ, ví dụ quá 30 giây) ➔ Bộ lập lộ trình hủy quỹ đạo (Abort Trajectory) và rơi vào trạng thái **`Soft E-Stop Triggered` / `Route Timeout`** (Trang 79 User Manual), xe khóa đèn đỏ để chờ người vận hành chỉ định lại.

### 🛠 2 Cách xử lý & Cài đặt tự động phục hồi:
1. **Thao tác Reset mở khóa khi xe đã dính đèn ĐỎ:** Nhấn nút **E-Stop trên trụ màn hình** xuống ➔ Xoay theo chiều kim đồng hồ để nút **bật nhả lên (Reset)** ➔ Dải đèn LED sẽ lập tức chuyển từ **Đỏ ➔ Xanh lá (Normal)** và xe tự động chạy tiếp (hoặc bấm `Resume Task` trên Web).
2. **Cài đặt khoảng cách cảnh báo từ xa để KHÔNG BAO GIỜ BỊ DÍNH ĐÈN ĐỎ:** Vào *System Settings ➔ Basic Settings*, chỉnh **`Recognition Distance` (Khoảng cách nhận diện vật cản)** tăng lên **`1.2m - 1.5m`** (thay vì 0.3m). Khi gặp vật cản từ xa 1.5m, xe chỉ giảm tốc dừng tạm (đèn Xanh/Vàng), khi người đi ra xe tự động chạy tiếp ngay mà không bao giờ bị khóa đèn đỏ!

---

## 11. TÌNH HUỐNG 11: Quy tắc vận hành & Các trường hợp Di chuyển Tiến / Lùi của Robot E300

### 🔴 Nguyên lý dẫn động vi sai & Xoay tại chỗ (Trang 9 & 14 User Manual):
* E300 sử dụng cơ cấu truyền động **2 bánh vi sai độc lập (Double Wheel Differential Drive)**.
* **Bán kính quay xe = 0 (Zero Turning Radius):** Đường kính quay xe chỉ **`840mm (84cm)`**, cho phép xe tự xoay tròn 360° tại chỗ mà không cần không gian tiến lùi như xe ô tô.

### 🔍 Quy tắc di chuyển Tiến vs Lùi thực tế:

| Chế độ | Vận tốc | Cảm biến an toàn | Phạm vi áp dụng |
| :--- | :--- | :--- | :--- |
| **Tiến (Forward)** | `0.1 ~ 1.5 m/s` *(Mặc định 0.4 m/s)* | **Đầy đủ 3 lớp:** Laser Lidar 240° (25m) + Camera 3D (180mm) + Thanh cản va chạm Bumper. | **Chế độ chính 95%:** Toàn bộ quá trình giao hàng, tuần tra, dẫn đường giữa các xưởng. |
| **Lùi (Backward)** | `< 0.1 m/s` *(Tốc độ rùa bò)* | **Điểm mù quang học:** Đuôi xe không có Lidar quét 360°, chỉ có cảm biến tiếp điểm/khoảng cách ngắn. | **Chỉ áp dụng trong 2 trường hợp kiểm soát đặc biệt:**<br>1. Lùi cắm chấu sạc tự động.<br>2. Lùi rút khỏi gầm kệ hàng sau khi hạ. |

### ⚠️ Khuyến nghị an toàn quốc tế (ISO 3691-4):
* **Tuyệt đối không ép xe chạy lùi dài:** Vì phía sau là điểm mù, việc cho xe chạy lùi tốc độ cao trên đường đi công cộng có thể gây va quẹt vào công nhân hoặc hàng hóa phía sau.
* Khi cần đổi hướng: Xe sẽ **tự động xoay đầu 180° tại chỗ rồi chạy tiến**, đảm bảo mắt thần Lidar luôn quét bao quát phía trước hướng di chuyển.

---

## 12. TÌNH HUỐNG 12: Quy trình & Xử lý sự cố Nhận diện Nâng / Hạ Kệ hàng (Lift / Jacking Mode)

### 🔴 Cơ cấu mâm kích nâng (Trang 9, 48 & 65-67 User Manual):
* **Tải trọng nâng tối đa:** **`300 kg`**.
* **Hành trình kích nâng:** **`55 mm (± 2mm)`**.
* **Cơ chế:** Mâm nâng phẳng bằng điện/thủy lực nhấc bổng toàn bộ 4 chân giá kệ lên khỏi sàn nhà để vận chuyển.

---

### 🔍 Chu trình 4 bước Nhận diện & Nâng hạ Kệ hàng tự động:

```text
[1. Tiếp cận trạm kệ] ──> [2. Quét Laser 4 chân kệ] ──> [3. Chui gầm & Kích nâng 55mm] ──> [4. Vận chuyển & Hạ kệ]
```

1. **Bước 1: Tiếp cận trạm kệ (Approach):** Xe di chuyển đến điểm tiền trạm (Pre-jacking point) trước mặt kệ hàng.
2. **Bước 2: Quét Laser nhận diện hình học chân kệ (Legs Identification):**
   * Mắt Lidar phía trước quét nhận diện đám mây điểm 3D của **4 chân trụ kệ sắt**.
   * Phần mềm tự động tính toán góc xoay (Yaw) và khoảng cách tâm để căn chỉnh xe thẳng hàng tuyệt đối với trục giữa của 2 chân trước.
3. **Bước 3: Chui gầm & Kích nâng (`Identify & Lift`):**
   * Xe từ từ chui vào gầm kệ với độ sâu chui mặc định **`-0.87m`**.
   * Mâm nâng kích đẩy lên cao **`55mm`**, nhấc bổng 4 chân kệ khỏi mặt đất.
4. **Bước 4: Vận chuyển & Hạ kệ (`Identify & Lower` ➔ `Exit Storage Location`):**
   * Xe cõng kệ chạy đến điểm xả hàng ➔ Mâm nâng hạ xuống để 4 chân kệ tiếp sàn vững chắc ➔ Xe tự động chạy lùi hoặc tiến rút ra khỏi gầm kệ.

---

### ⚙️ Hướng dẫn Cài đặt Thông số Kệ hàng (Mục `Shelf Settings` - Trang 72-75 User Manual):

Khi đưa giá kệ mới vào xưởng, bạn dùng thước dây đo thực tế và nhập vào bảng **Shelf Configuration**:

| Thông số trên màn hình | Ý nghĩa & Đơn vị | Giá trị mẫu chuẩn |
| :--- | :--- | :--- |
| **`Shelf Width` (Chiều rộng kệ)** | Chiều rộng tổng thể bao ngoài của giá kệ (m). | `0.90 m` |
| **`Shelf Length` (Chiều dài kệ)** | Chiều dài tổng thể bao ngoài của giá kệ (m). | `0.90 m` |
| **`Leg Center Distance (Width)`** | Khoảng cách đo giữa tâm chân trái và tâm chân phải (m). | `0.82 m` |
| **`Leg Center Distance (Length)`** | Khoảng cách đo giữa tâm chân trước và tâm chân sau (m). | `0.82 m` |
| **`Insertion Depth` (Độ sâu chui gầm)** | Chiều sâu xe chui vào tâm kệ (mặc định âm). | `-0.87 m` |
| **`Leg Expansion` (Khoảng hở an toàn)** | Khoảng dung sai cho phép khi chui gầm. | `0.20 m` |
| **`Actual Leg Width` (Độ dày chân kệ)** | Độ dày/đường kính của thanh sắt chân kệ (m). | `0.04 m (4cm)` |
| **`Overall Offset` (Độ lệch tâm)** | Tinh chỉnh vị trí mâm nâng nằm khớp tâm trọng lực kệ. | `-0.10 m` |

---

### 🛠 XỬ LÝ CÁC SỰ CỐ KHI NÂNG HẠ KỆ HÀNG:

#### 1. Lỗi: Xe báo không nhận diện được chân kệ (Shelf Recognition Failed)
* **Nguyên nhân:** Chân kệ bị che khuất bởi bạt/hàng hóa rơi xuống, hoặc thông số `Leg Center Distance` đo bị sai lệch so với thực tế > 3cm.
* **Cách khắc phục:**
  * Đo lại chính xác khoảng cách giữa tâm 4 chân sắt của giá kệ và cập nhật lại vào bảng *Shelf Settings*.
  * Đảm bảo khoảng không gian từ mặt sàn lên đáy kệ cao tối thiểu **`250mm`** để xe chui lọt gầm an toàn.

#### 2. Lỗi: Kệ bị nghiêng hoặc trượt khi nâng
* **Nguyên nhân:** Trọng tâm hàng hóa trên kệ bị dồn về 1 bên hoặc tham số `Overall Offset` chưa căn đúng điểm cân bằng.
* **Cách khắc phục:** Xếp hàng hóa đều trọng tâm; vào *Shelf Settings* chỉnh lại `Overall Offset` sao cho biểu tượng xe nằm chính giữa khung màu xanh dương trên màn hình mô phỏng.

---

## 13. TÌNH HUỐNG 13: Xe chui lọt kệ hàng, kích nâng lên xong (đèn LED xanh dương) nhưng đứng im không di chuyển

### 🔴 Hiện tượng:
* Xe tiếp cận trạm kệ, nhận diện 4 chân kệ thành công và chui vào gầm an toàn.
* Mâm nâng kích đẩy lên cao 55mm nhấc bổng giá kệ, dải đèn LED chuyển sang **MÀU XANH DƯƠNG** (trạng thái cõng tải sẵn sàng).
* Tuy nhiên, xe đứng im tại chỗ không chịu lăn bánh di chuyển về điểm xả hàng.

### 🔍 4 Nguyên nhân kỹ thuật cốt lõi:
1. **Mất điểm mốc định vị khi chui gầm (Localization Confidence Lost):**
   * 4 chân sắt hoặc vách kệ che khuất một phần góc quét 240° của mắt Laser Lidar.
   * Độ tin cậy định vị (*Localization Confidence*) bị tụt xuống dưới ngưỡng an toàn (< 60%), xe tự động hãm phanh để chống chạy lạc hướng.
2. **Camera đọc mã QR dưới sàn/đáy kệ bị lỗi:** Mắt camera quang học dưới gầm xe bị bẩn hoặc mã QR dán trên sàn/đáy kệ bị mờ, rách khiến xe không xác nhận được góc xoay ban đầu.
3. **Xung đột vùng an toàn (Footprint / Leg Expansion Conflict):** Phần mềm tính toán quỹ đạo thoát hiểm thấy kích thước kệ mở rộng (`Leg Expansion`) vượt quá làn đường cho phép nên từ chối xuất lệnh chuyển động.
4. **Chờ xác nhận từ hệ thống điều phối RCS (Dispatch ACK Timeout):** Server RCS chưa gửi gói tin xác nhận hoàn thành công đoạn nâng hàng.

### 🛠 Hướng dẫn Trích xuất Log Điều Hướng gửi Kỹ sư Hãng (winwin):
Kỹ sư hãng cần thư mục log gỡ lỗi di chuyển (`navigation_debug`) trên màn hình Android của xe để đọc dữ liệu Lidar và mã lỗi:
1. Kết nối máy tính với màn hình xe bằng cáp USB (theo quy trình ở Tình huống 14 bên dưới).
2. Chạy file 1-click [**`lay_log_navigation.bat`**](file:///c:/Users/Admin/Downloads/EZHAN/EZHAN/lay_log_navigation.bat) ở thư mục gốc, hoặc mở PowerShell gõ:
   ```bash
   adb pull /storage/emulated/0/Android/data/com.ezhan.amr/files/navigation_debug/ ./logs/
   ```
3. Nén thư mục `navigation_debug` thành file `.zip` và gửi trực tiếp cho kỹ sư hãng phân tích.

### 🛠 Xử lý nhanh tại hiện trường:
* **Vệ sinh camera & mã QR:** Lau sạch kính camera quét mã dưới gầm xe và bề mặt mã QR trên sàn nhà.
* **Tăng dung sai chui gầm:** Vào *Shelf Settings*, tăng thông số `Leg Expansion` từ `0.20m` lên `0.25m`.
* **Cứu hộ thủ công:** Dùng cần gạt ảo (Joystick) trên màn hình hoặc Remote điều khiển nhích nhẹ xe ra khỏi tâm kệ khoảng 10-20cm ➔ Bấm nút xanh **`Resume Task`** trên màn hình xe hoặc Web RCS để xe tiếp tục hành trình.

---

## 14. TÌNH HUỐNG 14: Lỗi máy tính cắm cáp USB không nhận xe (`adb devices` trống, `no devices/emulators found`)

### 🔴 Hiện tượng:
* Dùng cáp USB cắm nối giữa máy tính và màn hình xe AGV để lấy log hoặc cập nhật file APK (`E300XDY-3.3.48.apk`).
* Mở CMD/PowerShell gõ `adb devices` thì danh sách thiết bị `List of devices attached` bị trống hoàn toàn, hoặc báo `no devices/emulators found`.

### 🔍 4 Nguyên nhân kỹ thuật & Cách khắc phục chi tiết:

| Nguyên nhân | Giải thích kỹ thuật | Cách khắc phục triệt để |
| :--- | :--- | :--- |
| **1. Cáp Type-C to Type-C cắm laptop** | Cổng Type-C trên laptop hiện đại yêu cầu chip đàm phán CC/PD. Màn hình xe là bo mạch công nghiệp không có chip này nên laptop coi như không có thiết bị cắm vào. | **Bắt buộc dùng cáp USB-A to Type-C:** Đầu cắm vào máy tính là **đầu USB chữ nhật to thông thường**, đầu cắm vào xe là Type-C. |
| **2. Dùng nhầm cáp sạc nguồn** | Cáp sạc điện thoại giá rẻ chỉ có 2 sợi dây nguồn (+ / -), bị cắt bỏ 2 sợi truyền tín hiệu (D+ / D-). | Đổi sang **cáp truyền dữ liệu (Data Cable)** - loại cáp cắm điện thoại vào máy tính sao chép hình ảnh được. |
| **3. Cổng xe chưa chuyển sang Device** | Cổng Type-C trên xe đang ở chế độ Host (chỉ để cắm chuột/USB), từ chối nhận lệnh từ máy tính. | Trên màn hình xe: Vào **Settings ➔ Hiển thị (Display) ➔ dòng `otgmode control` ➔ chuyển sang `Device`** *(hoặc trong Trợ năng tắt `OTG to USB switch` sang `OFF`)*. |
| **4. Chưa bật Gỡ lỗi USB** | Tính năng USB Debugging trên Android của xe đang bị tắt. | Vào **Settings ➔ Tùy chọn nhà phát triển (Developer options) ➔ Bật `Gỡ lỗi USB (USB Debugging)` sang ON** ➔ Nhìn màn hình xe chọn **"Luôn cho phép"** và bấm **OK**. |

---

## 15. TÌNH HUỐNG 15: Lỗi kết nối ADB qua mạng LAN/Ethernet bị từ chối (`cannot connect to IP:5555: Connection actively refused 10061`)

### 🔴 Hiện tượng:
* Nối dây mạng LAN giữa máy tính và xe AGV (hoặc chung mạng Wi-Fi).
* Dùng lệnh `adb connect <IP_Xe>:5555` thì nhận được thông báo lỗi:
  `cannot connect to 192.168.x.x:5555: No connection could be made because the target machine actively refused it. (10061)`

### 🔍 Nguyên nhân bảo mật hệ điều hành:
* Bản phân phối Android công nghiệp trên màn hình xe AGV mặc định **đóng cổng mạng 5555** nhằm ngăn chặn việc can thiệp trái phép từ xa qua mạng nội bộ nhà máy.
* Cổng gỡ lỗi ADB chỉ được phép kích hoạt thông qua kết nối vật lý bằng dây cáp USB.

### 🛠 Hướng xử lý chuẩn:
* **Không cố gắng kết nối ADB qua cổng mạng Ethernet LAN.**
* Chuyển sang kết nối bằng **cáp USB-A to Type-C** cắm trực tiếp vào màn hình xe và thực hiện theo đúng 4 bước ở **Tình huống 14**.

---

## 16. TÌNH HUỐNG 16: Lỗi Bản quyền hệ thống điều phối RCS (`LICENSE VERIFICATION FAILED - Machine Code changed`)

### 🔴 Hiện tượng:
* Khi chạy file `start.bat` để khởi động hệ thống điều phối RCS (Project 2 hoặc Project 1), cửa sổ điều khiển `Ezhan Core Console` bật lên và dừng lại với dòng chữ:
  ```text
  =====================================================
  LICENSE VERIFICATION FAILED - System cannot start!
  Reason: License verification failed
  Machine Code: 0A7E-402F-E804-104B-048C

  Contact your supplier for a valid license code.
  Put the license code into config/license.key and restart.
  =====================================================
  ```
* Dịch vụ backend `Ezhan.jar` bị ngắt, trình duyệt không mở được Web RCS hoặc mở web lên nhưng không giao tiếp được với Robot.

### 🔍 2 Nguyên nhân cốt lõi:
1. **Thay đổi trạng thái cắm dây mạng Ethernet (Nguyên nhân phổ biến nhất):**
   * Theo tài liệu cấp phép RuoYi (`Authorization_Code_Instructions.pdf`), chuỗi `Machine Code` được tính toán tự động bằng thuật toán băm SHA-256 từ:
     $$\text{Machine Code} = \text{SHA256}(\text{CPU Serial} + \text{Mainboard Serial} + \mathbf{\text{MAC Card mạng đầu tiên}} + \text{Disk Serial})$$
   * **Vấn đề thực tế:** Khi máy tính đang dùng Wi-Fi mà bạn **cắm thêm dây cáp mạng Ethernet (LAN)** nối với Robot hoặc Switch xưởng:
     * Windows tự động đẩy card mạng có dây (Ethernet) lên vị trí ưu tiên số 1 (Interface Metric thấp hơn Wi-Fi).
     * Thuật toán Java lấy địa chỉ MAC của card Ethernet thay vì card Wi-Fi.
     * `Machine Code` lập tức bị biến đổi sang mã mới (ví dụ: `0A7E-402F-E804-104B-048C`), khiến file `license.key` cũ không còn trùng khớp!
2. **Cài đặt phần mềm sang máy tính mới:** Mỗi máy tính có phần cứng khác nhau nên Machine Code sẽ khác nhau hoàn toàn.

### 🛠 2 Phương án khắc phục:

#### 👉 Phương án 1: Xử lý nhanh trong 5 giây (Khôi phục card mạng ban đầu)
1. **Rút dây cáp mạng Ethernet ra khỏi máy tính** (hoặc vào *Network Connections* bấm chuột phải vào card Ethernet chọn *Disable*).
2. Chạy lại file `start.bat`.
3. Java sẽ đọc lại địa chỉ MAC của card Wi-Fi ban đầu $\rightarrow$ `Machine Code` trùng khớp trở lại $\rightarrow$ Hệ thống khởi động bình thường ngay lập tức!

#### 👉 Phương án 2: Đăng ký mã bản quyền bổ sung khi cắm cố định dây mạng LAN
Nếu nhà máy bắt buộc phải cắm cố định dây mạng LAN giữa máy tính và xe Robot:
1. Giữ nguyên dây mạng cắm vào máy tính.
2. Sao chép chuỗi `Machine Code` mới đang hiển thị trên màn hình lỗi (Ví dụ: `0A7E-402F-E804-104B-048C`).
3. Gửi mã này cho kỹ sư đại diện của hãng (như bạn `winwin`):
   > *"Hi winwin, when I plug in the Ethernet cable, our RCS server Machine Code becomes: `0A7E-402F-E804-104B-048C`. Could you please generate a new license key for this machine code?"*
4. Sau khi nhận được mã bản quyền mới từ hãng, mở file:
   [**`Robot Central Dispatch System Project2\config\license.key`**](file:///c:/Users/Admin/Downloads/EZHAN/EZHAN/Robot%20Central%20Dispatch%20System%20Project2/config/license.key)
5. Xóa nội dung cũ, dán mã mới vào và bấm **Ctrl + S** để lưu lại.
6. Chạy lại `start.bat` $\rightarrow$ Hệ thống sẽ hoạt động ổn định vĩnh viễn trên đường truyền mạng LAN.

---

*(Tài liệu này được biên soạn chuẩn xác theo cấu trúc mã nguồn Ezhan RCS V2 và hệ điều hành AGV E300 - Bản quyền ESATECH © 2026).*
