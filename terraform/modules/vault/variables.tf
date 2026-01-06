variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "enabled_for_disk_encryption" {
  type = bool
  default = null
}

variable "soft_delete_retention_days" {
  type = number
  default = 7
}

variable "purge_protection_enabled" {
  type = bool
  default = null
}

variable "sku_name" {
  type = string
  default = "Standard"
}

variable "enabled_for_deployment" {
  type = bool
  default = true
}

variable "enabled_for_template_deployment" {
  type = bool
  default = true
}

variable "rbac_authorization_enabled" {
  type = bool
  default = null
}

variable "key_permissions" {
  type = list(string)
  default = [
    "Get", 
    "List", 
    "Create", 
    "Delete", 
    "Recover", 
    "Purge", 
    "Update", 
    "Import", 
    "Backup", 
    "Restore", 
    "Sign", 
    "Verify", 
    "WrapKey", 
    "UnwrapKey"
    ]
}

variable "secret_permissions" {
  type = list(string)
  default = ["Get", "List", "Set", "Delete", "Recover", "Purge"]
}

variable "storage_permissions" {
  type = list(string)
  default = [
    "Get", 
    "List", 
    "Delete", 
    "Recover", 
    "Purge", 
    "Update",
    # Permissions specific to Managed Storage Accounts (MSAs)
    "Set", 
    "Backup", 
    "Restore", 
    "RegenerateKey", 
    "GetSAS", 
    "ListSAS", 
    "SetSAS", 
    "DeleteSAS"
  ]
}

variable "network_acls" {
  type = object({
    bypass = string
    default_action = string
    ip_rules = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = null
}

variable "public_network_access_enabled" {
  type = bool
  default = null
}

variable "tags" {
  type = map(string)
  default = {
    "env" = "sandbox"
    "plat" = "whizlabs"
    "resource" = "vault"
  }
}


variable "random_string_settings" {
  type = object({
    length = number # Desired length of the random suffix
    special = bool # Exclude all special characters (e.g., !, $, #)
    upper = bool # Exclude uppercase letters (A-Z)
    lower = bool # Include lowercase letters (a-z) - this is the default
    numeric = bool # Include numbers (0-9) - this is also the default
  })
  default = {
    length = 4
    special = false
    upper = false
    lower = true
    numeric = true
  }  
}

variable "random_password_settings" {
  type = object({
    length = number # Desired length of the random suffix
    special = bool # Exclude all special characters (e.g., !, $, #)
    override_special = string # Specify the set of allowed special characters (optional)
    upper = bool # Exclude uppercase letters (A-Z)
    lower = bool # Include lowercase letters (a-z) - this is the default
    numeric = bool # Include numbers (0-9) - this is also the default
  })
  default = {
    length = 16
    special = true
    override_special = "!@#$%^&*"
    upper = true
    lower = true
    numeric = true
  }  
}