@echo off
echo SkillBridge Docker Manager
echo ========================

:menu
echo.
echo 1. Build and run development environment
echo 2. Build and run production environment
echo 3. Stop all containers
echo 4. View logs
echo 5. Clean up (remove containers and images)
echo 6. Exit
echo.
set /p choice="Choose an option (1-6): "

if "%choice%"=="1" goto dev
if "%choice%"=="2" goto prod
if "%choice%"=="3" goto stop
if "%choice%"=="4" goto logs
if "%choice%"=="5" goto cleanup
if "%choice%"=="6" goto exit
echo Invalid choice. Please try again.
goto menu

:dev
echo Starting development environment...
docker-compose -f docker-compose.dev.yml up --build
goto menu

:prod
echo Starting production environment...
copy .env.docker .env
docker-compose up --build -d
echo Production environment started!
echo Client: http://localhost:3000
echo Server: http://localhost:9000
echo Nginx: http://localhost:80
goto menu

:stop
echo Stopping all containers...
docker-compose down
docker-compose -f docker-compose.dev.yml down
echo All containers stopped.
goto menu

:logs
echo Showing logs...
docker-compose logs -f
goto menu

:cleanup
echo Cleaning up containers and images...
docker-compose down -v --rmi all
docker system prune -f
echo Cleanup complete.
goto menu

:exit
echo Goodbye!
exit