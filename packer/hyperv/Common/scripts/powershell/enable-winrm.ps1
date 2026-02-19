cmd.exe /c winrm quickconfig -q
cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}
cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd.exe /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes
