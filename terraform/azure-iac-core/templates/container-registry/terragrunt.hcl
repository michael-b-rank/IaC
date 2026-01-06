locals {
    #subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))

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
  source = "../../../../modules/container-registry"
}

# 3. Configure Module Inputs (Variables)
inputs = {
  
  container_registry_name = "whizlabsTerragruntDeployTest"
  sku = local.default_sku  
  resource_group_name = local.resource_group_name

}
