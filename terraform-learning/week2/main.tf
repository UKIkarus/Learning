# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.27.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags               = var.tags
}

# Storage Module
module "storage" {
  source                    = "./modules/storage"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  storage_account_name_prefix = var.storage_account_prefix
  tags                      = var.tags
}

# Example Data source blocks 1: Get current subscription details
data "azurerm_subscription" "current" {}

# Example 2: Get information about current Azure location
data "azurerm_location" "current" {
  location = "uksouth"  # Specify a specific location to query
}