@echo off
title Ezhan Server Launcher
echo ========================================
echo       Starting Ezhan Services...
echo ========================================

:: Get the directory where this script is located
set "CURRENT_DIR=%~dp0"

:: =============================================
:: 0. Start MariaDB
:: =============================================
echo [0/4] Starting MariaDB (Database)...

tasklist /FI "IMAGENAME eq mysqld.exe" 2>nul | findstr "mysqld.exe" >nul
if not errorlevel 1 (
    echo MariaDB is already running, skipping...
    goto :start_redis
)

cd /d "%CURRENT_DIR%"
start "MariaDB" /min "mariadb\bin\mysqld.exe" --console

timeout /t 3 /nobreak >nul

tasklist /FI "IMAGENAME eq mysqld.exe" 2>nul | findstr "mysqld.exe" >nul
if errorlevel 1 (
    echo [ERROR] MariaDB failed to start!
    pause
    exit /b 1
)
echo MariaDB started successfully!

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
    echo Nginx is already running, skipping...
    goto :start_jar
)

cd /d "%CURRENT_DIR%nginx"
start "Nginx" /min nginx.exe

timeout /t 2 /nobreak >nul

tasklist /FI "IMAGENAME eq nginx.exe" 2>nul | findstr "nginx.exe" >nul
if errorlevel 1 (
    echo [ERROR] Nginx failed to start!
    pause
    exit /b 1
)
echo Nginx started successfully!

:: =============================================
:: 3. Start Ezhan.jar
:: =============================================
:start_jar
echo [3/4] Starting Ezhan.jar...

cd /d "%CURRENT_DIR%"

:: Check Portable Java
if not exist "%CURRENT_DIR%jdk-17\bin\java.exe" (
    echo [ERROR] Portable Java 17 not found!
    pause
    exit /b 1
)

:: Launch jar in minimized window using portable Java on port 8081
start "Ezhan" /min "%CURRENT_DIR%jdk-17\bin\java.exe" -jar Ezhan.jar --server.port=8081

echo Waiting for Ezhan.jar to start (max 60s)...
set "jar_ok=0"
for /L %%i in (1,1,60) do (
    timeout /t 1 /nobreak >nul
    netstat -ano | findstr ":8081" | findstr "LISTENING" >nul
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
echo [ERROR] Ezhan.jar process exited unexpectedly!
pause
exit /b 1

:jar_ready
echo.
echo Ezhan.jar started successfully!

echo ========================================
echo       All services are running!
echo ========================================

timeout /t 3 /nobreak >nul
start http://127.0.0.1/index

echo.
echo Press any key to close this window (services keep running)
echo Run stop.bat to stop all services
echo.
pause >nul
