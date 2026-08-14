@echo off
title Ezhan Server Launcher
echo ========================================
echo       Starting Ezhan Services...
echo ========================================

:: Get the directory where this script is located
set "CURRENT_DIR=%~dp0"

:: =============================================
:: 1. Start Redis
:: =============================================
echo [1/3] Starting Redis...

:: Check if Redis is already running on port 6379
netstat -ano | findstr ":6379" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo Redis is already running, skipping...
    goto :start_nginx
)

cd /d "%CURRENT_DIR%Redis-x64-3.0.504"
start "Redis" /min redis-server.exe redis.windows.conf

:: Wait up to 15 seconds for Redis port to be ready
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
    echo Check redis.windows.conf in Redis-x64-3.0.504 folder.
    pause
    exit /b 1
)

:: =============================================
:: 2. Start Nginx
:: =============================================
:start_nginx
echo [2/3] Starting Nginx...

:: Check if Nginx is already running
tasklist /FI "IMAGENAME eq nginx.exe" 2>nul | find "nginx.exe" >nul
if not errorlevel 1 (
    echo Nginx is already running, skipping...
    goto :start_jar
)

cd /d "%CURRENT_DIR%nginx"
start "Nginx" /min nginx.exe

timeout /t 2 /nobreak >nul

tasklist /FI "IMAGENAME eq nginx.exe" 2>nul | find "nginx.exe" >nul
if errorlevel 1 (
    echo [ERROR] Nginx failed to start!
    echo Check nginx config or port conflicts.
    pause
    exit /b 1
)
echo Nginx started successfully!

:: =============================================
:: 3. Start Ezhan.jar
:: =============================================
:start_jar
echo [3/3] Starting Ezhan.jar...

cd /d "%CURRENT_DIR%"

:: Check Java
java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java not found! Please install JDK.
    echo Download: https://adoptium.net
    pause
    exit /b 1
)

:: Launch jar in minimized window
start "Ezhan" /min java -jar Ezhan.jar

:: Wait up to 60 seconds for HTTP port 8080
echo Waiting for Ezhan.jar to start (max 60s)...
set "jar_ok=0"
for /L %%i in (1,1,60) do (
    timeout /t 1 /nobreak >nul
    netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
    if not errorlevel 1 (
        set "jar_ok=1"
        goto :jar_ready
    )
    :: Check if java process is still alive
    tasklist | find "java" >nul
    if errorlevel 1 goto :jar_crashed
    <nul set /p "=."
)

:jar_crashed
echo.
echo [ERROR] Ezhan.jar process exited unexpectedly!
echo Run the following command manually to see the error:
echo   cd /d "%CURRENT_DIR%"
echo   java -jar Ezhan.jar
pause
exit /b 1

:jar_ready
echo.
echo Ezhan.jar started successfully!

echo ========================================
echo       All services are running!
echo ========================================

:: Wait 3 seconds for full initialization
timeout /t 3 /nobreak >nul

:: Open browser
start http://127.0.0.1/index

echo.
echo Press any key to close this window (services keep running)
echo Run stop.bat to stop all services
echo.
pause >nul
