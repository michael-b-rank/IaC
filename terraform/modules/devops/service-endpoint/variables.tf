variable "project_id" {
  type = string
}

variable "subscription_id" {
    type = string
    default = null
}

variable "azurerm_name" {
  type = string
  default = "azurerm"
}

variable "azurerepos_name" {
  type = string
  default = "ado-repo"
}

variable "description_repos" {
  type = string
  description = "Connection to Azure Repos via Terraform"
}

variable "org_name" {
  type = string
  description = "your-organization-name"
}

variable "personal_access_token" {
  type = string
  sensitive = true
  description = "PAT needs 'Code (Read & Write)' scope for the repo"
}

variable "authentication_scheme" {
  type = string
  default = "WorkloadIdentityFederation"
}