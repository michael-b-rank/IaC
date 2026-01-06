locals {
  organization  = "find_and_replace"
  project_name  = "bootstrap"
  repo_name     = "modules"
  
  repo_url = "git::https://dev.azure.com/${local.organization}/${local.project_name}/_git/${local.repo_name}"
  repo_branch   = "main" 
}