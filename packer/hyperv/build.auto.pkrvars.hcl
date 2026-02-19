
common_iso_path = "./ISOs/"
common_cpus = 2
common_memory = 4096
common_switch = "Default Switch"

win_iso_name = "en-us_windows_server_2022_x64_dvd_620d7eac.iso"
win_iso_checksum = ""
win_image_name = "Server2022-Gold"
win_admin_user = "Administrator"
win_admin_password = ""
win_edition_index_key = "/IMAGE/INDEX"
win_edition_index_value = 3
win_productkey = "WX4NM-KYWXW-QJJ82-FBPG2-M9WTT" # AVA CODE FOR SERVER 2022
vm_guest_packages = [
  "hypervkvpd",
  "hypervvssd",
  "hypervfcopyd"
]

lin_ubuntuiso_name = "ubuntu-24.04.3-live-server-amd64.iso"
lin_ubuntuimage_name = "Ubuntu2204-Gold"
lin_ubuntuiso_checksum = "" 

lin_almaimage_name = "AlmaLinux-10-Gold"
lin_almaiso_name   = "AlmaLinux-10.1-x86_64-minimal.iso"
lin_almaiso_checksum = "" # minimal

lin_ssh_user = "packer"
lin_ssh_password = ""