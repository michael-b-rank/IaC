# This file serves as the "Glue" layer for your sandbox environment.

# 1. Load Configurations from Current Directory
locals {  
  state_config = read_terragrunt_config("state.hcl")
  provider_config = read_terragrunt_config("provider.hcl")
  
  # Define variables here that all modules will inherit and use.
  global_prefix = "iac-runner-platform"
}

# 2. Global State Backend Inheritance (CORRECTED SYNTAX)
remote_state {  
  backend = local.state_config.remote_state.backend 

  # The 'config' block contains the specific parameters (like storage_account_name).
  # We now correctly pull the entire configuration map from state.hcl.
  config = local.state_config.remote_state.config
  
  # Merge the generate block from the loaded file
  generate = local.state_config.remote_state.generate
}

# 3. Global Provider Generation Inheritance
generate "provider" {
  path = local.provider_config.generate.provider.path
  if_exists = local.provider_config.generate.provider.if_exists
  contents = local.provider_config.generate.provider.contents
}

# 4. Define the Source of the Terraform Module (Example)
terraform {
  source = "../../modules" 
}