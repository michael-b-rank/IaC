resource "azuredevops_build_definition" "module_pipeline" {
    for_each = { for repo in var.repository : repo.name => repo }    
    
    project_id = each.value.project_id
    name       =  each.value.name

  repository {
    repo_type   = each.value.repo_type
    # The ID of your Modules Repository
    repo_id     = each.value.repo_id
    branch_name = each.value.branch_name != "" ? each.value.branch_name : "refs/heads/main"
    yml_path    = each.value.yml_path  # Path to the yml file inside that repo
  }

  ci_trigger {
    use_yaml = true
  }
}