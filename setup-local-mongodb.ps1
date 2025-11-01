# Local MongoDB Quick Setup & Demo Data Script

Write-Host "🗄️  Local MongoDB Setup & Demo Data Seeding" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# Check if MongoDB is installed
Write-Host "🔍 Checking MongoDB installation..." -ForegroundColor Yellow

try {
    $mongoVersion = mongod --version 2>&1 | Select-String "db version"
    if ($mongoVersion) {
        Write-Host "✅ MongoDB is installed: $mongoVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ MongoDB is NOT installed!" -ForegroundColor Red
    Write-Host "`n📥 To install MongoDB:" -ForegroundColor Yellow
    Write-Host "   1. Download from: https://www.mongodb.com/try/download/community"
    Write-Host "   2. Choose: Windows x64 MSI"
    Write-Host "   3. Run installer with default settings"
    Write-Host "   4. Restart this script after installation`n"
    
    $install = Read-Host "Would you like to open the download page? (Y/N)"
    if ($install -eq 'Y' -or $install -eq 'y') {
        Start-Process "https://www.mongodb.com/try/download/community"
    }
    exit
}

# Check MongoDB service status
Write-Host "`n🔍 Checking MongoDB service..." -ForegroundColor Yellow
$mongoService = Get-Service -Name MongoDB -ErrorAction SilentlyContinue

if ($mongoService) {
    if ($mongoService.Status -eq 'Running') {
        Write-Host "✅ MongoDB service is running" -ForegroundColor Green
    } else {
        Write-Host "⚠️  MongoDB service is not running. Starting..." -ForegroundColor Yellow
        Start-Service MongoDB
        Start-Sleep -Seconds 2
        Write-Host "✅ MongoDB service started" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  MongoDB service not found. Checking if MongoDB is running..." -ForegroundColor Yellow
}

# Test MongoDB connection
Write-Host "`n🔌 Testing MongoDB connection..." -ForegroundColor Yellow
try {
    $testConnection = mongosh --eval "db.version()" --quiet 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ MongoDB is accessible" -ForegroundColor Green
    } else {
        throw "Connection failed"
    }
} catch {
    Write-Host "❌ Cannot connect to MongoDB" -ForegroundColor Red
    Write-Host "   Make sure MongoDB is running on port 27017" -ForegroundColor Yellow
    exit
}

# Update .env file to use local MongoDB
Write-Host "`n⚙️  Configuring backend to use local MongoDB..." -ForegroundColor Yellow

$envPath = ".\backend\.env"
if (Test-Path $envPath) {
    $envContent = Get-Content $envPath -Raw
    
    # Comment out Atlas and uncomment local
    $envContent = $envContent -replace '# MONGODB_URI=mongodb://localhost:27017/school_app', 'MONGODB_URI=mongodb://localhost:27017/school_app'
    $envContent = $envContent -replace '^MONGODB_URI=mongodb\+srv://', '# MONGODB_URI=mongodb+srv://'
    
    Set-Content -Path $envPath -Value $envContent
    Write-Host "✅ Backend configured for local MongoDB" -ForegroundColor Green
} else {
    Write-Host "❌ .env file not found at: $envPath" -ForegroundColor Red
    exit
}

# Seed demo data
Write-Host "`n🌱 Seeding demo data..." -ForegroundColor Yellow
Write-Host "   This will create users for Admin, Teacher, and Parent roles`n" -ForegroundColor Cyan

Set-Location -Path ".\backend"
node scripts\seedLocalDatabase.js

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Demo data seeded successfully!" -ForegroundColor Green
    Write-Host "`n🚀 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Start backend server: npm start"
    Write-Host "   2. Run Flutter app: flutter run -d <device_id>"
    Write-Host "   3. Login with demo credentials:`n"
    Write-Host "      Admin:   admin@school.com / admin123" -ForegroundColor White
    Write-Host "      Teacher: teacher@school.com / teacher123" -ForegroundColor White
    Write-Host "      Parent:  parent@school.com / parent123`n" -ForegroundColor White
} else {
    Write-Host "❌ Error seeding demo data" -ForegroundColor Red
}

Set-Location -Path ".."
