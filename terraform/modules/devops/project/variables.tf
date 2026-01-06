variable "resource_group_name" {
  type = string
}

variable "project_name" {
    type = string
    default = "bootstrap"
}
variable "visibility" {
    type = string
    default = "private"
}
variable "version_control" {
    type = string
    default = "Git"
}
variable "work_item_template" {
    type = string
    default = "Agile"
}
variable "description" {
    type = string
    default = "Managed by Terraform"
}
variable "features" {
    type = object({
      testplans = string
      artifacts = string
      boards = string
      repositories = string
      pipelines = string
    })
    default = {
      artifacts = "enabled"
      boards = "enabled"
      pipelines = "enabled"
      repositories = "enabled"
      testplans = "enabled"
    }
}
