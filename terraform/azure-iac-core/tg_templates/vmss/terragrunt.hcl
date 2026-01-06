locals {
    subscription_id     = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.subscription_id    
    resource_group_name = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.resource_group_name
    default_sku         = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.default_sku
    git_repo            = read_terragrunt_config(find_in_parent_folders("gitconfig.hcl")).locals.repo_url
    git_branch            = read_terragrunt_config(find_in_parent_folders("gitconfig.hcl")).locals.repo_branch
}

# Include the centralized backend configuration from state.hcl
include "state" {
  path = find_in_parent_folders("state.hcl")
}

# Include the centralized provider configuration from providers.hcl
include "provider" {
  path = find_in_parent_folders("provider.hcl")
}


dependency "container_registry" {
  config_path = "../container-registry"  

}
dependency "acr_builder" {
  config_path = "../acr-builder"  

}


# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
  #source = "../../../../modules/vm-scaleset/linux"
  source = "${local.git_repo}//vm-scaleset/linux?ref=${local.git_branch}"
}

# 3. Configure Module Inputs (Variables)
inputs = {
  resource_group_name = local.resource_group_name
  login_server = dependency.container_registry.outputs.login_server
  image_name = dependency.acr_builder.outputs.full_image_name

  source_image_reference = {
      publisher = "microsoftcblmariner"
      offer = "cbl-mariner"
      sku = "cbl-mariner-2-gen2"
      version = "latest"
    }
  
}
