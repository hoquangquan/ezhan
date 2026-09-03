@echo off
title Ezhan Server Launcher (Project 2 with Portable JDK-17)
echo ========================================
echo       Starting Ezhan Services (V2)...
echo ========================================

set "CURRENT_DIR=%~dp0"
set "PORTABLE_JDK=C:\Users\Admin\Downloads\EZHAN\EZHAN\Robot Central Dispatch System Project\Robot central control system\jdk-17\bin\java.exe"
set "PORTABLE_MARIADB=C:\Users\Admin\Downloads\EZHAN\EZHAN\Robot Central Dispatch System Project\Robot central control system\mariadb\bin\mysqld.exe"
set "PORTABLE_MYSQL=C:\Users\Admin\Downloads\EZHAN\EZHAN\Robot Central Dispatch System Project\Robot central control system\mariadb\bin\mysql.exe"

:: =============================================
:: 0. Start MariaDB & Auto Migrate Database
:: =============================================
echo [0/4] Checking MariaDB (Database)...

tasklist /FI "IMAGENAME eq mysqld.exe" 2>nul | findstr "mysqld.exe" >nul
if errorlevel 1 (
    if exist "%PORTABLE_MARIADB%" (
        echo Starting portable MariaDB...
        start "MariaDB" /min "%PORTABLE_MARIADB%" --console
        timeout /t 3 /nobreak >nul
    )
)

echo Updating database schema to V2...
if exist "%PORTABLE_MYSQL%" (
    "%PORTABLE_MYSQL%" -u root -p123456 -f < "%CURRENT_DIR%update_schema.sql" >nul 2>&1
)

:: =============================================
:: 1. Start Redis
:: =============================================
:start_redis
echo [1/4] Starting Redis...

netstat -ano | findstr ":6379" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo Redis is already running, skipping...
    goto :start_nginx
)

cd /d "%CURRENT_DIR%Redis-x64-3.0.504"
start "Redis" /min redis-server.exe redis.windows.conf

echo Waiting for Redis...
set "redis_ok=0"
for /L %%i in (1,1,15) do (
    timeout /t 1 /nobreak >nul
    netstat -ano | findstr ":6379" | findstr "LISTENING" >nul
    if not errorlevel 1 (
        set "redis_ok=1"
        goto :redis_ready
    )
    <nul set /p "=."
)

:redis_ready
if "%redis_ok%"=="1" (
    echo.
    echo Redis started successfully!
) else (
    echo.
    echo [ERROR] Redis failed to start! Port 6379 not listening.
    pause
    exit /b 1
)

:: =============================================
:: 2. Start Nginx
:: =============================================
:start_nginx
echo [2/4] Starting Nginx...

tasklist /FI "IMAGENAME eq nginx.exe" 2>nul | findstr "nginx.exe" >nul
if not errorlevel 1 (
    echo Nginx is already running...
    goto :start_jar
)

cd /d "%CURRENT_DIR%nginx"
start "Nginx" /min nginx.exe

timeout /t 2 /nobreak >nul
echo Nginx started successfully!

:: =============================================
:: 3. Start Ezhan.jar with Portable JDK-17
:: =============================================
:start_jar
echo [3/4] Starting Ezhan.jar using Portable JDK-17...

cd /d "%CURRENT_DIR%"

taskkill /F /IM java.exe >nul 2>&1
timeout /t 1 /nobreak >nul

start "Ezhan Core Console" cmd /k ""%PORTABLE_JDK%" -jar Ezhan.jar --server.port=8080"

echo Waiting for Ezhan.jar to start on port 8080 (max 60s)...
set "jar_ok=0"
for /L %%i in (1,1,60) do (
    timeout /t 1 /nobreak >nul
    netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
    if not errorlevel 1 (
        set "jar_ok=1"
        goto :jar_ready
    )
    tasklist | findstr "java" >nul
    if errorlevel 1 goto :jar_crashed
    <nul set /p "=."
)

:jar_crashed
echo.
echo [ERROR] Ezhan.jar process exited! Look at the "Ezhan Core Console" window to see the exact error message.
pause
exit /b 1

:jar_ready
echo.
echo ========================================
echo       Ezhan.jar V2 STARTED SUCCESSFULLY!
echo ========================================

timeout /t 3 /nobreak >nul
start http://127.0.0.1/index

echo.
echo Press any key to close this launcher window (services keep running in background)
echo Run stop.bat to stop all services
echo.
pause >nul
