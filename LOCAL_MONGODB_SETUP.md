# Local MongoDB Setup Guide

## 📦 Installation

### Step 1: Download MongoDB Community Server
1. Visit: https://www.mongodb.com/try/download/community
2. Select:
   - Version: Latest (7.0 or higher)
   - Platform: Windows x64
   - Package: MSI
3. Click **Download**

### Step 2: Install MongoDB
1. Run the downloaded `.msi` file
2. Choose **"Complete"** installation type
3. **Service Configuration:**
   - ✅ Install MongoDB as a Service
   - Service Name: MongoDB
   - Data Directory: `C:\Program Files\MongoDB\Server\7.0\data`
   - Log Directory: `C:\Program Files\MongoDB\Server\7.0\log`
4. **MongoDB Compass:**
   - ✅ Install MongoDB Compass (optional GUI tool - recommended for beginners)
5. Click **Install**

### Step 3: Verify Installation
Open PowerShell and run:
```powershell
mongod --version
mongo --version
```

If the commands are not recognized, add MongoDB to PATH:
```powershell
$env:Path += ";C:\Program Files\MongoDB\Server\7.0\bin"
```

### Step 4: Check MongoDB Service Status
```powershell
Get-Service MongoDB
```

Should show: **Status: Running**

If not running:
```powershell
Start-Service MongoDB
```

## 🔧 Backend Configuration

### Current Setup
Your backend is now configured to use **local MongoDB**:
- Connection String: `mongodb://localhost:27017/school_app`
- Database Name: `school_app`

### File: `backend/.env`
```env
MONGODB_URI=mongodb://localhost:27017/school_app
JWT_SECRET=your-secure-secret-key-here
PORT=3000
```

## 🗄️ Database Management

### Using MongoDB Compass (GUI)
1. Open **MongoDB Compass**
2. Connection String: `mongodb://localhost:27017`
3. Click **Connect**
4. You'll see your databases listed

### Using Command Line (mongosh)
```powershell
# Connect to MongoDB
mongosh

# Show databases
show dbs

# Use school_app database
use school_app

# Show collections
show collections

# View users
db.users.find().pretty()

# Count documents
db.users.countDocuments()
```

## 🚀 Running Your App with Local MongoDB

### 1. Ensure MongoDB Service is Running
```powershell
Get-Service MongoDB
```

### 2. Seed Demo Accounts (First Time Only)
```powershell
cd d:\myaiapp\backend
node scripts/seedDemoAccounts.js
```

### 3. Start Backend Server
```powershell
cd d:\myaiapp\backend
npm start
```

You should see:
```
✅ Server is running on port 3000
Connected to MongoDB
```

### 4. Test Connection
```powershell
# PowerShell test
$body = @{ email='admin@school.com'; password='admin123'; role='Admin' } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri 'http://localhost:3000/api/auth/login' -Body $body -ContentType 'application/json'
```

## 🔄 Switching Between Local and Atlas

### To Use Local MongoDB:
In `backend/.env`:
```env
MONGODB_URI=mongodb://localhost:27017/school_app
```

### To Use MongoDB Atlas (Cloud):
In `backend/.env`:
```env
MONGODB_URI=mongodb+srv://vinaykushwaha2050_db_user:Vin662034@cluster0.dli4wqx.mongodb.net/school_app?retryWrites=true&w=majority
```

**Note:** You'll need to re-seed demo accounts when switching databases.

## 🛠️ Troubleshooting

### MongoDB Service Won't Start
```powershell
# Check if port 27017 is already in use
netstat -ano | findstr ":27017"

# If process exists, kill it (replace PID)
Stop-Process -Id <PID> -Force

# Restart service
Restart-Service MongoDB
```

### Can't Connect to Database
1. Check MongoDB is running: `Get-Service MongoDB`
2. Check port: `netstat -ano | findstr ":27017"`
3. Check firewall (should allow localhost by default)
4. Verify connection string in `.env`

### Data Not Persisting
MongoDB stores data in: `C:\Program Files\MongoDB\Server\7.0\data`
Ensure this directory exists and has proper permissions.

## 📊 Advantages of Local MongoDB

✅ **No Internet Required** - Works offline
✅ **Faster** - No network latency
✅ **Free** - No Atlas limitations
✅ **Full Control** - Complete database access
✅ **Development** - Perfect for testing
✅ **Privacy** - Data stays on your machine

## 🌐 When to Use MongoDB Atlas

- Production deployment
- Team collaboration
- Remote access needed
- Automatic backups required
- Don't want to manage MongoDB installation

## 📝 Next Steps

After MongoDB is installed and running:
1. ✅ Configure `.env` file (already done)
2. ⏳ Seed demo accounts
3. ⏳ Start backend server
4. ⏳ Test login with Flutter app

---

**Need Help?** Check MongoDB documentation: https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-windows/
