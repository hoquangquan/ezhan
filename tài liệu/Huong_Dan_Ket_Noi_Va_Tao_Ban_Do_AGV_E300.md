# TÀI LIỆU HƯỚNG DẪN KẾT NỐI, TẠO BẢN ĐỒ VÀ VẬN HÀNH TOÀN DIỆN ROBOT AGV E300 SERIES

> **Quy trình Kỹ thuật Chuẩn về Khởi động, Cấu hình Mạng, Quét SLAM Bản đồ, Thiết lập Trạm sạc Tự động, Cơ chế Nâng hạ Kệ hàng (Jacking), Kết nối Hộp gọi Callbox và Hệ thống Điều phối Ezhan RCS V2.**  
> **Dòng thiết bị:** AMR / AGV E300 Series (Dòng BZ Tiêu chuẩn & GT Kích nâng)  
> **Công nghệ điều hướng:** Laser SLAM Navigation 2D/3D + Camera 3D  
> **Phần mềm điều phối:** Ezhan RCS Dispatching System V2 (2026)  
> **Đơn vị phát triển & biên soạn:** ESATECH Automation Systems © 2026

---

## 🚀 CHEAT SHEET: 6 BƯỚC KHỞI TẠO NHANH ĐỂ XE TỰ CHẠY TỪ CON SỐ 0

Dưới đây là tóm tắt quy trình thực hành nhanh nhất cho kỹ thuật viên:

```text
[BƯỚC 1: CẤP MẠNG IP TĨNH] ──> [BƯỚC 2: QUÉT MAP SLAM] ──> [BƯỚC 3: CÀI ĐIỂM DỪNG / SẠC / KỆ]
            │                                                                  │
            ▼                                                                  ▼
[BƯỚC 6: GIAO LỆNH VẬN HÀNH] <── [BƯỚC 5: KẾT NỐI HỘP GỌI] <── [BƯỚC 4: ĐỒNG BỘ LÊN RCS V2]
```

* **BƯỚC 1 - Bật nguồn & Đặt IP tĩnh:** Nhấn nút Power trên xe, chờ màn hình HMI sáng. Vào `System Settings ➔ Network Settings` kết nối Wi-Fi nhà máy và gán **IP tĩnh cố định** (Ví dụ: `192.168.1.61`).
* **BƯỚC 2 - Quét Bản đồ SLAM:** Vào `Map Settings ➔ New Map` đặt tên map (VD: `Esa_1`). Lái xe đi quét map bằng **Cần gạt ảo `Remote Ctrl` trên màn hình xe**, hoặc dùng **Remote**, hoặc **cắm Chuột USB vào xe**. Quét xong bấm `Save Map ➔ End Mapping ➔ Enter Map` để xe tự động chốt định vị.
* **BƯỚC 3 - Cài đặt Điểm dừng, Trạm sạc & Kệ:**
  * *Điểm làm việc:* Đưa xe đến vị trí ➔ Vào `Work Locations ➔ Add location ➔ Update ➔ Upload location`.
  * *Trạm sạc:* Đẩy đuôi xe cách chấu sạc 2-5cm ➔ Vào `Special Locations` lưu tọa độ làm điểm sạc (`Charge`).
  * *Kệ hàng (nếu có nâng hạ):* Vào `Shelf Settings` đo và nhập đúng kích thước 4 chân kệ ➔ Bấm `Used`.
* **BƯỚC 4 - Đồng bộ Map lên RCS V2:** Mở Web RCS (`http://127.0.0.1`) ➔ Vào `Quản lý bản đồ` thêm map `Esa_1` và bấm `Đồng bộ bản đồ` ➔ Vào `Quản lý thiết bị` thêm xe `AMR003` với IP tĩnh `192.168.1.61`.
* **BƯỚC 5 - Cấu hình Hộp gọi Callbox:** Gán IP tĩnh cho Hộp gọi (VD: `192.168.1.35`). Vào `Cấu hình hộp gọi` trên Web gán Nút 1 (Giao hàng: `BZ`), Nút 3 (Sạc: `BZ`), Nút nâng kệ (`GT`).
* **BƯỚC 6 - Vận hành thử nghiệm:** Bấm nút trên Hộp gọi hoặc bấm trên Web/màn hình xe ➔ Xe tự động chạy giao hàng, tự nâng kệ và tự lùi về trạm sạc khi hết pin!

---

