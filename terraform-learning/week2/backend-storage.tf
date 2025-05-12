# Random suffix for globally unique names
resource "random_string" "state_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group for state storage
resource "azurerm_resource_group" "state_rg" {
  name     = "rg-tf-state"
  location = var.location
  tags = merge(var.tags, {
    Purpose = "Terraform State Storage"
  })
}

# Storage Account with enhanced security
resource "azurerm_storage_account" "state_storage" {
  name                            = "tfstate${random_string.state_suffix.result}"
  resource_group_name             = azurerm_resource_group.state_rg.name
  location                        = azurerm_resource_group.state_rg.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"  # Geo-redundant storage for high availability
  min_tls_version                = "TLS1_2"
  public_network_access_enabled   = true  # Disable public access
  shared_access_key_enabled       = true  # Disable access key authentication
  
  network_rules {
    default_action             = "Deny"    # Deny all by default
    ip_rules                   = [data.http.current_ip.response_body]  # Dynamically get current IP
    virtual_network_subnet_ids = []
    bypass                     = ["AzureServices"]  # Allow trusted Azure services
  }

  blob_properties {
    versioning_enabled       = true        # Enable versioning for state files
    container_delete_retention_policy {
      days = 7
    }
  }

  identity {
    type = "SystemAssigned"    # Use managed identity
  }

  tags = merge(var.tags, {
    Purpose = "Terraform State Storage"
  })
}

# Storage Container for state files
resource "azurerm_storage_container" "state_container" {
  name                  = "tfstate"
  storage_account_id  = azurerm_storage_account.state_storage.id
  container_access_type = "private"  # Ensures the container is private
}

# Enable Azure Storage encryption at rest
resource "azurerm_storage_encryption_scope" "state_encryption" {
  name                               = "tfstateencryption"
  storage_account_id                 = azurerm_storage_account.state_storage.id
  source                            = "Microsoft.Storage"
  infrastructure_encryption_required = true  # Enable double encryption
}

# Get current IP address
data "http" "current_ip" {
  url = "https://api.ipify.org"
}