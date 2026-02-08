@echo off
echo ========================================
echo   SkillBridge Docker Health Check
echo ========================================
echo.

echo [1/5] Checking Docker containers...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr skillbridge
echo.

echo [2/5] Testing Database...
docker exec skillbridge-db pg_isready -U postgres
if %errorlevel% equ 0 (
    echo ✓ Database is healthy
) else (
    echo ✗ Database is not responding
)
echo.

echo [3/5] Testing Server API...
curl -s http://localhost:10000/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ Server is healthy
) else (
    echo ✗ Server is not responding
)
echo.

echo [4/5] Testing Client...
curl -s -o nul -w "HTTP Status: %%{http_code}" http://localhost:3000
if %errorlevel% equ 0 (
    echo.
    echo ✓ Client is healthy
) else (
    echo ✗ Client is not responding
)
echo.

echo [5/5] Testing Nginx...
curl -s -o nul -w "HTTP Status: %%{http_code}" http://localhost
if %errorlevel% equ 0 (
    echo.
    echo ✓ Nginx is healthy
) else (
    echo ✗ Nginx is not responding
)
echo.

echo ========================================
echo   Health Check Complete!
echo ========================================
echo.
echo Access your application:
echo   - Main App (Nginx): http://localhost
echo   - Client Direct:    http://localhost:3000
echo   - Server API:       http://localhost:10000
echo.
echo To view logs:
echo   docker logs skillbridge-server
echo   docker logs skillbridge-client
echo.
pause
