variable "repository" {
    type = list(object({
      name = string
      project_id = string
      repo_type = string
      repo_id = string
      branch_name = string
      yml_path = string
    }))
}