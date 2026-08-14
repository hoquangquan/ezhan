# Hệ Thống Xe Tự Hành AGV/AMR E300 Series & Phần Mềm Điều Phối Ezhan RCS

Chào mừng đến với dự án lưu trữ và vận hành hệ thống xe tự hành **E300 Series AGV/AMR** và phần mềm điều phối trung tâm **Ezhan RCS (Dispatching System)**.

Dự án này chứa toàn bộ các tài liệu gốc từ nhà sản xuất cũng như các tài liệu hướng dẫn kỹ thuật đã được biên dịch và tối ưu hóa để giúp người dùng vận hành, bảo trì và tích hợp hệ thống xe AGV một cách trơn tru nhất.

---

## 📚 Các Tài Liệu Gốc Của Dự Án

Dự án được xây dựng dựa trên 4 tài liệu kỹ thuật cốt lõi:
1. **`User Manual-E300 Series.pdf`**: Sổ tay hướng dẫn sử dụng phần cứng xe AGV E300, bao gồm các thành phần cơ học, nút bấm, hướng dẫn sử dụng nền tảng HMI (HCI), cách cấu hình IP, quét Laser SLAM tạo bản đồ, và các chế độ chạy task (Delivery, Cruise, Lift).
2. **`Dispatching System User Manual.pdf`**: Hướng dẫn cài đặt và sử dụng phần mềm điều phối Ezhan RCS trên máy chủ (Server PC) để quản lý đa xe, quản lý trạm sạc, đồng bộ bản đồ và giao task từ xa.
3. **`Robot Task API Documentation--ShowDoc.pdf`**: Tài liệu đặc tả API (tiếng Anh) dành cho lập trình viên để tích hợp hệ thống AGV với phần mềm WMS/ERP của nhà máy.
4. **`机器人任务接口文档--ShowDoc.pdf`**: Tài liệu đặc tả API (bản gốc tiếng Trung).

> 💡 **TÀI LIỆU KHUYÊN DÙNG:**
> Để dễ dàng tiếp cận nhất, vui lòng đọc file **[Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf](Huong_Dan_Ket_Noi_Va_Tao_Ban_Do_AGV_E300.pdf)** (File PDF Tiếng Việt do hệ thống biên soạn, bao gồm "Cheat Sheet" 5 bước cấu hình nhanh gọn).

---

## 🚀 Tính Năng Chính Của Hệ Thống

* **Điều Hướng Laser SLAM:** Định vị và vẽ bản đồ tự động hoàn toàn bằng Lidar 2D/3D kết hợp camera, không cần dán line từ tính hay mã QR trên mặt sàn.
* **Tự Động Tránh Vật Cản:** Tích hợp radar chống va chạm, tự động dừng hoặc đánh lái vòng qua vật cản.
* **Hệ Thống Điều Phối Tập Trung (RCS):** Quản lý tập trung nhiều xe AGV trên một giao diện Web duy nhất (`http://localhost:8080`).
* **Sạc Tự Động (Auto Charging):** Tự động trở về trạm sạc khi dung lượng pin xuống thấp (đặt ngưỡng tùy chỉnh, VD: 20%).
* **Đa Dạng Chế Độ Vận Hành (Task Modes):**
  - *Delivery Mode:* Giao nhận hàng đa điểm.
  - *Cruise Mode:* Tuần tra lặp lại nhiều vòng.
  - *Lift Mode:* Hỗ trợ module chui gầm và nâng kệ hàng.

---

## 🖥️ Yêu Cầu Cấu Hình Máy Chủ (RCS Server)

Để cài đặt và vận hành mượt mà phần mềm điều phối trung tâm Ezhan RCS, máy tính máy chủ cần đáp ứng tối thiểu:
- **Hệ điều hành:** Windows 10 (64-bit).
- **Vi xử lý (CPU):** Intel Core i5 thế hệ 8 trở lên.
- **Bộ nhớ (RAM):** Từ 8GB trở lên.
- **Lưu trữ:** Ổ đĩa C trống ít nhất 20GB (khuyến nghị SSD).
- **Mạng:** Card Wi-Fi kết nối ổn định với mạng nội bộ xưởng. Trình duyệt Google Chrome / Microsoft Edge.

---

## 🛠️ Luồng Khởi Tạo Nhanh (Quick Start)

Nếu bạn là kỹ thuật viên mới, hãy làm theo luồng thiết lập 5 bước sau:

1. **Khởi động & Cấp Mạng:** Bật nguồn AGV ➔ Vào HMI chọn `Network Settings` ➔ Kết nối Wi-Fi và đặt IP tĩnh.
2. **Quét Bản Đồ:** Vào `Map Settings` ➔ Tạo `New Map` ➔ Nhấn nút E-Stop (hông xe) để đẩy tay AGV quét không gian xưởng ➔ `Save Map` & `Enter Map` (định vị lại).
3. **Cài Đặt Vị Trí:** Đẩy xe tới các trạm lấy/trả hàng và trạm sạc ➔ Đánh dấu tọa độ vào `Work Locations` và `Special Locations`.
4. **Đồng Bộ Lên RCS:** Chép file bản đồ từ AGV ra máy tính PC chạy `Ezhan.exe` ➔ Truy cập Web Dashboard ➔ Tải bản đồ lên (`Map Management`) ➔ Bấm `Convert Map` ➔ Thêm IP xe vào danh sách (`Robot Management`).
5. **Chạy Task:** Phân công nhiệm vụ cho xe đi giao hàng/tuần tra trực tiếp trên HMI hoặc điều khiển từ xa qua màn hình máy chủ RCS.

---

## 🔗 Tích Hợp Hệ Thống (API Integration)

Hệ thống cung cấp đầy đủ các cổng API HTTP/REST để giao tiếp 2 chiều giữa phần mềm kho/nhà máy (WMS/MES) và Robot AGV.
- Xem chi tiết tại file `Robot Task API Documentation--ShowDoc.pdf`.
- Các tính năng hỗ trợ qua API:
  - Gửi lệnh điều động (Dispatch Task).
  - Hủy lệnh, tạm dừng, tiếp tục.
  - Truy vấn trạng thái xe (Pin, vị trí tọa độ, mã lỗi).
  - Truy vấn trạng thái hoàn thành của task.

---
*Mọi chi tiết thắc mắc về vận hành chuyên sâu, vui lòng tham khảo các hướng dẫn troubleshooting trong bộ tài liệu gốc hoặc file PDF tiếng Việt đính kèm dự án.*
