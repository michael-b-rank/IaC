
common_iso_path = "./ISOs/"
common_cpus = 2
common_memory = 4096
common_switch = "Default Switch"
common_generation = 2
common_enable_secure_boot = true

win_iso_name = "en-us_windows_server_2022_x64_dvd_620d7eac.iso"
win_iso_checksum = "5A077EE2A95976EF9F3623EB4040E25CDF7F8F01DEE3B8165A32A7626F39F025"
win_image_name = "Server2022-Gold"
win_admin_user = "Administrator"
win_admin_password = "P@33w0rd"
win_edition_index_key = "/IMAGE/INDEX"
win_edition_index_value = 3
win_productkey = "W3GNR-8DDXR-2TFRP-H8P33-DV9BG" # AVA CODE FOR SERVER 2022
vm_guest_packages = [
  "hypervkvpd",
  "hypervvssd",
  "hypervfcopyd"
]

lin_ubuntuiso_name = "ubuntu-24.04.3-live-server-amd64.iso"
lin_ubuntuimage_name = "Ubuntu2204-Gold"
lin_ubuntuiso_checksum = "C3514BF0056180D09376462A7A1B4F213C1D6E8EA67FAE5C25099C6FD3D8274B" 

lin_almaimage_name = "AlmaLinux-10-Gold"
lin_almaiso_name   = "AlmaLinux-10.1-x86_64-minimal.iso"
lin_almaiso_checksum = "049EFD183A5A841DD432B3427EB6FAA7DEB3BF6C6BF2C63CBFFA024B9C651725" # minimal

lin_ssh_user = "packer"
lin_ssh_password = "P@33w0rd"