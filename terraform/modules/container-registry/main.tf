data "azurerm_resource_group" "resourcegroup" {
  name = var.resource_group_name
}


resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  location            = data.azurerm_resource_group.resourcegroup.location
  sku                 = try(
    # 1. Try the expected case "Standard"
    var.sku,
    # 2. Try the alternative case "standard"
    lower(var.sku)
  )
  admin_enabled       = false
  tags = var.tags
  
}