locals {
  sanitized_db_name = substr(replace(lower(var.db_settings.name), "_", "-"),0,19)
  sanitized_key_name = substr(replace(lower(var.key_settings.key_name), "_", "-"),0,19)
}

data "azurerm_client_config" "current" {}

data "azuread_user" "current_user_details" {
  object_id = data.azurerm_client_config.current.object_id
}

data "azurerm_resource_group" "resourcegroup" {
  name = var.resource_group_name
}

data "azurerm_key_vault_secret" "sql_admin_password" {
  key_vault_id = var.mssql_creds.vault_id
  name = var.mssql_creds.secret_name
}

resource "random_string" "random" {
  length  = var.random_string_settings.length
  special = var.random_string_settings.special
  upper   = var.random_string_settings.upper
  lower   = var.random_string_settings.lower
  numeric = var.random_string_settings.numeric

}

resource "azurerm_mssql_database" "database" {
  name         = "${local.sanitized_db_name}-${random_string.random.result}"
  server_id    = var.mssql_server.id
  enclave_type = var.db_settings.enclave_type
  geo_backup_enabled = var.db_settings.geo_backup_enabled
  maintenance_configuration_name = var.db_settings.maintenance_configuration_name


  collation    = var.db_settings.collation
  license_type = var.db_settings.license_type
  max_size_gb  = var.db_settings.max_size_gb
  sku_name     = var.db_settings.sku_name

  tags = var.tags

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }

  #transparent_data_encryption_key_vault_key_id = azurerm_key_vault_key.key.id
  #transparent_data_encryption_key_automatic_rotation_enabled = true
  #transparent_data_encryption_enabled = true



  depends_on = [ random_string.random, data.azurerm_resource_group.resourcegroup ]
}

resource "azurerm_key_vault_key" "key" {
      
  name         = "${local.sanitized_key_name}-${random_string.random.result}"
  key_vault_id = var.key_settings.vault_id
  key_type     = var.key_settings.type
  key_size     = var.key_settings.size
  key_opts     = var.key_settings.opts

  depends_on = [ data.azurerm_resource_group.resourcegroup ]

}

resource "azurerm_key_vault_access_policy" "server_key_access" {
  key_vault_id = var.mssql_creds.vault_id
  tenant_id    = var.mssql_server.identity[0].tenant_id
  
  object_id    = var.mssql_server.identity[0].principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey",
  ]
}