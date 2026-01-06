locals {
    #subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))

    subscription_id     = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.subscription_id    
    resource_group_name = read_terragrunt_config(find_in_parent_folders("subscription.hcl")).locals.resource_group_name
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

<<<<<<<< HEAD:terraform/azure-iac-core/sandbox/devops/repos/terragrunt.hcl
dependency "project" {
  config_path = "../project"
========
dependency "vault" {
  config_path = "../../vault"
>>>>>>>> main:terraform/azure-iac-core/templates/mssql/server/terragrunt.hcl
}

# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
<<<<<<<< HEAD:terraform/azure-iac-core/sandbox/devops/repos/terragrunt.hcl
  source = "../../../../modules/devops/repo"
========
  source = "../../../../../modules/mssql"
>>>>>>>> main:terraform/azure-iac-core/templates/mssql/server/terragrunt.hcl
}

# 3. Configure Module Inputs (Variables)
inputs = {
<<<<<<<< HEAD:terraform/azure-iac-core/sandbox/devops/repos/terragrunt.hcl
    repo_name_modules = "modules"
    repo_name_jobs = "templates"
    repo_name_core = "azure-iac-core"
    project_name = dependency.project.outputs.name
========
    name = "whizlabsbootstrap"
    resource_group_name = local.resource_group_name
    key_vault_id = dependency.vault.outputs.id
    key_vault_uri = dependency.vault.outputs.vault_uri
    identity_type = "SystemAssigned"

>>>>>>>> main:terraform/azure-iac-core/templates/mssql/server/terragrunt.hcl
}
