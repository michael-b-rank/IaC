# 1. Set Execution Policy for the session
Set-ExecutionPolicy Bypass -Scope Process -Force

# 2. Force TLS 1.2 for NuGet/Gallery connectivity
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# 3. Install and Import the PSWindowsUpdate Module
Write-Host "Installing PSWindowsUpdate module..."
Install-Module -Name PSWindowsUpdate -Force -Confirm:$false -SkipPublisherCheck

# 4. Register the Windows Update Service (Required for fresh installs)
Write-Host "Registering Windows Update Service..."
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4b52d1ef396e" -Confirm:$false

# 5. Download and Install Updates
# -AcceptAll: Accepts EULAs automatically
# -AutoReboot: Allows the module to handle reboots if needed
# -Install: Executes the installation
Write-Host "Checking for and installing updates... This may take a while."
Get-WindowsUpdate -AcceptAll -Install