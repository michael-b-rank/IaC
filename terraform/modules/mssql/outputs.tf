output "connection_policy" {
    value = azurerm_mssql_server.mssqlserver.connection_policy
}
output "express_vulnerability_assessment_enabled" {
    value = azurerm_mssql_server.mssqlserver.express_vulnerability_assessment_enabled
}
output "fully_qualified_domain_name" {
    value = azurerm_mssql_server.mssqlserver.fully_qualified_domain_name
}
output "id" {
    value = azurerm_mssql_server.mssqlserver.id
}
output "identity" {
    value = azurerm_mssql_server.mssqlserver.identity
}
output "administrator_login" {
    value = azurerm_mssql_server.mssqlserver.administrator_login
    sensitive = true
}


output "location" {
    value = azurerm_mssql_server.mssqlserver.location
}
output "minimum_tls_version" {
    value = azurerm_mssql_server.mssqlserver.minimum_tls_version
}
output "name" {
    value = azurerm_mssql_server.mssqlserver.name
}
output "outbound_network_restriction_enabled" {
    value = azurerm_mssql_server.mssqlserver.outbound_network_restriction_enabled
}
output "public_network_access_enabled" {
    value = azurerm_mssql_server.mssqlserver.public_network_access_enabled
}
output "resource_group_name" {
    value = azurerm_mssql_server.mssqlserver.resource_group_name
}
output "version" {
    value = azurerm_mssql_server.mssqlserver.version
}


output "secret_content_type" {
    value = azurerm_key_vault_secret.mssql_admin_secret.content_type
}
output "secret_expiration_date" {
    value = azurerm_key_vault_secret.mssql_admin_secret.expiration_date
}
output "secret_id" {
    value = azurerm_key_vault_secret.mssql_admin_secret.id
}
output "secret_key_vault_id" {
    value = azurerm_key_vault_secret.mssql_admin_secret.key_vault_id
}
output "secret_name" {
    value = azurerm_key_vault_secret.mssql_admin_secret.name
}
output "secret_not_before_date" {
    value = azurerm_key_vault_secret.mssql_admin_secret.not_before_date
}
output "secret_resource_id" {
    value = azurerm_key_vault_secret.mssql_admin_secret.resource_id
}