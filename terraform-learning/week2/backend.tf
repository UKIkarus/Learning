# Configure Terraform Backend
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state" # Replace with your resource group name
    # Ensure the resource group exists before running this
    storage_account_name = "tfstatestorageshs21" # Replace with your storage account name
    container_name       = "tfstate" # Replace with your container name
    key                 = "week2.tfstate"
    use_azuread_auth    = true
    # Authentication is handled by environment variables:
    # ARM_SUBSCRIPTION_ID
    # ARM_TENANT_ID
    # ARM_CLIENT_ID
    # ARM_CLIENT_SECRET
    # ARM_USE_AZUREAD
  }
}
