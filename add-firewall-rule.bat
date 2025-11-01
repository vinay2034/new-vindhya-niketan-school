@echo off
echo Adding Windows Firewall rule for School App Backend...
echo.
echo This requires Administrator privileges.
echo Right-click this file and select "Run as administrator"
echo.

powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"netsh advfirewall firewall delete rule name=\"\"School App Backend\"\"; netsh advfirewall firewall add rule name=\"\"School App Backend\"\" dir=in action=allow protocol=TCP localport=3000; Write-Host \"\"Firewall rule added successfully!\"\"; pause\"' -Verb RunAs"
