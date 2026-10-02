@echo off
chcp 65001 >nul
title KIỂM TRA ĐƯỜNG TRUYỀN MẠNG 13 THIẾT BỊ HỆ THỐNG AGV E300
color 0F
cls

echo ===============================================================================
echo       CÔNG CỤ KIỂM TRA MẠNG THỜI GIAN THỰC - DỰ ÁN AGV E300 & CALLBOX
echo       Dải mạng: 192.168.127.x (Master Moxa, 4 Trạm TP-Link, Robot & 6 Callbox)
echo ===============================================================================
echo.

setlocal enabledelayedexpansion

:: Danh sách IP và Tên thiết bị
set "IP_00=192.168.127.1"  & set "NAME_00=Master MOXA AWK-1131A (Trạm chính)"
set "IP_01=192.168.127.55" & set "NAME_01=TP-LINK TL-AP300DG #1 (Trạm phụ 1)"
set "IP_02=192.168.127.80" & set "NAME_02=TP-LINK TL-AP300DG #2 (Trạm phụ 2)"
set "IP_03=192.168.127.72" & set "NAME_03=TP-LINK TL-AP1900DG #1 (Trạm phụ 3)"
set "IP_04=192.168.127.86" & set "NAME_04=TP-LINK TL-AP1900DG #2 (Trạm phụ 4)"
set "IP_05=192.168.127.86" & set "NAME_04=TP-LINK TL-AP1900DG #2 (Trạm phụ 5)"
set "IP_06=192.168.127.77" & set "NAME_05=Máy Chủ Server PC (Ezhan RCS V2)"
set "IP_07=192.168.127.53" & set "NAME_06=Robot AGV E300 (AMR003)"
set "IP_08=192.168.127.75" & set "NAME_07=Hộp Gọi Callbox 01 (Trạm 1)"
set "IP_09=192.168.127.93" & set "NAME_08=Hộp Gọi Callbox 02 (Trạm 2)"
set "IP_10=192.168.127.87" & set "NAME_09=Hộp Gọi Callbox 03 (Trạm 3)"
set "IP_11=192.168.127.95" & set "NAME_10=Hộp Gọi Callbox 04 (Trạm 4)"
set "IP_12=192.168.127.54" & set "NAME_11=Hộp Gọi Callbox 05 (Trạm 5)"
set "IP_13=192.168.127.83" & set "NAME_12=Hộp Gọi Callbox 06 (Trạm 6)"
set "IP_14=192.168.127.51" & set "NAME_04=Hộp Gọi Callbox 07 (Trạm 7)"

set count_online=0
set count_offline=0

for /L %%i in (0,1,12) do (
    set idx=0%%i
    set idx=!idx:~-2!
    
    set ip=!IP_%%i!
    set name=!NAME_%%i!
    
    <nul set /p "=Đang kiểm tra !ip! (!name!)... "
    
    ping -n 1 -w 800 !ip! | findstr /i "TTL=" >nul
    if !errorlevel! equ 0 (
        echo [ONLINE - THÔNG MẠNG]
        set /a count_online+=1
    ) else (
        echo [OFFLINE / MẤT KẾT NỐI]
        set /a count_offline+=1
    )
)

echo.
echo ===============================================================================
echo KẾT QUẢ TỔNG HỢP:
echo  - Thiết bị ONLINE : !count_online! / 13 thiết bị
echo  - Thiết bị OFFLINE: !count_offline! / 13 thiết bị
echo ===============================================================================
echo.
echo Bấm phím bất kỳ để đóng cửa sổ...
pause >nul
