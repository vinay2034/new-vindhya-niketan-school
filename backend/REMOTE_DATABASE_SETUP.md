# Remote MySQL Database Setup Guide

## Database Information
- **Server:** srv471.hstgr.io (or IP: 31.170.160.52)
- **Database:** u839958024_myappdb
- **Username:** u839958024_myappdb
- **Password:** Vin@2034
- **Port:** 3306

## Current Status
❌ **Not Connected** - Your IP needs to be whitelisted

## Steps to Enable Remote Database Access

### 1. Whitelist Your IP Address in Hostinger

1. **Login to Hostinger**
   - Go to: https://hpanel.hostinger.com
   - Login with your credentials

2. **Navigate to Remote MySQL Settings**
   - Click on "Websites"
   - Select your website
   - Go to "Databases" section
   - Click on "Remote MySQL"

3. **Add Your IP Address**
   - Your current IP: **152.59.24.253**
   - Click "Add New IP"
   - Enter: `152.59.24.253`
   - OR enter `%` to allow from any IP (less secure)
   - Click "Add"

### 2. Update Backend Configuration

After whitelisting, switch to remote database:

```bash
cd d:\myaiapp\backend
copy .env.remote .env
```

Or manually edit `.env`:
```env
DB_HOST=srv471.hstgr.io
DB_PORT=3306
DB_NAME=u839958024_myappdb
DB_USER=u839958024_myappdb
DB_PASSWORD=Vin@2034
```

### 3. Seed Remote Database

```bash
npm run seed
```

This will create:
- Admin account: admin@school.com / admin123
- Teacher accounts
- Parent accounts
- Demo classes and subjects

### 4. Restart Backend

Stop the current backend and start it again:
```bash
npm start
```

## Benefits of Remote Database

✅ **No Firewall Issues** - Backend hosted on public server  
✅ **Accessible from Anywhere** - No need for port forwarding  
✅ **Persistent Data** - Data survives local machine restarts  
✅ **Production Ready** - Same setup as live deployment  

## Testing Local vs Remote

**Local Database (Current):**
- Backend: http://192.168.31.75:3000
- Requires: Local MySQL (XAMPP) + Firewall rules
- Best for: Development on same network

**Remote Database (After Setup):**
- Backend: http://192.168.31.75:3000 (or deploy backend to cloud)
- Requires: Only internet connection
- Best for: Testing from multiple devices/locations

## Troubleshooting

**Connection Timeout:**
- Verify IP is whitelisted in Hostinger
- Check if port 3306 is open (some ISPs block it)

**Access Denied:**
- Verify username/password in .env
- Check if database user has correct permissions

**Can't Access Hostinger Panel:**
- Contact Hostinger support
- They can whitelist your IP manually
