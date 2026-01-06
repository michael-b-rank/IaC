output "db_settings" {
 value =    {
    auto_pause_delay_in_minutes =  azurerm_mssql_database.database.auto_pause_delay_in_minutes
    collation =  azurerm_mssql_database.database.collation
    create_mode =  azurerm_mssql_database.database.create_mode
    creation_source_database_id =  azurerm_mssql_database.database.creation_source_database_id
    enclave_type =  azurerm_mssql_database.database.enclave_type
    geo_backup_enabled =  azurerm_mssql_database.database.geo_backup_enabled
    id =  azurerm_mssql_database.database.id
    server_id =  azurerm_mssql_database.database.server_id
    ledger_enabled =  azurerm_mssql_database.database.ledger_enabled
    license_type =  azurerm_mssql_database.database.license_type
    maintenance_configuration_name =  azurerm_mssql_database.database.maintenance_configuration_name
    max_size_gb =  azurerm_mssql_database.database.max_size_gb
    min_capacity =  azurerm_mssql_database.database.min_capacity
    name =  azurerm_mssql_database.database.name
    sku_name =  azurerm_mssql_database.database.sku_name
 }
}

output "key" {
 value =  {
    id =  azurerm_key_vault_key.key.id 
    key_size =  azurerm_key_vault_key.key.key_size
    key_type =  azurerm_key_vault_key.key.key_type
    key_vault_id =  azurerm_key_vault_key.key.key_vault_id
    name =  azurerm_key_vault_key.key.name
    resource_id =  azurerm_key_vault_key.key.resource_id
    version =  azurerm_key_vault_key.key.version
    public_key_openssh =  azurerm_key_vault_key.key.public_key_openssh
    public_key_pem =  azurerm_key_vault_key.key.public_key_pem
    expiration_date =  azurerm_key_vault_key.key.expiration_date
 }
}
output "key_access_policy" {
 value =  {
    application_id = azurerm_key_vault_access_policy.server_key_access.application_id
    certificate_permissions =    azurerm_key_vault_access_policy.server_key_access.certificate_permissions
    key_permissions =    azurerm_key_vault_access_policy.server_key_access.key_permissions
    storage_permissions =    azurerm_key_vault_access_policy.server_key_access.storage_permissions
    secret_permissions =    azurerm_key_vault_access_policy.server_key_access.secret_permissions
    key_vault_id =    azurerm_key_vault_access_policy.server_key_access.key_vault_id
    object_id =    azurerm_key_vault_access_policy.server_key_access.object_id
    tenant_id =    azurerm_key_vault_access_policy.server_key_access.tenant_id
 }
}