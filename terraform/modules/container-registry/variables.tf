## no underscore or Dashes allowed. Naming scheme could be challenging.
variable "container_registry_name" {
  type    = string
  default = "containerRegLabWhizlabs2"
}

variable "resource_group_name" {
  type    = string
  default = "rg_sb_eastus_321393_1_176227568123"
}

variable "sku" {
  type    = string
  default = "Standard"
}
variable "tags" {
  type = map(string)
  default = {
    "env" = "sandbox"
    "plat" = "whizlabs"
    "resource" = "container-registry"
  }
}