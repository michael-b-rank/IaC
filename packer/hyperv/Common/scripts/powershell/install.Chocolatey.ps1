# 1. Set Execution Policy to allow the script to run
Set-ExecutionPolicy Bypass -Scope Process -Force

# 2. Force TLS 1.2 (Crucial for Server 2022 to talk to GitHub/Chocolatey)
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# 3. Download and Run the Install Script
Write-Host "Downloading and Installing Chocolatey..."
$ChocoInstallScript = ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Invoke-Expression $ChocoInstallScript

# 4. Refresh Environment Variables (So 'choco' works in this window)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 5. Verification
Write-Host "Verifying installation..."
choco --version

choco install git micro sysinternals 7zip.install iperf3 jq curl -y
choco install powershell-core starship -y

#USAGE-git = git clone https://github.com/YourRepo/lab-infra.git
#USAGE-micro (editor) = micro server2022.pkr.hcl
#USAGE-iperf3 = iperf3 -c <IPv4>
#USAGE-jq = pipe output of AzureCLI, Docker, K8S configs
#USAGE-7zip.install = 