variable "repo_name_modules" {
    type = string
    default = "modules"
}

variable "repo_name_jobs" {
    type = string
    default = "jobs"
}

variable "repo_name_core" {
    type = string
    default = "azure-iac-core"
}

variable "project_name" {
    type = string
}

variable "repo_name_others" {
type = set(string)
default = [ ]
}