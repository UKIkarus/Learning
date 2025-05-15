# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.27.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Get current public IP
data "http" "current_ip" {
  url = "https://api.ipify.org"
}

locals {
  caller_ip = chomp(data.http.current_ip.response_body)
  # Ensure IP is in the correct format for Azure Storage firewall rules
  current_ip = length(regexall("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", local.caller_ip)) > 0 ? "${local.caller_ip}/32" : null
}

# Generate random suffix for globally unique storage account name
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

# Create Resource Group for State Storage
resource "azurerm_resource_group" "state_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create Storage Account for State
resource "azurerm_storage_account" "state_storage" {
  name                     = "${var.storage_account_name}${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.state_rg.name
  location                 = azurerm_resource_group.state_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  # Enable infrastructure encryption
  infrastructure_encryption_enabled = true

  # Enable versioning and retention policies
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
  }

  # Network rules with default deny
  network_rules {
    default_action = "Deny"
    ip_rules       = [local.caller_ip]  # Just use the IP without /32
    bypass         = ["AzureServices"]
  }

  tags = var.tags
}

# Create Container for State Files
resource "azurerm_storage_container" "state_container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state_storage.id
  container_access_type = "private"
}

# Add Resource Lock
resource "azurerm_management_lock" "state_lock" {
  name       = "state-storage-lock"
  scope      = azurerm_storage_account.state_storage.id
  lock_level = "CanNotDelete"
  notes      = "Protect Terraform state storage from accidental deletion"
}
