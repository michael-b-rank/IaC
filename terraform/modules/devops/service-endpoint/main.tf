data "azurerm_subscription" "current" {
    subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {

}

resource "azuredevops_serviceendpoint_azurerm" "azurerm" {
  project_id                             = var.project_id

  service_endpoint_name                  = var.azurerm_name
  service_endpoint_authentication_scheme = var.authentication_scheme
  azurerm_spn_tenantid                   = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id                = data.azurerm_subscription.current.subscription_id
  azurerm_subscription_name              = data.azurerm_subscription.current.display_name
}

resource "azuredevops_serviceendpoint_externaltfs" "azure_repos" {
  project_id            = var.project_id
  service_endpoint_name = var.azurerepos_name
  description           = var.description_repos
  
  # The URL of your Azure DevOps Organization
  connection_url = "https://dev.azure.com/${var.org_name}"

  auth_personal {
    # PAT needs "Code (Read & Write)" scope for the repo
    personal_access_token = var.personal_access_token
  }
}