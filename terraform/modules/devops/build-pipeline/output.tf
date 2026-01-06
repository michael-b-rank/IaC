# Output a map of Pipeline Names to their unique Azure DevOps IDs
output "pipeline_ids" {
  description = "A map of pipeline names to their respective Azure DevOps build definition IDs."
  value       = { for k, p in azuredevops_build_definition.module_pipeline : k => p.id }
}

# Output the full object map if you need access to all attributes (revision, etc.)
output "pipelines_full" {
  description = "The complete map of generated build definitions."
  value       = azuredevops_build_definition.module_pipeline
  # We mark this as sensitive if your YAML paths or repo IDs contain secrets
  sensitive   = false 
}

# Output a simple list of the pipeline names created
output "pipeline_names" {
  description = "A list of the names of the pipelines created."
  value       = [for p in azuredevops_build_definition.module_pipeline : p.name]
}