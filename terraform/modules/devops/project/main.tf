resource "azuredevops_project" "default" {
  name               = var.project_name
  visibility         = var.visibility
  version_control    = var.version_control
  work_item_template = var.work_item_template
  description        = var.description
  features = {
    testplans = var.features.testplans
    artifacts = var.features.artifacts
    boards = var.features.boards
    repositories = var.features.repositories
    pipelines = var.features.pipelines
  }
}
