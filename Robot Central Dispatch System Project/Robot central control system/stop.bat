@echo off
title Ezhan Server Stopper
echo ========================================
echo        Stopping All Services...
echo ========================================

:: Stop MariaDB
echo [0/4] Stopping MariaDB...
taskkill /f /im mysqld.exe >nul 2>&1
if errorlevel 1 (
    echo MariaDB is not running or already stopped
) else (
    echo MariaDB stopped successfully!
)

:: Stop Nginx
echo [1/4] Stopping Nginx...
taskkill /f /im nginx.exe >nul 2>&1
if errorlevel 1 (
    echo Nginx is not running or already stopped
) else (
    echo Nginx stopped successfully!
)

:: Stop Redis
echo [2/4] Stopping Redis...
taskkill /f /im redis-server.exe >nul 2>&1
if errorlevel 1 (
    echo Redis is not running or already stopped
) else (
    echo Redis stopped successfully!
)

:: Stop Java Application
echo [3/4] Stopping Ezhan.jar...
set "java_stopped=0"
taskkill /f /im java.exe >nul 2>&1
if not errorlevel 1 set "java_stopped=1"
taskkill /f /im javaw.exe >nul 2>&1
if not errorlevel 1 set "java_stopped=1"
if "%java_stopped%"=="1" (
    echo Ezhan.jar stopped successfully!
) else (
    echo Ezhan.jar is not running or already stopped
)

echo ========================================
echo        All Services Stopped!
echo ========================================
pause
