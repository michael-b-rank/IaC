locals {
  sanitized_name = substr(replace(lower(var.name), "_", "-"),0,19)
  
}

data "azurerm_client_config" "current" {}

data "azuread_user" "current_user_details" {
  object_id = data.azurerm_client_config.current.object_id
}

data "azurerm_resource_group" "resourcegroup" {
  name = var.resource_group_name
}

resource "random_string" "random" {
  length  = var.random_string_settings.length
  special = var.random_string_settings.special
  upper   = var.random_string_settings.upper
  lower   = var.random_string_settings.lower
  numeric = var.random_string_settings.numeric
}

resource "random_password" "mssql_admin_password" {
  length           = var.random_password_settings.length
  special          = var.random_password_settings.special
  override_special = var.random_password_settings.override_special
  upper            = var.random_password_settings.upper
  lower            = var.random_password_settings.lower
  numeric           = var.random_password_settings.numeric
}

resource "azurerm_key_vault_secret" "mssql_admin_secret" {
  name         = var.mssql_admin_secret_name
  key_vault_id = var.key_vault_id
  
  # The value is the generated password, marked as sensitive
  value        = random_password.mssql_admin_password.result 
  tags = merge(var.secret_tags,var.generic_tags)
}

resource "azurerm_mssql_server" "mssqlserver" {
  name                        = "${local.sanitized_name}-${random_string.random.result}"
  resource_group_name          = data.azurerm_resource_group.resourcegroup.name
  location                     = data.azurerm_resource_group.resourcegroup.location
  version                      = var.ms_version
  administrator_login          = var.administrator_login
  administrator_login_password = random_password.mssql_admin_password.result

  connection_policy             = var.connection_policy
  minimum_tls_version          = var.minimum_tls_version
  express_vulnerability_assessment_enabled = var.express_vulnerability_assessment_enabled

  
  azuread_administrator {    
    login_username = data.azuread_user.current_user_details.user_principal_name
    object_id = data.azuread_user.current_user_details.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
  }

  tags = merge(var.generic_tags,var.mssql_tags)

  public_network_access_enabled = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled
  
  identity {
    type = var.identity_type
  }
}

/*
resource "azurerm_mssql_server_transparent_data_encryption" "example" {
  server_id        = azurerm_mssql_server.mssqlserver.id
  key_vault_key_id = var.key_vault_uri

  depends_on = [ azurerm_mssql_server.mssqlserver  ]
}
*/