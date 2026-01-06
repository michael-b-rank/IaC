data "azuredevops_project" "bootstrap" {
  name = var.project_name
}


resource "azuredevops_git_repository" "modules" {
  project_id     = data.azuredevops_project.bootstrap.id
  name           = var.repo_name_modules
  default_branch = "refs/heads/main"
  
  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}

resource "azuredevops_git_repository" "core" {
  project_id     = data.azuredevops_project.bootstrap.id
  name           = var.repo_name_core
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}

resource "azuredevops_git_repository" "templates" {
  project_id     = data.azuredevops_project.bootstrap.id
  name           = var.repo_name_jobs
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}

resource "azuredevops_git_repository" "other" {
  for_each = var.repo_name_others
  project_id     = data.azuredevops_project.bootstrap.id
  name           = each.value
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}