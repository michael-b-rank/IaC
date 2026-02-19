# build.pkr.hcl

build {
  # Load all blueprints defined in sources.pkr.hcl
  sources = [
    "source.hyperv-iso.windows-server",
    "source.hyperv-iso.ubuntu-server",
    "source.hyperv-iso.almalinux-server"
  ]

  # -------------------------------------------------------
  # WINDOWS PROVISIONING (Only runs on Windows Source)
  # -------------------------------------------------------
  
  provisioner "powershell" {
    only = ["source.hyperv-iso.windows-server"]
    inline = ["Write-Output 'WinRM Connected. Starting Windows Build...'"]
  }

  provisioner "powershell" {
    only   = ["source.hyperv-iso.windows-server"]
    script = "${path.root}/Common/scripts/powershell/install-updates.ps1"
  }

  provisioner "windows-restart" {
    only           = ["source.hyperv-iso.windows-server"]
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    only   = ["source.hyperv-iso.windows-server"]
    script = "${path.root}/Common/scripts/powershell/install.Chocolatey.ps1"
  }

  provisioner "powershell" {
    only = ["source.hyperv-iso.windows-server"]
    inline = [
      "Write-Output 'Running Sysprep...'",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
      "while($true) { $state = (Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State).ImageState; if($state -eq 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { break } Start-Sleep -s 5 }"
    ]
  }

  # -------------------------------------------------------
  # UBUNTU PROVISIONING (Debian/Apt Family)
  # -------------------------------------------------------
  
  provisioner "shell" {
  only = ["source.hyperv-iso.ubuntu-server"]
  inline = [
    "sudo apt-get install -y linux-image-virtual linux-cloud-tools-virtual",
    "echo 'Drivers verified. Starting Image Sealing...'",
    
    # Standard cleanup
    "sudo apt-get autoremove -y",
    "sudo apt-get clean",

    # Reset identity (Crucial for cloning in your lab)
    "sudo truncate -s 0 /etc/machine-id",
    "sudo rm -f /var/lib/dbus/machine-id",
    "sudo ln -s /etc/machine-id /var/lib/dbus/machine-id",
    
    # Clear cloud-init cache so it runs on the NEXT clone
    "sudo rm -rf /var/lib/cloud/instances/*",
    
    # Wipe history and shutdown
    "unset HISTFILE && history -c && rm -rf ~/.bash_history",
    "echo '${var.lin_ssh_password}' | sudo -S shutdown -P now"
  ]
}

  # -------------------------------------------------------
  # ALMALINUX PROVISIONING (RedHat/DNF Family)
  # -------------------------------------------------------
  
  provisioner "shell" {
  only = ["source.hyperv-iso.almalinux-server"]
  inline = [
    "echo 'Installing Hyper-V Guest Services for AlmaLinux...'",
    
    # Install the Hyper-V daemons (KVP, VSS, and FCOPY)
    "sudo dnf install -y hyperv-daemons",
    
    # Optional: Install standard cloud/enterprise tools
    "sudo dnf install -y curl jq git vim-enhanced",

    "echo 'Cleaning and Sealing Image...'",
    "sudo dnf autoremove -y",
    "sudo dnf clean all",

    # Reset identity (Industry standard for AlmaLinux)
    "sudo truncate -s 0 /etc/machine-id",
    "sudo rm -f /var/lib/dbus/machine-id",
    "sudo ln -s /etc/machine-id /var/lib/dbus/machine-id",

    # Final Shutdown
    "echo '${var.lin_ssh_password}' | sudo -S shutdown -P now"
  ]
}

}