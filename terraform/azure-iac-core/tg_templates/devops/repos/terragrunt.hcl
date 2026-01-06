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

dependency "project" {
  config_path = "../project"
}

# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
  source = "../../../../modules/devops/repo"
  #source = "${local.git_repo}//devops/repo?ref=${local.git_branch}"
}

# 3. Configure Module Inputs (Variables)
inputs = {
    repo_name_modules = "modules"
    repo_name_jobs = "jobs"
    repo_name_steps = "steps"
    repo_name_core = "azure-iac-core"
    repo_name_others = ["test1", "test2"]
    project_name = dependency.project.outputs.name
}
