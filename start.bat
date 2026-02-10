@echo off
echo ========================================
echo   SkillBridge Quick Start
echo ========================================
echo.

echo [1/4] Checking Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ Docker is not installed or not running
    echo Please install Docker Desktop and try again
    pause
    exit /b 1
)
echo ✓ Docker is available

echo.
echo [2/4] Setting up environment...
if not exist .env (
    echo Copying environment template...
    copy .env.docker .env
    echo.
    echo ⚠️  IMPORTANT: Please update the following in .env:
    echo    - DB_PASSWORD: Change to a secure password
    echo    - BETTER_AUTH_SECRET: Generate a 32+ character secret
    echo.
    echo Press any key to continue after updating .env...
    pause >nul
)
echo ✓ Environment configured

echo.
echo [3/4] Starting services...
echo This may take a few minutes on first run...
docker-compose up --build -d

echo.
echo [4/4] Waiting for services to be ready...
timeout /t 10 /nobreak >nul

echo.
echo ========================================
echo   SkillBridge is Starting!
echo ========================================
echo.
echo Your application will be available at:
echo   🌐 Main App:  http://localhost
echo   📱 Client:    http://localhost:3000  
echo   🔧 API:       http://localhost:9000
echo.
echo To check service health: test-docker.bat
echo To manage services:      docker-manager.bat
echo.
echo Press any key to exit...
pause >nul