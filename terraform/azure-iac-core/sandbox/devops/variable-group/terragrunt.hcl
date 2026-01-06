locals {
    subscription_id     = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.subscription_id    
    resource_group      = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.resource_group_name
    default_sku         = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.default_sku
    location            = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.location
    git_repo            = read_terragrunt_config(find_in_parent_folders("gitconfig.hcl")).locals.repo_url
    git_branch          = read_terragrunt_config(find_in_parent_folders("gitconfig.hcl")).locals.repo_branch
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

dependency "repo" {
  config_path = "../repos"
}


dependency "vault" {
  config_path = "../../eastus/vault"
}

dependency "container_registry" {
  config_path = "../../eastus/container-registry"
}

dependency "acr_builder" {
  config_path = "../../eastus/acr-builder"
}

# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
  source = "${local.git_repo}//devops/variable-group?ref=${local.git_branch}"
  #source = "../../../../modules/devops/variable-group"
}

# 3. Configure Module Inputs (Variables)
inputs = {
  project_id = dependency.project.outputs.id
  name = "env"
  description = "managed by terragrunt, environmentals values"
  #key_vault_name = dependency.vault.outputs.name
  #key_vault_id = dependency.vault.outputs.id
  
  content = [
    {
      name  = "resource_group"
      value = local.resource_group
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "project_name"
      value = dependency.project.outputs.name
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "subscription_id"
      value = local.subscription_id
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "default_sku"
      value = local.default_sku
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "location"
      value = local.location
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "modules_repo_url"
      value = dependency.repo.outputs.modules.url
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "modules_repo_name"
      value = dependency.repo.outputs.modules.name
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "core_repo_url"
      value = dependency.repo.outputs.core.url
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "core_repo_name"
      value = dependency.repo.outputs.core.name
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "templates_repo_url"
      value = dependency.repo.outputs.templates.url
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "templates_repo_name"
      value = dependency.repo.outputs.templates.name
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    
    {
      name  = "vault_id"
      value = dependency.vault.outputs.id
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "container"
      value = dependency.acr_builder.outputs.full_image_name
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    },
    {
      name  = "container_registry"
      value = dependency.container_registry.outputs.login_server
      is_secret = false
      secret_value = null
      inline_or_vault = "inline"
    }
    
  ]

}
