# 1. Set up the workspace
$AdkUrl = "https://go.microsoft.com/fwlink/?linkid=2196127"
$Installer = "C:\adksetup.exe"

# 2. Download the official ADK Installer from Microsoft
Write-Host "Downloading Windows ADK..."
Invoke-WebRequest -Uri $AdkUrl -OutFile $Installer

# 3. Install ONLY the Deployment Tools (Contains oscdimg.exe)
# This prevents downloading the massive 2GB+ kit; we just get the tools we need.
Write-Host "Installing Deployment Tools (this may take 2-3 minutes)..."
Start-Process -FilePath $Installer -ArgumentList "/quiet", "/installpath c:\ADK", "/features OptionId.DeploymentTools" -Wait

# 4. Add 'oscdimg' to the System Path
$OscdPath = "c:\ADK\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($CurrentPath -notlike "*$OscdPath*") {
    $NewPath = $CurrentPath + ";" + $OscdPath
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")
    Write-Host "Path updated."
}

# 5. Clean up installer
Remove-Item -Path $Installer -ErrorAction SilentlyContinue

# 6. FORCE REFRESH of Environment Variables for the current session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 7. Verify
Write-Host "Verifying oscdimg..."
oscdimg -version