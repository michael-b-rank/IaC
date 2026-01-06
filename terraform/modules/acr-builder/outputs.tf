# 5. Output the full image name
output "full_image_name" {
  description = "The fully qualified name of the built container image."
  value       = "${data.azurerm_container_registry.acr.login_server}/${var.image_name}"
}