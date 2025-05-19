# Example deployments for different network types

# Private Network Example
module "private_network" {
  source           = "../modules/network"
  deployment_type  = "private"
  vnet_name        = "private-vnet"
  resource_group_name = azurerm_resource_group.private.name
  location         = var.location
  vnet_address_space = ["10.0.0.0/16"]
  
  standard_subnets = {
    "internal_apps" = ["10.0.1.0/24"]
    "data_tier"     = ["10.0.2.0/24"]
  }

  service_endpoint_subnets = {
    "private_endpoints" = {
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
  }

  tags = {
    Environment = var.environment
    Access      = "Private"
  }
}

# Public Network Example
module "public_network" {
  source           = "../modules/network"
  deployment_type  = "public"
  vnet_name        = "public-vnet"
  resource_group_name = azurerm_resource_group.public.name
  location         = var.location
  vnet_address_space = ["10.1.0.0/16"]
  
  standard_subnets = {
    "web_tier"     = ["10.1.1.0/24"]
    "api_tier"     = ["10.1.2.0/24"]
  }

  allowed_public_ips = concat([local.current_ip], var.additional_allowed_ips)  # Current IP + additional IPs

  nsg_rules = {
    "allow_http" = {
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "80"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    }
  }

  tags = {
    Environment = var.environment
    Access      = "Public"
  }
}

# Hybrid Network Example
module "hybrid_network" {
  source           = "../modules/network"
  deployment_type  = "hybrid"
  vnet_name        = "hybrid-vnet"
  resource_group_name = azurerm_resource_group.hybrid.name
  location         = var.location
  vnet_address_space = ["10.2.0.0/16"]
  
  standard_subnets = {
    "dmz"          = ["10.2.1.0/24"]
    "web_tier"     = ["10.2.2.0/24"]
  }

  service_endpoint_subnets = {
    "app_tier" = {
      address_prefixes  = ["10.2.3.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
    "data_tier" = {
      address_prefixes  = ["10.2.4.0/24"]
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
  }

  nsg_rules = {
    "allow_dmz_inbound" = {
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "443"
      source_address_prefix     = "Internet"
      destination_address_prefix = "10.2.1.0/24"
    }
    "allow_web_to_app" = {
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "8080"
      source_address_prefix     = "10.2.2.0/24"
      destination_address_prefix = "10.2.3.0/24"
    }
  }

  tags = {
    Environment = var.environment
    Access      = "Hybrid"
  }
}
