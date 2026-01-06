output "id" {
 value = azurerm_key_vault.vault.id
}

output "location" {
 value = azurerm_key_vault.vault.location
}

output "name" {
 value = azurerm_key_vault.vault.name
}

output "network_acls" {
 value = azurerm_key_vault.vault.network_acls
}

output "enabled_for_deployment" {
 value = azurerm_key_vault.vault.enabled_for_deployment
}
output "resource_group_name" {
 value = azurerm_key_vault.vault.resource_group_name
}

output "vault_uri" {
 value = azurerm_key_vault.vault.vault_uri
}

output "tenant_id" {
 value = azurerm_key_vault.vault.tenant_id
}

output "tags" {
 value = azurerm_key_vault.vault.tags
}

output "soft_delete_retention_days" {
 value = azurerm_key_vault.vault.soft_delete_retention_days
}

output "public_network_access_enabled" {
 value = azurerm_key_vault.vault.public_network_access_enabled
}

output "current_client_id" {
  value = data.azurerm_client_config.current.client_id
}

output "current_id" {
  value = data.azurerm_client_config.current.id
}
output "current_object_id" {
  value = data.azurerm_client_config.current.object_id
}
output "current_subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
output "current_tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "resource_group_od" {
  value = data.azurerm_resource_group.resourcegroup.id
}
output "resource_group_location" {
  value = data.azurerm_resource_group.resourcegroup.location
}
output "resource_group_managed_by" {
  value = data.azurerm_resource_group.resourcegroup.managed_by
}
output "resource_group_tags" {
  value = data.azurerm_resource_group.resourcegroup.tags
}
output "resource_group_id" {
  value = data.azurerm_resource_group.resourcegroup.id
}
