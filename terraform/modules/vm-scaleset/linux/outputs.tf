output "vnet_name" {
  value = azurerm_virtual_network.example.name
}

output "vnet_location" {
  value = azurerm_virtual_network.example.location
}

output "vnet_id" {
  value = azurerm_virtual_network.example.id
}

output "vnet_resourceGroupName" {
  value = azurerm_virtual_network.example.resource_group_name
}

output "subnet_internal_name" {
  value = azurerm_subnet.internal.name
}
output "subnet_internal_id" {
  value = azurerm_subnet.internal.id
}
output "subnet_internal_resourceGroupName" {
  value = azurerm_subnet.internal.resource_group_name
}
output "subnet_internal_virtualNetworkName" {
  value = azurerm_subnet.internal.virtual_network_name
}
output "name" {
  value = azurerm_linux_virtual_machine_scale_set.example.name
  sensitive = true
}
output "id" {
  value = azurerm_linux_virtual_machine_scale_set.example.id
}
output "adminUsername" {
  value = azurerm_linux_virtual_machine_scale_set.example.admin_username
  sensitive = true
}

output "custom_data" {
  value = azurerm_linux_virtual_machine_scale_set.example.custom_data
  sensitive = true
}