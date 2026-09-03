# Bộ Sơ Đồ Phân Tích Hệ Thống Xe Tự Hành AGV E300 & Ezhan RCS

Tài liệu này cung cấp cái nhìn chuyên sâu về kiến trúc kết nối, luồng trạng thái, quy trình vận hành và điều khiển tín hiệu của toàn bộ hệ thống Robot AGV E300.

---

## 1. Sơ Đồ Kiến Trúc Hệ Thống (System Architecture & Connection Diagram)
Sơ đồ này mô tả cách phần cứng trên xe AGV giao tiếp với máy chủ trung tâm Ezhan RCS và hệ thống phần mềm của nhà máy (WMS/ERP).

```mermaid
graph TD
    %% Định nghĩa Node %%
    subgraph AGV["Phần Cứng Xe Tự Hành (AGV E300)"]
        HMI["Màn hình cảm ứng HMI"]
        MainCtrl["Bộ điều khiển chính (Host Computer)"]
        Motor["Động cơ / Bánh xe (Drive Wheels)"]
        Brake["Phanh điện từ & Cảm biến va chạm (Bumper)"]
        Lidar["Cảm biến Laser Lidar (SLAM)"]
        Cam3D["Camera 3D (Tránh vật cản)"]
        Battery["Pin Lithium & Mạch quản lý BMS"]
        
        Lidar -->|Dữ liệu đám mây điểm| MainCtrl
        Cam3D -->|Hình ảnh chiều sâu| MainCtrl
        MainCtrl -->|Tín hiệu điều khiển| Motor
        Brake -.->|Ngắt động cơ khi va chạm| Motor
        Battery -->|Cấp nguồn| MainCtrl
        HMI <-->|Giao diện điều khiển| MainCtrl
    end

    subgraph Network["Hạ tầng Mạng (Network)"]
        WiFi["Router Wi-Fi Công Nghiệp"]
        Switch["Network Switch"]
    end

    subgraph Server["Máy Chủ Trung Tâm (Ezhan RCS)"]
        RCS_Core["Ezhan Core Service (Port 8080)"]
        DB["Cơ sở dữ liệu (Map, Task, Robot logs)"]
        UI["Web Dashboard"]
        
        RCS_Core <--> DB
        RCS_Core <--> UI
    end

    subgraph Factory["Hệ Thống Nhà Máy (3rd Party)"]
        WMS["Hệ thống QL Kho (WMS)"]
        MES["Hệ thống Điều hành SX (MES)"]
        API_GW["API Gateway (REST HTTP/JSON)"]
    end

    %% Kết nối luồng dữ liệu %%
    MainCtrl <-->|Giao thức TCP/UDP (IP Tĩnh)| WiFi
    WiFi <--> Switch
    Switch <-->|Cáp LAN| RCS_Core

    RCS_Core <-->|Gọi API| API_GW
    API_GW <--> WMS
    API_GW <--> MES
```

---

## 2. Sơ Đồ Trạng Thái Của AGV (AGV State Machine Diagram)
Mô tả các trạng thái sinh mệnh của AGV từ lúc bật máy đến khi sạc pin hoặc gặp lỗi.

```mermaid
stateDiagram-v2
    [*] --> Powered_Off: Xe chưa bật nguồn
    Powered_Off --> Initializing: Bật nút Power
    Initializing --> Standby: Boot xong hệ thống / Kết nối Mạng
    
    Standby --> Mapping_Mode: Chọn "New Map" trên HMI
    Mapping_Mode --> Standby: "End Mapping" / "Enter Map"
    
    Standby --> Task_Executing: Nhận Lệnh (Từ HMI hoặc RCS)
    Task_Executing --> Task_Completed: Đến đích hoàn thành
    Task_Completed --> Standby
    
    Task_Executing --> Obstacle_Detected: Radar/Camera phát hiện vật cản
    Obstacle_Detected --> Task_Executing: Vật cản rời đi
    Obstacle_Detected --> Error_Soft_Stop: Tránh không được (Timeout)
    
    Standby --> E_Stop_Triggered: Bấm nút E-Stop
    Task_Executing --> E_Stop_Triggered: Bấm nút E-Stop / Đâm trúng Bumper
    E_Stop_Triggered --> Initializing: Mở khóa E-stop & Reset
    
    Standby --> Auto_Charging: Pin thấp (<20%) / Hết task
    Auto_Charging --> Standby: Pin đầy (100%)
```

