output "modules" {
    value = {
        id = azuredevops_git_repository.modules.id
        default_branch = azuredevops_git_repository.modules.default_branch
        url = azuredevops_git_repository.modules.url
        ssh_url = azuredevops_git_repository.modules.ssh_url
        web_url = azuredevops_git_repository.modules.web_url
        size = azuredevops_git_repository.modules.size
        name = var.repo_name_modules
    }
}

output "core" {
    value = {
        id = azuredevops_git_repository.core.id
        default_branch = azuredevops_git_repository.core.default_branch
        url = azuredevops_git_repository.core.url
        ssh_url = azuredevops_git_repository.core.ssh_url
        web_url = azuredevops_git_repository.core.web_url
        size = azuredevops_git_repository.core.size
        name = var.repo_name_core
    }
}

output "templates" {
    value = {
        id = azuredevops_git_repository.templates.id
        default_branch = azuredevops_git_repository.templates.default_branch
        url = azuredevops_git_repository.templates.url
        ssh_url = azuredevops_git_repository.templates.ssh_url
        web_url = azuredevops_git_repository.templates.web_url
        size = azuredevops_git_repository.templates.size
        name = var.repo_name_jobs
    }
}

