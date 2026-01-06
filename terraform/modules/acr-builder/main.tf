data "azurerm_container_registry" "acr" {
  name = var.acr_name
  resource_group_name = var.resource_group_name
}

resource "null_resource" "iac_runner_build" {
  
  # The triggers section ensures this resource re-runs the provisioner if
  # the ACR name or other critical build parameters change.
  triggers = {
    acr_name = var.acr_name
    # Force a rebuild if the Dockerfile changes (requires MD5 sum of the Dockerfile)
     dockerfile_hash = filemd5("${path.module}/Dockerfile") 
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Starting Azure ACR Build for image: ${var.image_name}"
      
      az acr build \
        --registry ${data.azurerm_container_registry.acr.name} \
        --image "${var.image_name}" \
        --file Dockerfile \
        --build-arg subscription_id="${var.subscription_id}" \
        --build-arg resource_group_east_name="${data.azurerm_container_registry.acr.resource_group_name}" \
        .
    EOT

    # Use a separate shell to execute the command
    interpreter = ["/bin/bash", "-c"]

    # This prevents running the command during a 'terraform destroy'
    when = create
  }
}