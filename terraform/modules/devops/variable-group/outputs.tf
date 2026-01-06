output "id" {
    value = azuredevops_variable_group.inline[0].id
}

output "content" {
    value = var.content
    sensitive = true
}