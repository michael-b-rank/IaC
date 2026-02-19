// --- WINDOWS SOURCE ---
source "hyperv-iso" "windows-server" {
  
  // Use Common Vars
  cpus         = var.common_cpus
  memory       = var.common_memory
  generation  =  var.common_generation
  switch_name  = var.common_switch
  #output_directory = "${var.common_output_path}/${var.win_image_name}"
  
  // Use Windows Specific Vars
  vm_name      = var.win_image_name
  iso_url      = "${var.common_iso_path}${var.win_iso_name}"
  iso_checksum = var.win_iso_checksum
  
  // WinRM specific logic
  communicator   = "winrm"
  winrm_username = var.win_admin_user
  winrm_password = var.win_admin_password
  winrm_timeout  = "4h"

  // DYNAMIC CONTENT GENERATION
  cd_content = {
    "Autounattend.xml" = templatefile("${path.root}/Common/windows-config/Autounattend.pkrtpl.hcl", {
      AdminPassword     = var.win_admin_password
      ProductKey        = var.win_productkey
      EditionIndexKey   = var.win_edition_index_key
      EditionIndexValue = var.win_edition_index_value
    })
  }

  // Boot config - Static Script
  cd_files = ["${path.root}/Common/scripts/powershell/enable-winrm.ps1","${path.root}/Common/scripts/powershell/install.Chocolatey.ps1","${path.root}/Common/scripts/powershell/install-updates.ps1"]

  boot_wait    = "2s"
  boot_command = ["<space><space><space><space><space>"]

  shutdown_command = "powershell -Command \"Stop-Computer -Force\""
}





// --- UBUNTU SOURCE ---
source "hyperv-iso" "ubuntu-server" {
  // Use Common Vars
  cpus         = var.common_cpus
  memory       = var.common_memory
  switch_name  = var.common_switch
  #output_directory = "${var.common_output_path}/${var.lin_ubuntuimage_name}"

  
  // Use Ubuntu Specific Vars
  vm_name      = var.lin_ubuntuimage_name
  iso_url      = "${var.common_iso_path}${var.lin_ubuntuiso_name}"
  iso_checksum = var.lin_ubuntuiso_checksum
  
  // SSH settings
  communicator = "ssh"
  ssh_username = var.lin_ssh_user
  ssh_password = var.lin_ssh_password
  ssh_timeout  = "1h"

  // --------------------------------------------------------
  // DYNAMIC HTTP SERVER (The Linux version of cd_content)
  // --------------------------------------------------------
  http_content = {
    "/user-data" = templatefile("${path.root}/Common/ubuntu-config/user-data.pkrtpl.hcl", {
      Hostname     = var.lin_ubuntuimage_name
      Username     = var.lin_ssh_user

      # This hashes your Password instantly so Linux accepts it
      PasswordHash = bcrypt(var.lin_ssh_password)
      ExtraPackages = var.vm_guest_packages
    })
    "/meta-data" = "" # Required by cloud-init but can be empty
  }

  // --------------------------------------------------------
  // BOOT COMMAND (Fixed for Ubuntu 22.04+)
  // --------------------------------------------------------
  boot_command = [
    "<esc><wait>",
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter>"
  ]

  shutdown_command = "echo '${var.lin_ssh_password}' | sudo -S shutdown -P now"
}










// --- ALMALINUX 10 SOURCE ---
source "hyperv-iso" "almalinux-server" {
  // --- Hardware Configuration ---
  cpus             = var.common_cpus
  memory           = var.common_memory
  generation       = 2
  switch_name      = var.common_switch
  enable_secure_boot = false      // Secure Boot can block the Kickstart handoff on some ISOs
  #output_directory = "${var.common_output_path}/${var.lin_almaimage_name}"
  
  // --- Image & Name ---
  vm_name          = var.lin_almaimage_name
  iso_url          = "${var.common_iso_path}${var.lin_almaiso_name}"
  iso_checksum     = var.lin_almaiso_checksum

  // --- SSH / Communicator Settings ---
  communicator     = "ssh"
  ssh_username     = var.lin_ssh_user
  ssh_password     = var.lin_ssh_password
  ssh_timeout      = "1h" // Alma 10 takes longer to install than Ubuntu
  ssh_handshake_attempts = "100"

  // --- Dynamic HTTP Server (Hosts the ks.cfg) ---
  // This matches the inst.ks path in the boot_command below
  http_content = {
    "/ks.cfg" = templatefile("${path.root}/Common/alma-config/kickstart.pkrtpl.hcl", {
      Hostname     = var.lin_almaimage_name
      Username     = var.lin_ssh_user
      PasswordHash = bcrypt(var.lin_ssh_password)
      Packages     = var.vm_guest_packages
    })
  }

  // --- Boot Command (Optimized for AlmaLinux 10 / Gen 2) ---
  // Using 'linuxefi' and 'initrdefi' for UEFI compatibility
  boot_command = [
    "<esc><wait>",
    "c<wait>",
    "linuxefi /images/pxeboot/vmlinuz inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg quiet ip=dhcp",
    "<enter><wait>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter><wait>",
    "boot<enter>"
  ]

  // --- Final Steps ---
  shutdown_command = "echo '${var.lin_ssh_password}' | sudo -S shutdown -P now"
}