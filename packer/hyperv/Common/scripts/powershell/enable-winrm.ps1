# 1. Force all network connections to 'Private' so WinRM is allowed through the firewall
$networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
$connections = $networkListManager.GetNetworkConnections()
$connections | ForEach-Object { $_.GetNetwork().SetCategory(1) }

# 2. Enable PowerShell Remoting
Enable-PSRemoting -Force

# 3. Apply the specific configurations Packer requires for the build
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value 1024

# 4. Explicitly open the Firewall for WinRM (HTTP Port 5985)
Enable-NetFirewallRule -DisplayGroup "Windows Remote Management"

# 5. Restart the service to guarantee changes take effect immediately
Restart-Service WinRM