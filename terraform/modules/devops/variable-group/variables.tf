variable "content" {
    type = list(object({
      name = string
      value = optional(string)
      is_secret = bool
      secret_value = optional(string)
      inline_or_vault = string
    }))
    sensitive = true
    default = []
}

variable "project_id" {
    type = string
}

variable "name" {
    type = string
}

variable "description" {
    type = string
    default = "Managed by Terraform"
}

variable "allow_access" {
    type = bool
    default = true
}

variable "vault_name" {
    type = string
    default = null
}
variable "vault_id" {
    type = string
    default = null
}
