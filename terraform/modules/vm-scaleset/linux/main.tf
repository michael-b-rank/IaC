locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+wWK73dCr+jgQOAxNsHAnNNNMEMWOHYEccp6wJm2gotpr9katuF/ZAdou5AaW1C61slRkHRkpRRX9FA9CYBiitZgvCCz+3nWNN7l/Up54Zps/pHWGZLHNJZRYyAB6j5yVLMVHIHriY49d/GZTZVNB8GoJv9Gakwc/fuEZYYl4YDFiGMBP///TzlI4jhiJzjKnEvqPFki5p2ZRJqcbCiF4pJrxUQR/RXqVFQdbRLZgYfJ8xGB878RENq3yQ39d8dVOkq4edbkzwcUmwwwkYVPIoDGsYLaRHnG+To7FvMeyO7xDVQkMKzopTQV8AuKpyvpqu0a9pWOMaiCyDytO7GGN you@me.com"
}

data "azurerm_resource_group" "resourcegroup" {
  name = var.resource_group_name
}


resource "azurerm_virtual_network" "example" {
  name                = var.virtual_network.name
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  location            = data.azurerm_resource_group.resourcegroup.location
  address_space       = var.virtual_network.address_space

  depends_on = [ data.azurerm_resource_group.resourcegroup ]

}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet.name
  resource_group_name  = data.azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.subnet.address_prefixes

  depends_on = [ azurerm_virtual_network.example ]
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = var.scaleset.name
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  location            = data.azurerm_resource_group.resourcegroup.location
  sku                 = var.scaleset.sku
  instances           = var.scaleset.instance_count
  admin_username      = var.scaleset.adminName
  admin_password      = var.scaleset.adminPassword

  admin_ssh_key {
    username   = var.scaleset.adminName
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  os_disk {
    storage_account_type = var.os_disk.storage_account_type
    caching              = var.os_disk.caching
  }

  network_interface {
    name    = var.network_interface.name
    primary = var.network_interface.primary

    ip_configuration {
      name      = var.network_interface.ip_configuration.name
      primary   = var.network_interface.ip_configuration.primary
      subnet_id = azurerm_subnet.internal.id
    }
  }

  custom_data = base64encode(<<-EOT
  #cloud-config

    # Ensure Docker is installed and started
    package_update: true
    packages:
      - docker.io
    
    runcmd:
      - systemctl start docker

    # Log in to ACR using admin credentials
    - docker login ${var.login_server} -u ${var.scaleset.adminName} -p ${var.scaleset.adminPassword}

    # Pull and run the container in the background
    - docker run -d --name iac-runner-container ${var.login_server}/${var.image_name}
  EOT  
  )



  depends_on = [ azurerm_subnet.internal ]

}