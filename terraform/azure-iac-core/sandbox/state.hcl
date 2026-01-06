# state.hcl

# This block configures the Terraform backend configuration.
remote_state {
  # Specifies the backend type is "local"
  backend = "azurerm"
  
  # Configuration parameters for the local backend
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "whizlabsterra"
    container_name       = "tfstate"
    
    # The key defines the path within the container. 
    # path_relative_to_include() ensures a unique state file for each module (e.g., acr-module/terraform.tfstate)
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }

  # Terragrunt will automatically generate a backend.tf file with this configuration
  # when it detects the need to initialize the backend.
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}