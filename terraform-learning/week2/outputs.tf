# Output the resource group information
output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.rg.id
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.rg.location
}

# Virtual Network outputs
output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = azurerm_virtual_network.vnet.address_space
}

# Storage Module outputs
output "storage_account_id" {
  description = "The ID of the storage account"
  value       = module.storage.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.storage.storage_account_name
}

output "storage_blob_endpoint" {
  description = "The blob storage endpoint"
  value       = module.storage.primary_blob_endpoint
}

# Data Source Outputs
output "current_subscription_display_name" {
  description = "The display name of the current subscription"
  value       = data.azurerm_subscription.current.display_name
}

output "current_subscription_id" {
  description = "The ID of the current subscription"
  value       = data.azurerm_subscription.current.subscription_id
}

output "location_information" {
  description = "Information about the UK South Azure location"
  value       = data.azurerm_location.current.display_name
}