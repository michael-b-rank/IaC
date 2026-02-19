# Update the ISO path in your HCL file
$IsoPath = "C:\ISOs\en-us_windows_server_2022_x64_dvd_620d7eac.iso"
(Get-Content -Path ".\server2022.pkr.hcl") -replace 'default = ".*"', "default = `"$IsoPath`"" | Set-Content -Path ".\server2022.pkr.hcl"

Write-Host "HCL updated with ISO path: $IsoPath"