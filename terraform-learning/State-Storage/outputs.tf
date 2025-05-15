output "storage_account_name" {
  description = "Name of the storage account created for Terraform state"
  value       = azurerm_storage_account.state_storage.name
}

output "container_name" {
  description = "Name of the container created for Terraform state"
  value       = azurerm_storage_container.state_container.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.state_storage.id
}

output "primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.state_storage.primary_access_key
  sensitive   = true
}

output "storage_account_url" {
  description = "URL of the storage account"
  value       = azurerm_storage_account.state_storage.primary_blob_endpoint
}
