locals {
    subscription_id       = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.subscription_id    
    resource_group        = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.resource_group_name
    default_sku           = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.default_sku
    location              = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.location
    git_repo              = read_terragrunt_config(find_in_parent_folders("gitconfig.hcl")).locals.repo_url
    git_branch            = read_terragrunt_config(find_in_parent_folders("gitconfig.hcl")).locals.repo_branch
    personal_access_token = read_terragrunt_config(find_in_parent_folders("provider.hcl")).locals.azure_pat
    org_name              = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.organization
}

# Include the centralized backend configuration from state.hcl
include "state" {
  path = find_in_parent_folders("state.hcl")
}

# Include the centralized provider configuration from providers.hcl
include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

dependency "project" {
  config_path = "../project"
}

dependency "repos" {
  config_path = "../repos"
}

# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
  source = "${local.git_repo}//devops/variable-group?ref=${local.git_branch}"
  #source = "../../../../modules/devops/service-endpoint"
}

# 3. Configure Module Inputs (Variables)
inputs = {
  repository = [
    {
        name = "modules"
        project_id = dependency.project.outputs.id
        repo_type = "Git"
        repo_id = dependency.repos.outputs.modules.id
        branch_name = "refs/heads/main"
        yml_path = "azure-pipelines.yml"
    }
    ]
  
}
