# MySQL Database Setup Guide

## Step 1: Install MySQL

### For Windows:
1. Download MySQL Installer from: https://dev.mysql.com/downloads/installer/
2. Run the installer
3. Choose "Developer Default" or "Server only"
4. Set a root password during installation (or leave blank for testing)
5. Complete the installation

### Alternative - Using XAMPP:
1. Download XAMPP from: https://www.apachefriends.org/
2. Install XAMPP
3. Start MySQL from XAMPP Control Panel
4. MySQL will be available on localhost:3306

## Step 2: Configure Database

### Option A: Using MySQL Workbench (Recommended)
1. Open MySQL Workbench
2. Connect to localhost
3. The database will be created automatically by the backend

### Option B: Using MySQL Command Line
```bash
mysql -u root -p
CREATE DATABASE school_app;
exit;
```

### Option C: Using XAMPP phpMyAdmin
1. Open http://localhost/phpmyadmin
2. Click "New" to create database
3. Enter name: `school_app`
4. Click "Create"

## Step 3: Configure Backend

Edit the `.env` file in the backend folder:

```env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=school_app
DB_USER=root
DB_PASSWORD=         # Add your MySQL root password here (leave blank if no password)
```

## Step 4: Seed Demo Data

Run the seeding script to create demo users, classes, and subjects:

```bash
cd backend
npm run seed
```

This will create:
- 2 Admin accounts
- 4 Teacher accounts  
- 2 Parent accounts
- 3 Classes (LKG A, Grade 1 B, Grade 5 C)
- 6 Subjects

## Step 5: Start the Server

```bash
cd backend
npm start
```

The server should start on http://localhost:3000

## Demo Credentials

**Admin:**
- Email: admin@school.com
- Password: admin123

**Teacher:**
- Email: johnson@school.com  
- Password: teacher123

**Parent:**
- Email: parent@school.com
- Password: parent123

## Troubleshooting

### MySQL Connection Error
- Make sure MySQL service is running
- Check if port 3306 is not blocked
- Verify username and password in `.env`

### Database Already Exists
- Run: `npm run seed` to recreate tables with demo data

### Port 3000 Already in Use
- Change PORT in `.env` file
- Or stop the process using port 3000
