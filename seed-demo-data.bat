@echo off
echo ============================================
echo   Local MongoDB Demo Data Setup
echo ============================================
echo.

cd backend

echo [1] Installing dependencies...
call npm install
echo.

echo [2] Seeding demo data to LOCAL MongoDB...
echo    Connection: mongodb://localhost:27017/school_app
echo.
node scripts\seedLocalDatabase.js

echo.
echo ============================================
echo   Setup Complete!
echo ============================================
echo.
echo Next steps:
echo   1. Start backend: npm start
echo   2. Run Flutter app
echo   3. Login with:
echo      - admin@school.com / admin123
echo      - teacher@school.com / teacher123
echo      - parent@school.com / parent123
echo.
pause

cd ..