---

## 3. Sơ Đồ Luồng Vận Hành (Operational Flowchart)
Quy trình thao tác logic (Standard Operating Procedure) từ lúc bóc hộp đến lúc xe chạy thực tế.

```mermaid
flowchart TD
    Start([Bắt đầu: Mở hộp AGV]) --> KhởiĐộng(Bật Nguồn & Cấp IP Tĩnh)
    KhởiĐộng --> TaoBanDo{Có bản đồ nhà máy chưa?}
    TaoBanDo -->|Chưa có| QuetMap[Nhấn E-Stop hoặc dùng Remote lái xe đi quét SLAM]
    QuetMap --> LuuMap[Lưu bản đồ & Tự động định vị - Relocalization]
    TaoBanDo -->|Đã có| EnterMap[Chọn bản đồ cũ & Enter Map]
    LuuMap --> ChonDiem
    EnterMap --> ChonDiem
    
    ChonDiem[Đẩy xe đến thực địa, thiết lập Work Locations & Charging Station]
    ChonDiem --> XuatMap[Export file Bản đồ từ AGV sang USB]
    XuatMap --> UpRCS[Import file vào máy chủ, dùng Ezhan RCS Convert Map]
    UpRCS --> AddXe[Thêm IP xe vào phần Robot Management]
    
    AddXe --> Mode{Chọn chế độ chạy}
    Mode -->|Chạy bằng tay trên xe| DeliveryMode[Vào Delivery Mode chọn điểm và bấm Start]
    Mode -->|Điều phối tự động| RCSMode[Mở Web RCS, tạo Task chỉ định Station ID]
    
    DeliveryMode --> Chay(AGV tự động né vật cản & di chuyển)
    RCSMode --> Chay
    
    Chay --> KetThuc([Hoàn thành nhiệm vụ])
```

---

## 4. Sơ Đồ Điều Khiển Tín Hiệu (Control Sequence Diagram)
Mô phỏng quá trình giao tiếp (Ping-Pong) khi Hệ thống WMS của nhà máy gọi lệnh thông qua RCS để điều AGV đi lấy hàng.

```mermaid
sequenceDiagram
    participant WMS as WMS/MES (Factory)
    participant API as Ezhan API Gateway
    participant RCS as Ezhan RCS Core
    participant AGV as AGV E300 (Main Controller)

    WMS->>API: POST /api/task (Giao task chuyển hàng tới Station_A)
    API->>RCS: Xác thực yêu cầu & Giải mã JSON
    RCS->>RCS: Phân bổ xe rảnh (Đang ở trạng thái Standby)
    
    RCS->>AGV: Gửi lệnh di chuyển (Destination: Station_A)
    AGV-->>RCS: ACK (Đã nhận lệnh, trạng thái chuyển sang Task_Executing)
    RCS-->>WMS: Task Created (Trả về Task ID)

    loop Quá trình di chuyển
        AGV->>AGV: Cập nhật Lidar & Lập lộ trình thời gian thực
        AGV-->>RCS: Heartbeat (Báo cáo Tọa độ X,Y & Dung lượng Pin)
        alt Gặp vật cản
            AGV->>AGV: Dừng tạm thời / Đánh lái né tránh
            AGV-->>RCS: Báo cáo trạng thái (Obstacle Detected)
        end
    end
    
    AGV->>AGV: Đến Station_A (Phanh dừng)
    AGV-->>RCS: Task Completed (Hoàn thành nhiệm vụ)
    RCS->>RCS: Cập nhật CSDL (Xe về trạng thái Standby)
    
    RCS->>WMS: CallBack / Webhook (Báo cáo đã tới nơi)
    WMS->>WMS: Báo nhân viên bốc dỡ hàng
```
