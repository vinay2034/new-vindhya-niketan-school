# Demo Login Credentials

## ✅ Database: Connected to MongoDB Atlas
## ✅ Backend: Running on http://localhost:3000

## 📋 Test Accounts:

| Role    | Email                  | Password    |
|---------|------------------------|-------------|
| Admin   | admin@school.com       | admin123    |
| Teacher | teacher@school.com     | teacher123  |
| Parent  | parent@school.com      | parent123   |

## 🔧 To Run the App:

### 1. Start Backend:
```bash
cd d:\myaiapp\backend
npm start
```

### 2. Update Flutter API URL:
Edit: `d:\myaiapp\frontend\school_app\lib\services\auth_service.dart`

Find your PC's IP address:
```bash
ipconfig
```
Look for "IPv4 Address" (e.g., 192.168.1.100)

Update line 6-7 in auth_service.dart:
```dart
static const String baseUrl = 'http://YOUR_IP_HERE:3000/api';
```

### 3. Run Flutter App:
```bash
cd d:\myaiapp\frontend\school_app
flutter run -d TCQOXGYTLF8HUC9T
```

## 📝 Login Steps:
1. Select role (Admin/Teacher/Parent)
2. Enter email from the table above
3. Enter password
4. Click Login

## ⚠️ Important:
- Make sure backend is running before trying to login
- Make sure your phone and PC are on the same WiFi network
- Update the IP address in auth_service.dart to your PC's IP