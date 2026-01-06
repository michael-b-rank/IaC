locals {
  sanitized_name = substr(replace(lower(var.name), "_", "-"),0,19)
}

data "azurerm_client_config" "current" {}

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

resource "azurerm_key_vault" "vault" {
  name                        = "${local.sanitized_name}-${random_string.random.result}"
  location                    = data.azurerm_resource_group.resourcegroup.location
  resource_group_name         = data.azurerm_resource_group.resourcegroup.name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled

  sku_name = var.sku_name
  enabled_for_deployment = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  rbac_authorization_enabled = var.rbac_authorization_enabled
  
dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [var.network_acls]
    
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = lookup(network_acls.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids", [])
    }
  }

 access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = var.key_permissions
    secret_permissions = var.secret_permissions
    storage_permissions = var.storage_permissions

  }
   

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags

  depends_on = [ random_string.random ]

}
