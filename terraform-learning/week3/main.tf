terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    container_name      = "tfstate"
    key                 = "week3.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Get current public IP
data "http" "current_ip" {
  url = "https://api.ipify.org?format=text"
}

locals {
  current_ip = "${chomp(data.http.current_ip.response_body)}/32"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "../modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "${var.environment}-vnet"
  vnet_address_space  = ["10.0.0.0/16"]
  
  # Standard subnets for application tiers
  standard_subnets = {
    "frontend" = ["10.0.1.0/24"]
    "backend"  = ["10.0.2.0/24"]
  }
  
  # Subnet with service endpoints for data tier
  service_endpoint_subnets = {
    "data" = {
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
  }
  
  # Basic security rules
  nsg_rules = {
    "allow_https" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "443"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    }
    "allow_internal" = {
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range         = "*"
      destination_port_range    = "*"
      source_address_prefix     = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  }

  tags = var.tags
}
