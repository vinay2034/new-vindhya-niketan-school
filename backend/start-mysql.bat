@echo off
echo Starting XAMPP MySQL...
echo.

REM Check if XAMPP is installed
if not exist "C:\xampp\mysql_start.bat" (
    echo ERROR: XAMPP not found at C:\xampp\
    echo Please install XAMPP from https://www.apachefriends.org/
    pause
    exit /b 1
)

REM Start MySQL
cd C:\xampp
start mysql_start.bat

echo Waiting for MySQL to start...
timeout /t 5 /nobreak > nul

echo MySQL should now be running!
echo.
echo Next steps:
echo 1. Run: npm run seed     (to create database and demo data)
echo 2. Run: npm start        (to start the backend server)
echo.
pause
