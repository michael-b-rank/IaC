locals {
    #subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))

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

# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
  source = "../../../../modules/devops/project"
  #source = "${local.git_repo}//devops/project?ref=${local.git_branch}"
}

# 3. Configure Module Inputs (Variables)
inputs = {
  project_name = "bootstrap"
  visibility = "private"
  version_control = "Git"
  work_item_template = "Agile"
  description = "Managed by Terraform"
  
  features = {
    artifacts = "enabled"
    boards = "enabled"
    pipelines = "enabled"
    repositories = "enabled"
    testplans = "enabled"
  }

}