## 📑 MỤC LỤC CHI TIẾT TÀI LIỆU

* [Phần 1: Tổng quan Thiết bị & Quy tắc An toàn Vận hành](#phần-1-tổng-quan-thiết-bị--quy-tắc-an-toàn-vận-hành)
* [Phần 2: Khởi động Thiết bị & Cấu hình Mạng IP Tĩnh Cố định](#phần-2-khởi-động-thiết-bị--cấu-hình-mạng-ip-tĩnh-cố-định)
* [Phần 3: Kết nối Hệ thống Điều phối Trung tâm Ezhan RCS V2](#phần-3-kết-nối-hệ-thống-điều-phối-trung-tâm-ezhan-rcs-v2)
* [Phần 4: Quy trình Quét SLAM & Tạo Bản đồ Mới (4 Phương pháp)](#phần-4-quy-trình-quét-slam--tạo-bản-đồ-mới)
* [Phần 5: Thiết lập Điểm Làm việc, Vùng An toàn & Tường ảo](#phần-5-thiết-lập-điểm-làm-việc-vùng-an-toàn--tường-ảo)
* [Phần 6: Cấu hình Cơ chế Sạc Tự động (Auto-Charging) Chuẩn xác](#phần-6-cấu-hình-cơ-chế-sạc-tự-động-auto-charging-chuẩn-xác)
* [Phần 7: Cơ chế Nhận diện & Nâng/Hạ Kệ Hàng (Lift / Jacking Mode)](#phần-7-cơ-chế-nhận-diện--nânghạ-kệ-hàng-lift--jacking-mode)
* [Phần 8: Cấu hình Hộp gọi Không dây Callbox Điều khiển Robot](#phần-8-cấu-hình-hộp-gọi-không-dây-callbox-điều-khiển-robot)
* [Phần 9: Đồng bộ Bản đồ & Điều phối Đa xe từ xa qua RCS](#phần-9-đồng-bộ-bản-đồ--điều-phối-đa-xe-từ-xa-qua-rcs)
* [Phần 10: Sổ tay Xử lý Sự cố Nhanh & Bảo trì Định kỳ](#phần-10-sổ-tay-xử-lý-sự-cố-nhanh--bảo-trì-định-kỳ)

---

## PHẦN 1: TỔNG QUAN THIẾT BỊ & QUY TẮC AN TOÀN VẬN HÀNH

### 1.1. Cấu tạo Phần cứng Cốt lõi của Robot E300
* **Hệ thống dẫn động vi sai 2 bánh (Double Wheel Differential Drive):** Cho phép robot xoay tròn 360° tại chỗ với bán kính quay bằng 0 (đường kính quay chỉ `840 mm`).
* **Cảm biến Laser Lidar (ở đầu trước xe):** Đặt ở độ cao `180 mm`, góc quét rộng `240°`, tầm quét phát hiện vật thể tối đa `25 mét`.
* **Cảm biến Camera 3D (trên trụ xe):** Nhận diện độ sâu 3D, phát hiện vật cản thấp sát mặt sàn (dưới 15cm) và chướng ngại vật treo trên cao.
* **Thanh cản va chạm cơ khí (Safety Bumper):** Bo quanh chân xe, kích hoạt ngắt phanh khẩn cấp cấp độ 2 khi chạm vật cản sát sườn.
* **Mâm kích nâng (Jacking Platform - Tùy chọn dòng GT):** Hành trình nâng tối đa **`55 mm (± 2mm)`**, tải trọng nâng tối đa **`300 kg`**. Chiều cao mặt bàn khi hạ là `210 mm`, khi nâng đạt `265 mm` cách mặt đất.
* **Chấu tiếp xúc sạc tự động (Charging Contact):** 2 bản cực đồng mạ vàng ở phía sau đuôi xe bên phải, dùng để kết nối với trạm sạc `E-YLH-10A`.
* **Hệ thống nút Dừng khẩn cấp (E-Stop):** Gồm 1 nút xoay trên trụ màn hình (Pole-mounted E-Stop) và 1 nút ở hông dưới chân xe (Bottom Side E-Stop).

### 1.2. Quy tắc An toàn Mặt sàn & Điểm mù Cảm biến
* **Yêu cầu mặt sàn:** Bằng phẳng, độ dốc ≤ 5°, gờ nổi ≤ 5mm, khe rãnh ≤ 20mm, hệ số ma sát tĩnh ≥ 1.0.
* **TUYỆT ĐỐI KHÔNG ĐÁNH BÓNG SÀN (WAXING):** Sàn dính sáp/dầu mỡ làm bánh xe bị trượt, dẫn đến trôi tọa độ và mất định vị SLAM.
* **Điểm mù quang học:** Mắt Lidar và Camera 3D nằm ở ĐẦU XE. **Hai bên sườn phía sau và đuôi xe là ĐIỂM MÙ.** Do đó, theo tiêu chuẩn quốc tế ISO 3691-4, xe không chạy lùi tự do ở tốc độ cao mà chỉ lùi có kiểm soát chậm (<0.1 m/s) khi lùi vào sạc hoặc lùi rút gầm kệ.

---

## PHẦN 2: KHỞI ĐỘNG THIẾT BỊ & CẤU HÌNH MẠNG IP TĨNH CỐ ĐỊNH

### 2.1. Quy trình Khởi động Xe
1. Nhấn giữ **Nút Nguồn (Power Button)** trên trụ xe 3 giây cho đến khi dải đèn LED phát sáng và màn hình HMI bật lên.
2. Kiểm tra các nút E-Stop: Xoay nhả theo chiều kim đồng hồ để đảm bảo nút E-Stop không bị nhấn kẹt.
3. Chờ màn hình tải hoàn tất giao diện ứng dụng **Ezhan AMR**.

### 2.2. Quy Tắc Thiết Lập Mạng IP Tĩnh (Static IP) & Bộ Phát Wi-Fi Riêng

> [!IMPORTANT]
> **LƯU Ý CỐT LÕI VỀ ĐỊA CHỈ IP KHI TRIỂN KHAI THỰC TẾ TẠI NHÀ MÁY:**  
> Toàn bộ các địa chỉ IP được nêu trong tài liệu này (như `192.168.1.61`, `192.168.1.100`, `192.168.1.35`...) **HOÀN TOÀN CHỈ LÀ VÍ DỤ THAM KHẢO MINH HỌA**.  
> Khi đến nhà máy lắp đặt thực tế, đội ngũ kỹ thuật sẽ **sử dụng 01 Bộ phát Wi-Fi chuyên dụng riêng** (hoặc dải mạng riêng do IT nhà máy cấp phát).
>
> **Nguyên tắc kỹ thuật bắt buộc phải tuân thủ:**
> 1. **Cùng chung Dải mạng (Subnet):** Cả 3 thiết bị gồm **Máy tính Server điều phối RCS, Robot AGV E300 và Hộp gọi Callbox** bắt buộc phải kết nối vào **cùng một Bộ phát Wi-Fi** (chung dải mạng, ví dụ dải `192.168.68.x`, `192.168.0.x`, `10.10.x.x`...).
> 2. **Phải đặt IP Tĩnh (Static IP):** Không được để chế độ cấp phát động DHCP tự đổi IP mỗi ngày. Phải đặt IP tĩnh cố định cho từng thiết bị theo dải IP của bộ phát Wi-Fi đó.

* **Ví dụ mẫu thiết lập IP tĩnh trên màn hình HMI của Robot:**
  1. Vào màn hình chính ➔ Chọn **System Settings ➔ Network Settings**.
  2. Kết nối vào SSID của **Bộ phát Wi-Fi riêng** mang theo (ưu tiên băng tần 5GHz hoặc 2.4GHz công nghiệp).
  3. Chuyển từ chế độ `DHCP` sang **`Static IP`**:
     * **IP Address:** `192.168.1.61` *(Ví dụ minh họa - Trên thực tế sẽ đặt theo dải IP của Bộ phát Wi-Fi, ví dụ `192.168.68.61`)*
     * **Gateway:** `192.168.1.1` *(Địa chỉ IP của chính Bộ phát Wi-Fi)*
     * **Netmask:** `255.255.255.0`
     * **DNS:** `8.8.8.8` hoặc `1.1.1.1`
  4. Bấm **Save (Lưu)** và ghi chép lại địa chỉ IP này để nhập vào phần mềm điều phối RCS.

---

## PHẦN 3: KẾT NỐI HỆ THỐNG ĐIỀU PHỐI TRUNG TÂM EZHAN RCS V2

Phiên bản **Robot Central Dispatch System Project2 (V2)** mang lại độ ổn định cao, hỗ trợ đa bản đồ và điều phối linh hoạt.

### 3.1. Cấu hình Cổng Mạng & Cơ sở dữ liệu
* **Web Nginx Dashboard:** Chạy tại cổng **`80`** (hoặc `8080`), truy cập qua trình duyệt: `http://127.0.0.1/` (hoặc `http://localhost:8080/`).
* **Backend Java Service (`Ezhan.jar`):** Chạy trên nền tảng **JDK 17**, lắng nghe API tại cổng **`8080`**.
* **Cơ sở dữ liệu MariaDB:** Cổng `3306`, Database: `Ezhan` (Tài khoản: `root` / Mật khẩu: `123456`).
* **License Key:** File [`config/license.key`](file:///C:/Users/Admin/Downloads/EZHAN/EZHAN/Robot%20Central%20Dispatch%20System%20Project2/config/license.key) chứa mã bản quyền được kích hoạt cố định theo địa chỉ MAC máy chủ của bạn.

### 3.2. Khởi chạy Hệ thống Bằng 1 Click (`start.bat`)
Chạy file [`start.bat`](file:///C:/Users/Admin/Downloads/EZHAN/EZHAN/Robot%20Central%20Dispatch%20System%20Project2/start.bat). Script sẽ tự động:
1. Chạy cập nhật cấu trúc cơ sở dữ liệu `update_schema.sql` (bổ sung các bảng `amr_charging_pile`, `amr_station_point`, `amr_elevator`, `amr_restrict_zone`).
2. Khởi động Redis Service và Nginx Web Server.
3. Chạy `Ezhan.jar` bằng môi trường Java di động `jdk-17`.
4. Mở trình duyệt đăng nhập: Tài khoản mặc định `admin` / Mật khẩu `admin123`.

---

## PHẦN 4: QUY TRÌNH QUÉT SLAM & TẠO BẢN ĐỒ MỚI

Tạo bản đồ SLAM là bước quan trọng nhất để Robot hiểu không gian xưởng.

```text
[1. Tạo New Map] ──> [2. Lái xe quét quanh xưởng] ──> [3. Save Map] ──> [4. Enter Map chốt định vị]
```

### 4.1. Khởi tạo Bản đồ trên HMI
1. Trên màn hình xe, vào: **System Settings ➔ Map Settings**.
2. Bấm nút **`New Map`** ➔ Nhập tên bản đồ gợi nhớ (Ví dụ: **`Esa_1`** - *Lưu ý viết đúng tên này để đồng bộ lên Web*).
3. Bấm **`Confirm`**.

### 4.2. Bốn Phương Pháp Lái Xe Quét Bản Đồ (Lựa chọn tùy điều kiện)

#### 👉 PHƯƠNG PHÁP 1: DÙNG CẦN GẠT ẢO TRÊN MÀN HÌNH XE (`Remote Ctrl` - Tiện nhất, không cần mua remote)
1. Trên màn hình Map Settings: Nhìn lên góc trên bên phải, gạt nút **`Remote Ctrl`** sang **BẬT (ON)**.
2. Một **Vòng tròn Joystick ảo màu xanh dương** sẽ xuất hiện trên màn hình.
3. Chạm ngón tay vào chấm tròn màu xanh và kéo rê theo hướng muốn xe đi:
   * Kéo lên: Xe tiến thẳng.
   * Kéo trái / phải: Xe xoay hướng.
   * Nhấc tay ra: Xe dừng lại an toàn.
4. Lái xe đi một vòng khép kín quanh xưởng để Lidar quét các mép tường.

#### 👉 PHƯƠNG PHÁP 2: DÙNG TAY CẦM KHÔNG DÂY (REMOTE JOYSTICK)
1. Nhấn nút trắng (**Wake-up Button**) trên tay cầm điều khiển. Đèn LED chuyển sang màu xanh lá sáng ổn định báo hiệu đã kết nối.
2. Dùng cần Joystick trên tay cầm nhẹ nhàng lái xe di chuyển quanh nhà xưởng với tốc độ chậm `0.3 - 0.5 m/s`.
3. *Ưu điểm:* Không cần nhấn nút E-Stop, xe tự động mở phanh lái bằng động cơ mượt mà.

#### 👉 PHƯƠNG PHÁP 3: CẮM CHUỘT / BÀN PHÍM KHÔNG DÂY VÀO CỔNG USB CỦA XE
1. Lấy đầu thu USB của Chuột không dây cắm vào cổng USB ở cạnh dưới hoặc bên hông màn hình xe.
2. Màn hình xe lập tức hiện con trỏ chuột máy tính.
3. Bật `Remote Ctrl` lên, bạn cầm chuột không dây đi sau xe nhấn giữ kéo cần Joystick ảo cực kỳ nhẹ nhàng, không lo giật lag!

#### 👉 PHƯƠNG PHÁP 4: ĐẨY TAY THỦ CÔNG (MANUAL PUSH WITH E-STOP)
1. Nhấn nút E-Stop ở hông xe xuống (Side E-Stop) để giải phóng phanh điện từ của bánh xe.
2. Dùng 2 tay đẩy từ từ xe di chuyển khắp các hành lang cần lập bản đồ.

### 4.3. Lưu Bản Đồ & Kích Hoạt Tự Động Định Vị (Relocalization)
1. Khi đã quét giáp một vòng xưởng về lại điểm xuất phát, bấm **`Save Map` (Lưu bản vẽ)**.
2. Bấm **`End Mapping` (Kết thúc quét)**.
3. Hộp thoại xác nhận hiện ra, bấm **`Enter Map` (Vào bản đồ)**.
4. Xe sẽ quét Lidar thời gian thực so khớp với bản đồ vừa lưu để chốt tọa độ. Khi dòng **`Position Confidence > 70%`** là bản đồ đã sẵn sàng hoạt động!

---

## PHẦN 5: THIẾT LẬP ĐIỂM LÀM VIỆC, VÙNG AN TOÀN & TƯỜNG ẢO

### 5.1. Thiết lập Điểm Làm việc Tiêu chuẩn (Work Locations)
1. Lái xe đến vị trí thực tế trên sàn (ví dụ trạm máy CNC hoặc kho nguyên liệu).
2. Vào menu: **Location ➔ Work Locations**:
   * Với map mới, bấm `Location from map` để đồng bộ.
   * Bấm **`Add location`** ➔ Đặt tên điểm (Ví dụ: `Esa_1_ahuy`, `Esa_1_acong`).
   * Bấm **`Update`** ➔ Sau khi thêm đủ các điểm, bấm **`Upload location`** để lưu cố định.

### 5.2. Vẽ Tường Ảo (Virtual Wall) - Ngăn Xe Chui Vào Khe Hẹp & Ngõ Cụt
Tường ảo giúp ngăn chặn triệt để tình huống xe né vật cản rồi chui vào ngách hẹp kẹt bánh:
1. Vào **System Settings ➔ Map Settings ➔ Chọn bản đồ `Esa_1`**.
2. Chọn công cụ **`Draw Area` ➔ Chọn `Virtual Wall` (Tường ảo)**.
3. Dùng tay chạm lên màn hình vẽ các vạch đỏ/vùng đỏ bịt kín các khoảng trống giữa các chân máy móc, ngõ cụt và khu vực nguy hiểm.
4. Bấm **`Save Drawing` ➔ `End Drawing`**. Xe sẽ coi đây là tường bê tông và tuyệt đối không bao giờ lách vào đó!

---

## PHẦN 6: CẤU HÌNH CƠ CHẾ SẠC TỰ ĐỘNG (AUTO-CHARGING) CHUẨN XÁC

Xe E300 sử dụng cơ chế lùi chấu tiếp xúc ở đuôi xe vào trạm sạc `E-YLH-10A` (54.75V / 10A).

```text
               ┌───────────────────────────────┐
               │    TRẠM SẠC ĐẶT SÁT TƯỜNG     │
               └──────────────┬────────────────┘
                              │
                    📍 ĐIỂM SẠC CHÍNH (Charge - Type 10)
                              ▲
                              │ Lùi thẳng chậm 0.8m (< 0.1 m/s)
                              │
               📍 ĐIỂM TIỀN TRẠM SẠC (Pre-charging - Type 11)
                     (Mũi tên hướng thẳng vào trạm sạc)
                              ▲
                              │ Xe chạy tiến tới đây rồi xoay 180° quay đuôi lại
                       [ROBOT E300]
```

### 6.1. Quy trình Lấy Tọa độ Điểm Sạc Chuẩn (Trang 44 User Manual)
1. Nhấn nút E-Stop, dùng tay đẩy lùi đuôi xe vào sát trạm sạc sao cho 2 bản cực đồng ở đuôi xe áp sát chấu trạm sạc (cách **`2 - 5 cm`**).
2. Xoay nhả E-Stop ➔ Vào **Location ➔ Special Locations ➔ Bấm `Update` tại dòng `Charge`**.
3. Ra màn hình chính bấm **`Return to charge`** để xe tự lùi cắm sạc vào trạm.
4. Khi màn hình hiện biểu tượng **Tia sét (Đang sạc)** ➔ Vào lại `Special Locations` bấm **`Update`** lần 2 để chốt tọa độ tiếp xúc tuyệt đối 100%.

### 6.2. Thiết lập Điểm Tiền Trạm Sạc (Pre-charging Point)
* Đặt 1 điểm dừng thẳng phía trước trạm sạc cách chấu sạc **`0.8m - 1.0m`** với mũi tên hướng thẳng vào trạm sạc.
* *Tác dụng:* Xe chạy tiến đến điểm này trước ➔ Xoay 180 độ quay đuôi xe lại ➔ Lùi thẳng tắp vào chấu sạc êm ái mà không bị lệch góc.

### 6.3. Bật Tự Động Về Sạc Khi Pin Yếu & Khi Rảnh Rỗi
* Vào **System Settings ➔ Basic Settings**:
  * Gạt **`Autonomous Charging = ON`** (Bật sạc tự động).
  * Ô **`Automatic Charging Threshold`**: Đặt là **`20%`** (khi pin dưới 20%, xe tự hủy task chờ và quay về sạc).
  * Bấm **`Save settings`**.

---

## PHẦN 7: CƠ CHẾ NHẬN DIỆN & NÂNG/HẠ KỆ HÀNG (LIFT / JACKING MODE)

Áp dụng cho dòng xe có cơ cấu mâm nâng kích điện/thủy lực chịu tải 300kg.

### 7.1. Kích thước Bàn nâng Chuẩn
* **Khi bàn nâng HẠ thấp nhất:** Mặt bàn cách mặt đất **`210 mm (21 cm)`**. Gầm giá kệ trong xưởng phải cao tối thiểu **`240 mm - 250 mm`** để xe chui lọt dễ dàng.
* **Hành trình nâng:** Kích đẩy lên cao **`55 mm (± 2mm)`**.
* **Khi bàn nâng NÂNG cao nhất:** Mặt bàn đạt độ cao **`265 mm`**, nhấc bổng 4 chân kệ cách mặt sàn **`1.5 cm - 2.5 cm`** để vận chuyển.

### 7.2. Cấu hình Kích thước Kệ Hàng Thực tế (`Shelf Settings` - Trang 72-75 User Manual)
Vào **System Settings ➔ Shelf**: Bấm `Add Shelf` (hoặc sửa `shelf_1`), dùng thước dây đo thực tế và nhập thông số:
* **`Shelf Width` / `Length`:** Chiều rộng và chiều dài mặt kệ (Ví dụ: `0.650 m` và `0.550 m`).
* **`Leg Center Distance (Width)`:** Khoảng cách đo từ tâm chân trái sang tâm chân phải (Ví dụ: `0.580 m`).
* **`Leg Center Distance (Length)`:** Khoảng cách đo từ tâm chân trước sang tâm chân sau (Ví dụ: `0.450 m`).
* **`Actual Leg Width`:** Độ dày thanh sắt chân kệ (Ví dụ: `0.040 m = 4cm`).
* **`Insertion Depth`:** Đặt **`-0.400 m`** (đối với kệ dài 0.5m - 0.6m để tâm xe nằm đúng giữa lòng kệ).
* **`Leg Expansion`:** Đặt **`0.250 m` đến `0.300 m`** (để 4 ô vuông xanh trên màn hình ôm trọn các chấm đỏ của chân kệ, tránh xe báo cản).
* Bấm nút màu xanh **`Used`** để kích hoạt mẫu kệ ➔ Bấm **`Save settings`**.

### 7.3. Tạo Chuỗi Tác vụ Nâng Hạ Tự động (Lift Mode Task Chain)
Vào màn hình chính ➔ Chọn ô màu tím **`Lift Mode` ➔ `Create task`** (đặt tên `NangKe_1`):
* **Dòng 1 (Điểm lấy kệ A):** Chọn hành động **`Recognizing lifting`** | `Stay Duration`: **`0s` hoặc `3s`**.
* **Dòng 2 (Điểm trả kệ B):** Chọn hành động **`Recognizing lowering`** | `Stay Duration`: **`0s` hoặc `3s`**.
* **Dòng 3 (Điểm rút xe C):** Chọn hành động **`Rời đi` (Move)** | `Stay Duration`: **`0s`**.
* Bấm **`Lưu tuyến (Save route)`**. Chọn tác vụ vừa tạo và bấm **`Start`** ➔ Xe tự động chạy đến A chui gầm nâng kệ lên, cõng sang B hạ xuống và tự động rút ra ngoài!

---

## PHẦN 8: CẤU HÌNH HỘP GỌI KHÔNG DÂY CALLBOX ĐIỀU KHIỂN ROBOT

Hộp gọi Callbox giao tiếp thời gian thực với Máy tính Server PC qua cổng WebSocket 8765.

```text
[HỘP GỌI CALLBOX] ──(WebSocket 8765)──> [SERVER PC EZHAN RCS] ──(HTTP POST 8068)──> [ROBOT E300]
  (VD: 192.168.X.35)                     (VD: 192.168.X.100)                     (VD: 192.168.X.61)
  └────────────────────── CÙNG DẢI MẠNG BỘ PHÁT WI-FI RIÊNG NHÀ MÁY ─────────────────────┘
```

> [!NOTE]
> *(Các IP trên chỉ là ví dụ tham khảo. Khi triển khai tại nhà máy, bạn sử dụng dải IP thực tế của Bộ phát Wi-Fi mang theo, chỉ cần đảm bảo Callbox, Server và Robot cùng lớp mạng).*

### 8.1. Quy tắc Cấu hình Bảng nút Hộp gọi trên Web RCS
Vào Web RCS: **Quản lý thiết bị ➔ Cấu hình hộp gọi ➔ Bấm Sửa (Edit)**:

1. **Thông tin chung:**
   * **`Tên hộp gọi`:** `callbox7`
   * **`IP thiết bị`:** Điền đúng IP tĩnh của Robot trên Bộ phát Wi-Fi (Ví dụ minh họa: `192.168.1.61`).
   * **`ICCID/IP`:** Điền đúng IP tĩnh của Hộp gọi hiển thị trên màn hình OLED (Ví dụ minh họa: `192.168.1.35`).
   * **`Tự động gán`:** Gạt sang **BẬT (Màu xanh)**.
2. **Cấu hình chi tiết 3 nút bấm:**
   * **Nút 1 (Giao hàng tiêu chuẩn):**
     * `Tên nút`: `giao`
     * `Tác vụ liên kết`: Điền trùng tên trạm `Esa_1_ahuy` (hoặc để trống).
     * `Trạm liên kết`: `Esa_1_ahuy`
     * `Loại thiết bị`: Chọn **`BZ`** *(xe tiêu chuẩn)*.
     * `Tự động phân bổ nút`: Bật XANH.
   * **Nút 2 (Chạy nhiệm vụ Nâng Hạ Kệ):**
     * `Tên nút`: `nangke`
     * `Tác vụ liên kết`: Điền chính xác **TÊN TÁC VỤ NÂNG** đã tạo trên xe (Ví dụ: `NangKe_1`).
     * `Trạm liên kết`: `Esa_1_ahuy`
     * `Loại thiết bị`: Chọn **`GT`** *(dòng lệnh dành riêng cho kích nâng Jacking)*.
     * `Tự động phân bổ nút`: Bật XANH.
   * **Nút 3 (Tự động về sạc pin):**
     * `Tên nút`: `sac`
     * `Tác vụ liên kết`: `Esa_1_sac` (hoặc để trống).
     * `Trạm liên kết`: `Esa_1_sac`
     * `Loại thiết bị`: Chọn **`BZ`**.
     * `Tự động phân bổ nút`: Bật XANH.
3. Bấm **`Xác nhận` (Lưu lại)**.

---

## PHẦN 9: ĐỒNG BỘ BẢN ĐỒ & ĐIỀU PHỐI ĐA XE TỪ XA QUA RCS

1. **Thêm bản đồ trên Web RCS:**
   * Vào **Quản lý bản đồ (Map Management) ➔ Bấm `+ Thêm`**.
   * Đặt **Tên bản đồ trùng khớp 100%** với tên trên màn hình xe (Ví dụ: `Esa_1`).
   * Bấm nút **`Đồng bộ bản đồ`** để tải toàn bộ sơ đồ đường đi và trạm làm việc về Server PC.
2. **Quản lý trạng thái xe (Robot Status):**
   * Vào **Trạng thái thiết bị**: Theo dõi mức pin (%), vị trí tọa độ thời gian thực, bản đồ hiện tại, và trạng thái `Idle` / `Running`.
   * Có thể ra lệnh trực tiếp: `Charge Task` (về sạc), `Go to Standby` (về điểm chờ), `Pause Task`, `Resume Task`, `Cancel Task`.

---

## PHẦN 10: SỔ TAY XỬ LÝ SỰ CỐ NHANH & BẢO TRÌ ĐỊNH KỲ

### 10.1. Bảng Chẩn đoán Sự cố Nhanh

| Hiện tượng | Nguyên nhân | Cách xử lý tức thì |
| :--- | :--- | :--- |
| **Bấm nút Hộp gọi báo "Đã nhận lệnh" nhưng xe đứng im** | Lệch IP hoặc ô `Tác vụ liên kết` điền sai chữ `delivery` / `Charge`. | Đổi IP cho khớp với thực tế; xóa trống ô `Tác vụ liên kết` hoặc điền trùng tên trạm đích. |
| **Hộp gọi báo "Nhiệm vụ thất bại"** | Xe đang đỗ tại trạm đích; hoặc sai tên trạm; hoặc xe chưa bấm Enter Map. | Kéo xe ra xa trạm 2 mét; đối chiếu tên trạm trên map; bấm Enter Map vào `Delivery Mode`. |
| **Vừa xong việc bấm lệnh mới xe khựng lại đèn xanh dương** | `Delivery Stay Duration` trên xe đang đếm ngược chờ bốc hàng (30s-60s). | Vào *System Settings ➔ Basic Settings* chỉnh `Delivery Stay Duration` về **`0s`**. |
| **Xe từ chối chạy do độ định vị thấp (`< 50%`)** | Robot mất phương hướng, thuật toán SLAM khóa phanh chống đâm va. | Bấm nút **Relocalization (Định vị lại)** trên màn hình xe hoặc lái xe ra giữa sàn quét lại tường. |
| **Gặp cản xe bật đèn ĐỎ, cản đi ra xe vẫn bị khóa đèn ĐỎ** | Bumper chân xe bị chạm hoặc Route Timeout. | Nhấn nút **E-Stop trên trụ rồi xoay nhả lên để Reset** (hoặc bấm `Resume Task` trên Web). |
| **Xe né cản chui vào khe hẹp/góc kẹt** | Bản đồ chưa vẽ Tường ảo ở các ngách máy móc. | Dùng công cụ `Virtual Wall` vẽ vạch đỏ bịt kín các ngách hẹp; hoặc chuyển sang `FIXED PATH MODE`. |
| **Nâng kệ lên rồi nhưng xe đứng im không chạy** | Thanh giằng kệ che mắt Lidar (18cm); hoặc 4 ô vuông xanh trong `Cấu hình kệ` chưa bao trọn chân kệ. | Kiểm tra mắt Lidar thông thoáng; tăng `Mở rộng chân = 0.30m` trong `Shelf Settings` để nuốt trọn chấm đỏ chân kệ. |

### 10.2. Quy tắc Vệ sinh & Bảo dưỡng Định kỳ
* **Mắt cảm biến Laser Lidar:** TUYỆT ĐỐI KHÔNG dùng nước, cồn hay hóa chất tẩy rửa để lau thấu kính laser. Chỉ dùng khăn lau kính microfiber chống tĩnh điện khô mềm để lau nhẹ bụi bẩn.
* **Chấu đồng trạm sạc & đuôi xe:** Dùng khăn khô vệ sinh bề mặt tiếp xúc đồng định kỳ mỗi tuần 1 lần để đảm bảo không bị oxy hóa hay bám bụi dẫn điện kém.
* **Pin Lithium 48V/15AH:** Nếu không sử dụng xe trong thời gian dài (trên 1 tháng), phải sạc đầy pin 100% và bật máy sạc bảo dưỡng lại 3 tháng một lần.

---

*(Tài liệu chuẩn hóa kỹ thuật và tối ưu vận hành AGV E300 - Bản quyền ESATECH Automation Systems © 2026).*
