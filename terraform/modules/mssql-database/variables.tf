
variable "resource_group_name" {
    type = string
}

variable "mssql_server" {
  type = object({
    name = string
    id = string
    fqdn = string
    identity = list(object(
      {
        identity_ids = set(string)
        principal_id = string
        tenant_id    = string
        type         = string
      }))
  
  })
}

variable "key_settings" {
    type = object({
      vault_id = string
      vault_name = string
      key_name = string
      type = string
      size = number
      opts = list(string)
    })
    default = {
      vault_id = ""
      vault_name = ""
      key_name = "example-key"
      type = "RSA"
      size = 2048
      opts = ["unwrapKey", "wrapKey"]
    }
}

variable "mssql_creds" {
  type = object({
    admin_login = string
    secret_name = string
    vault_id = string
  })
  
}

variable "db_settings" {
  type = object({
    name = string
    enclave_type = string
    geo_backup_enabled = bool
    maintenance_configuration_name = string
    collation = string
    license_type = string
    max_size_gb = number
    sku_name = string
    prevent_destroy = bool
    read_scale = bool
  })
}

variable "tags" {
  type = map(string)
  default = {
    "env" = "sandbox"
    "plat" = "whizlabs"
    "resource" = "database"
  }
}


variable "random_string_settings" {
type = object({
  length = number
  special = bool
  upper = bool
  lower = bool
  numeric = bool
})
default = {
  length = 4
  special = false
  upper = false
  lower = true
  numeric = true
}
}