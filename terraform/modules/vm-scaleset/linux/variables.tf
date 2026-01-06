
variable "resource_group_name" {
  type = string
}


variable "virtual_network" {
  type = object({
    name = string
    address_space = list(string)
  })
  default = {
    name = "example-network"
    address_space = ["10.0.0.0/16" ]
  }
}

variable "subnet" {
  type = object({
    name = string
    address_prefixes =list(string)
  })
  default = {
    name = "internal"
    address_prefixes = [ "10.0.2.0/24" ]
  }
}

variable "scaleset" {
    type = object({
      name = string
      sku = string
      adminName = string
      adminPassword = string
      instance_count = number      
    })
    default = {
      name = "example-linux-vmss"
      adminName = "adminuser"
      adminPassword = "Generic!1"
      sku = "Standard_B1s"
      instance_count = 1
    }
    sensitive = true
}

variable "source_image_reference" {
    type = object({
      publisher = string
      offer = string
      sku = string
      version = string
    })
    default = {
      publisher = "MicrosoftCBLMariner"
      offer = "AzureLinux"
      sku = "gen2"
      version = "latest"
    }
}

variable "os_disk" {
  type = object({
    storage_account_type = string
    caching = string
  })
  default = {
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }
}


variable "network_interface" {
    type = object({
      name = string
      primary = bool
      ip_configuration = object({
        name = string
        primary = bool
      })
    })
    default = {
      name = "example"
      primary = true
      ip_configuration = {
        name = "internal"
        primary = true
      }
    }
}

variable "login_server" {
  type = string
}

variable "image_name" {
  type = string
}