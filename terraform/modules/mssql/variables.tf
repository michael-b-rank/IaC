variable "resource_group_name" {
  type = string
}

variable "key_vault_id" {
    type = string
    default = null
}
variable "key_vault_uri" {
    type = string
    default = null
}

variable "ms_version" {
  type = string
  default = "12.0"
}

variable "name" {
  type = string
}

variable "administrator_login" {
  type = string
  sensitive = true
  default = "Example-Administrator"
}


variable "connection_policy" {
  type = string
  default = null
}

variable "express_vulnerability_assessment_enabled" {
    type = bool
    default = false
}

variable "transparent_data_encryption_key_vault_key_id" {
  type = string
  default = null
}

variable "minimum_tls_version" {
  type = string
  default = "1.2"
}

variable "public_network_access_enabled" {
type = bool  
default = false
}

variable "outbound_network_restriction_enabled" {
type = bool
default = false
}

variable "primary_user_assigned_identity_id" {
  type = string
  default = null
}

variable "generic_tags" {
  type = map(string)
  default = {
    "env" = "sandbox"
    "plat" = "whizlabs"
  }
}
variable "mssql_tags" {
  type = map(string)
  default = {
    "resource" = "mssql"
  }
}
variable "secret_tags" {
  type = map(string)
  default = {
    "Name" = "sandbox"
    "resource" = "DatabaseCredentials"
  }
}

variable "identity_type" {  
    type = string
    default = "UserAssigned"  
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
    override_special = string
    upper = bool # Exclude uppercase letters (A-Z)
    lower = bool # Include lowercase letters (a-z) - this is the default
    numeric = bool # Include numbers (0-9) - this is also the default
  })
  default = {
    length = 16
    special = true
    override_special = "!@#$%^-_=+,."
    upper = true
    lower = true
    numeric = true
  }  
}

variable "mssql_admin_secret_name" {
  type = string
  default = "mssql-admin-password"
}

