# AlmaLinux/RHEL Kickstart Template

# 1. Basic Setup
lang en_US.UTF-8
keyboard us
timezone UTC

# 2. Authentication
rootpw --iscrypted ${PasswordHash}
user --name=${Username} --groups=wheel --iscrypted --password=${PasswordHash}

# 3. Installation Source
cdrom
text
skipx
reboot

# 4. Storage & Partitioning (Optimized for Gen 2 UEFI)
bootloader
zerombr
clearpart --all --initlabel
autopart --type=lvm

# 5. Network
network --bootproto=dhcp --device=link --activate --onboot=on --hostname=${Hostname}

# 6. Software Selection
%packages
@^minimal-environment
# --- DYNAMIC PACKAGE LOOP ---
%{ for pkg in Packages ~}
${pkg}
%{ endfor ~}
# ----------------------------
-subscription-manager
%end

# 7. Post-Installation Scripts
%post --erroronfail
# Allow the packer user to sudo without a password
echo "${Username} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${Username}
chmod 0440 /etc/sudoers.d/${Username}

%{ for pkg in Packages ~}
if rpm -q ${pkg} > /dev/null 2>&1; then
    echo "Enabling service for ${pkg}..."
    systemctl enable ${pkg} || echo "No systemd service found for ${pkg}, skipping..."
fi
%{ endfor ~}

%end