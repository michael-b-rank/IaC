locals {
    subscription_id     = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.subscription_id    
    resource_group_name = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.resource_group_east_name
    default_sku         = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.default_sku
}

# Include the centralized backend configuration from state.hcl
include "state" {
  path = find_in_parent_folders("state.hcl")
}

# Include the centralized provider configuration from providers.hcl
include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
  source = "../../../../modules/vault"
}

# 3. Configure Module Inputs (Variables)
inputs = {
  resource_group_name = local.resource_group_name
  name = "whzlb"

  soft_delete_retention_days = 7
  purge_protection_enabled = true
  sku_name = "standard"
  key_permissions = [
    "Get",
    "GetRotationPolicy",
    "List", 
    "Create", 
    "Delete", 
    "Recover", 
    "Purge", 
    "Update", 
    "Import", 
    "Backup", 
    "Restore", 
    "Sign", 
    "Verify", 
    "WrapKey", 
    "UnwrapKey"
    ]
  
  enabled_for_deployment = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  public_network_access_enabled = true
  
  tags = {
    "env" = "whizlabs"
    "use" = "bootstrap"
  }

}
