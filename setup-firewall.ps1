# Quick Firewall Fix for School App Backend
# This script will attempt to add a firewall rule

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  School App Backend - Firewall Configuration" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  This script needs Administrator privileges" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please follow these steps:" -ForegroundColor White
    Write-Host "1. Right-click on PowerShell" -ForegroundColor White
    Write-Host "2. Select 'Run as Administrator'" -ForegroundColor White
    Write-Host "3. Run this command:" -ForegroundColor White
    Write-Host ""
    Write-Host "   netsh advfirewall firewall add rule name=`"School App Backend`" dir=in action=allow protocol=TCP localport=3000" -ForegroundColor Green
    Write-Host ""
    Write-Host "OR use this alternative:" -ForegroundColor White
    Write-Host "1. Open Windows Defender Firewall" -ForegroundColor White
    Write-Host "2. Click 'Advanced settings'" -ForegroundColor White
    Write-Host "3. Click 'Inbound Rules' → 'New Rule...'" -ForegroundColor White
    Write-Host "4. Select 'Port' → Next" -ForegroundColor White
    Write-Host "5. TCP, Specific local ports: 3000 → Next" -ForegroundColor White
    Write-Host "6. Allow the connection → Next" -ForegroundColor White
    Write-Host "7. Check all profiles → Next" -ForegroundColor White
    Write-Host "8. Name: School App Backend → Finish" -ForegroundColor White
    Write-Host ""
    pause
    exit
}

# If running as admin, add the rule
Write-Host "✅ Running as Administrator" -ForegroundColor Green
Write-Host ""

# Remove existing rule if present
Write-Host "Removing old firewall rule (if exists)..." -ForegroundColor Yellow
netsh advfirewall firewall delete rule name="School App Backend" 2>$null

# Add new rule
Write-Host "Adding firewall rule for port 3000..." -ForegroundColor Yellow
$result = netsh advfirewall firewall add rule name="School App Backend" dir=in action=allow protocol=TCP localport=3000

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Firewall rule added successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your phone should now be able to connect to:" -ForegroundColor White
    Write-Host "http://192.168.31.75:3000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Demo Login Credentials:" -ForegroundColor White
    Write-Host "  Admin:   admin@school.com / admin123" -ForegroundColor Green
    Write-Host "  Teacher: johnson@school.com / teacher123" -ForegroundColor Green
    Write-Host "  Parent:  parent@school.com / parent123" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Failed to add firewall rule" -ForegroundColor Red
    Write-Host "Please add it manually through Windows Defender Firewall" -ForegroundColor Yellow
}

Write-Host ""
pause
