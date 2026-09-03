-- Cập nhật cơ sở dữ liệu Ezhan lên phiên bản mới V2

USE `Ezhan`;

-- 1. Bổ sung các cột mới vào bảng nút bấm amr_call_box_button
ALTER TABLE `amr_call_box_button` ADD COLUMN `device_type` varchar(50) DEFAULT '' COMMENT '设备类型（GT/BZ，空表示两种车型随机呼叫）';
ALTER TABLE `amr_call_box_button` ADD COLUMN `device_ip` varchar(50) DEFAULT NULL COMMENT '绑定设备IP（按钮级固定绑定，空则按呼叫盒配置/自动分配）';
ALTER TABLE `amr_call_box_button` ADD COLUMN `auto_assign` char(1) DEFAULT '0' COMMENT '是否自动分配（0-否 1-是）';

-- 2. Bổ sung cột mới vào bảng tác vụ amr_task
ALTER TABLE `amr_task` ADD COLUMN `call_location` varchar(50) DEFAULT NULL COMMENT '呼叫目的地';

-- 3. Tạo bảng trạm sạc amr_charging_pile
CREATE TABLE IF NOT EXISTS `amr_charging_pile` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `pile_id` varchar(120) NOT NULL COMMENT '桩编号',
  `name` varchar(100) DEFAULT NULL COMMENT '站点名称',
  `dept_id` bigint DEFAULT NULL COMMENT '所属部门ID',
  `dept_name` varchar(64) DEFAULT NULL COMMENT '部门名称',
  `status` varchar(2) DEFAULT '0' COMMENT '状态（0空闲 1使用中 2停用）',
  `building` varchar(20) DEFAULT NULL COMMENT '楼栋',
  `floor` int DEFAULT NULL COMMENT '楼层',
  `map_name` varchar(200) DEFAULT NULL COMMENT '所在地图',
  `x` double DEFAULT NULL COMMENT '桩X坐标',
  `y` double DEFAULT NULL COMMENT '桩Y坐标',
  `yaw` double DEFAULT NULL COMMENT '桩朝向（弧度）',
  `in_use_by` bigint DEFAULT NULL COMMENT '占用机器人ID',
  `in_use_time` datetime DEFAULT NULL COMMENT '占用开始时间',
  `arrive_time` datetime DEFAULT NULL COMMENT '机器人确认到达时间',
  `device_ip` varchar(50) DEFAULT NULL COMMENT '来源机器人IP',
  `exclusive_device_id` bigint DEFAULT NULL COMMENT '专属机器人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pile_id` (`pile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='充电桩管理表';

-- 4. Tạo bảng điểm trạm amr_station_point
CREATE TABLE IF NOT EXISTS `amr_station_point` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '站点名称',
  `x` double NOT NULL COMMENT '站点X坐标',
  `y` double NOT NULL COMMENT '站点Y坐标',
  `yaw` double DEFAULT '0' COMMENT '站点朝向',
  `type` int DEFAULT '1' COMMENT '站点类型',
  `map_name` varchar(200) NOT NULL COMMENT '所属地图名称',
  `floor` varchar(10) DEFAULT '1' COMMENT '楼层',
  `device_ip` varchar(50) DEFAULT '' COMMENT '来源机器人IP',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AMR站点点位表';

-- 5. Tạo bảng thang máy amr_elevator
CREATE TABLE IF NOT EXISTS `amr_elevator` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `elevator_id` varchar(32) NOT NULL COMMENT '电梯编号',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  `dept_name` varchar(64) DEFAULT '' COMMENT '部门名称',
  `status` char(1) DEFAULT '0' COMMENT '状态（0空闲 1使用中 2停用）',
  `device_queue` varchar(500) DEFAULT '' COMMENT '排队机器人设备ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `floors` varchar(512) DEFAULT NULL COMMENT '电梯可到楼层',
  `building` varchar(50) DEFAULT NULL COMMENT '楼栋标识',
  `channel` int DEFAULT NULL COMMENT '通道号',
  `address` int DEFAULT NULL COMMENT '地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='电梯表';

-- 6. Tạo bảng vùng cấm amr_restrict_zone
CREATE TABLE IF NOT EXISTS `amr_restrict_zone` (
  `zone_id` bigint NOT NULL AUTO_INCREMENT COMMENT '区域ID',
  `zone_name` varchar(100) NOT NULL COMMENT '区域名称',
  `map_name` varchar(100) NOT NULL COMMENT '所属地图名称',
  `points` text COMMENT '多边形顶点JSON',
  `max_inside` int DEFAULT '1' COMMENT '区域内最大并发车数',
  `status` char(1) DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='区域避障限制表';
