#cloud-config
autoinstall:
  version: 1
  reboot: poweroff
  # 1. Locale & Keyboard
  locale: en_US.UTF-8
  keyboard:
    layout: us
  # 2. Network (DHCP is standard for builds)
  network:
    network:
      version: 2
      ethernets:
        eth0:
          dhcp4: true
  # 3. Identity (Injected from Packer)
  identity:
    hostname: ${Hostname}
    username: ${Username}
    # WE WILL HASH THIS IN THE SOURCE BLOCK
    password: ${PasswordHash}
  # user-data.pkrtpl.hcl
  packages:
  %{ for pkg in ExtraPackages ~}
    - ${pkg}
  %{ endfor ~}    
  # 4. SSH Access
  ssh:
    install-server: true
    allow-pw: true
  # 5. Storage (Wipe disk and use LVM)
  storage:
    layout:
      name: lvm
  # 6. Post-Install Commands (Cleanup)
  late-commands:    
    - "echo 'Packer build complete' > /target/etc/issue"
    # Allow the packer user to sudo without a password
    - "echo '${Username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${Username}"