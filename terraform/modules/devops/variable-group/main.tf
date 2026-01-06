resource "azuredevops_variable_group" "inline" {
  count = var.vault_id == null && var.vault_name == null ? 1 : 0
  project_id  = var.project_id
  name        = var.name
  description = var.description
  allow_access = var.allow_access

  dynamic "variable" {    
    for_each = { 
      for item in var.content : item.name => item 
      if !item.is_secret #&& item.var.inline_or_vault == "inline"
      }

    content {
      name = variable.key
      value        = variable.value.value
    }
  }

  dynamic "variable" {    
      for_each = { 
        for item in var.content : item.name => item 
        if item.is_secret #&& item.var.inline_or_vault == "inline"
        }

      content {
        name = variable.key
        is_secret = variable.value.is_secret
        secret_value = variable.value.secret_value
      }

    }

    

}

resource "azuredevops_variable_group" "keyvault" {
  count = var.vault_id != null && var.vault_name != null ? 1 : 0
  project_id  = var.project_id
  name        = var.name
  description = var.description
  allow_access = var.allow_access
  
  key_vault {
    name = var.vault_name
    service_endpoint_id = var.vault_id
  }
  
  dynamic "variable" {    
      for_each = { 
        for item in var.content : item.name => item 
        if item.is_secret  && item.var.inline_or_vault == "vault"
        }

      content {
        name = variable.key
      }

    }

}