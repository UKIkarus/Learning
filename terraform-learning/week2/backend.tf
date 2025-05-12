# Configure Terraform Backend
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-state"
    storage_account_name = "tfstatehn1wi1"
    container_name       = "tfstate"
    key                 = "week2.tfstate"
    use_azuread_auth    = true
    # Authentication is handled by environment variables:
    # ARM_SUBSCRIPTION_ID - set automatically
    # ARM_TENANT_ID - set automatically
    # ARM_USE_AZUREAD - set to true
  }
}
