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

dependency "mssql" {
  config_path = "../server"
}

# 2. Configure the Terraform Module Source
# This tells Terragrunt which module to run (relative to the live/dev/region-a directory)
terraform {
  source = "../../../../../modules/mssql-database"
}

# 3. Configure Module Inputs (Variables)
inputs = {    
    resource_group_name = local.resource_group_name
    
    mssql_server = {
      name = dependency.mssql.outputs.name
      id = dependency.mssql.outputs.id
      fqdn = dependency.mssql.outputs.fully_qualified_domain_name
      identity = dependency.mssql.outputs.identity
    }

    key_settings = {
      vault_id = dependency.vault.outputs.id
      vault_name = dependency.vault.outputs.name
      key_name = "whizlabsbootstrapmssqldb"
      type = "RSA"
      size = 2048
      opts = ["decrypt","encrypt","sign","unwrapKey","verify","wrapKey"]
    }

    mssql_creds = {
      admin_login = dependency.mssql.outputs.administrator_login
      secret_name = dependency.mssql.outputs.secret_name
      vault_id = dependency.mssql.outputs.secret_key_vault_id
    }

    db_settings = {
      name = "whizlabsbootstrapmssqldb"
      enclave_type = "VBS"
      geo_backup_enabled = false
      maintenance_configuration_name = "SQL_Default"
      collation = "SQL_Latin1_General_CP1_CI_AS"
      license_type = "LicenseIncluded"
      max_size_gb = 2
      sku_name = "Basic"
      prevent_destroy = false
      read_scale = false      
    }

}
