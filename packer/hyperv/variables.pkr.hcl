// --- COMMON VARIABLES (Applied to all builds) ---
variable "common_iso_path" {
  type        = string
  description = "Base path where all ISOs are stored"
  default     = "../ISOs/"
}

variable "common_cpus" {
  type    = number
  description = "default number of Hyper-V Cores to set on the VMs."
  default = 2
}

variable "common_memory" {
  type    = number
  description = "default RAM in MB to set on the VMs."
  default = 4096
}

variable "common_switch" {
  type    = string
  description = "default hyper-v switch name"
  default = "Default Switch"
}

variable "common_output_path" {
  type    = string
  default = "./output"
}

variable "common_generation" {
  type = number
  default = 2
}

variable "common_enable_secure_boot" {
  type = bool
  default = false
}

variable "vm_guest_packages" {
  type    = list(string)
  default = ["linux-image-virtual", "linux-tools-virtual", "linux-cloud-tools-virtual"] # Hyper-V Packages for Ubuntu  
}

// --- WINDOWS SPECIFIC VARIABLES (Prefix: win_) ---
variable "win_iso_name" {
  type        = string
  description = "en-us_windows_server_2022_x64_dvd_620d7eac.iso"
}

variable "win_iso_checksum" {
  type        = string
  description = "SHA256 checksum for the Windows ISO (or 'none')"
  default     = "none"
}

variable "win_image_name" {
  type        = string
  description = "How to Name of the Hyper-V VM it creates during Image Creation"
  default     = "Server2022-Gold"
}

variable "win_admin_user" {
  type    = string
  description = "Name of the admin account"
  default = "Administrator"
}

variable "win_admin_password" {
  type      = string
  description = "Password of the admin account"
  sensitive = true
}

variable "win_edition_index_key" {
    type = string
    description = "KeyValue of edition of WindowServer to install: Standard (Core,Desktop), Datacenter (Core,Desktop)"
    default = "/IMAGE/INDEX"
}

variable "win_edition_index_value" {
    type = number
    description = "Value of IndexKEy to install: Standard (Core=1,Desktop=2), Datacenter (Core=3,Desktop=4)"
    default = 3
}

variable "win_productkey" {
    type = string
    description = "Windows Key to use, Defaults to AVA key for virtualized environments"
    #default = "W3GNR-8DDXR-2TFRP-H8P33-DV9BG" # AVA code
    default = "MN36Y-RYMW9-XVK32-W6W92-4RKB7" # Datacenter code.
}

// --- UBUNTU SPECIFIC VARIABLES (Prefix: lin_) ---
variable "lin_ubuntuiso_name" {
  type        = string
  description = "ubuntu-24.04.3-live-server-amd64.iso"
}

variable "lin_ubuntuiso_checksum" {
  type        = string
  description = "SHA256 checksum for the Linux ISO (or 'none')"
  default     = "none"
}

variable "lin_ubuntuimage_name" {
  type    = string
  description = "How to Name of the Hyper-V VM it creates during Image Creation"
  default = "Ubuntu2204-Gold"
}

variable "lin_ssh_user" {
  type    = string
  description = "Username to set for SSH access"
  default = "packer"
}

variable "lin_ssh_password" {
  type      = string
  description = "Password to set for SSH access"
  sensitive = true
}




// --- ALMA SPECIFIC VARIABLES (Prefix: lin_) ---
variable "lin_almaimage_name" {
  type    = string
  description = "How to Name of the Hyper-V VM it creates during Image Creation"
  default = "AlmaLinux-10-Gold"
}
variable "lin_almaiso_name" {
  type        = string
  description = "AlmaLinux-10.1-x86_64-minimal.iso"
}

variable "lin_almaiso_checksum" {
  type        = string
  description = "SHA256 checksum for the Linux ISO (or 'none')"
  default     = "none"
}