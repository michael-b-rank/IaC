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

dependency "vault" {
  config_path = "../../vault"
}

# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
  source = "../../../../../modules/mssql"
}

# 3. Configure Module Inputs (Variables)
inputs = {
    name = "whizlabsbootstrap"
    resource_group_name = local.resource_group_name
    key_vault_id = dependency.vault.outputs.id
    key_vault_uri = dependency.vault.outputs.vault_uri
    identity_type = "SystemAssigned"

}
