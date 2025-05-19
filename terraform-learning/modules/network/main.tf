locals {
  # Base NSG rules that apply to all deployment types
  base_nsg_rules = {
    "allow_internal" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range         = "*"
      destination_port_range    = "*"
      source_address_prefix     = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  }

  # Public deployment specific rules
  public_nsg_rules = var.deployment_type == "public" ? {
    "allow_https" = {
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "443"
      source_address_prefix     = length(var.allowed_public_ips) > 0 ? join(",", var.allowed_public_ips) : "*"
      destination_address_prefix = "*"
    }
  } : {}

  # Final deny rule for all deployment types
  deny_all_rule = {
    "deny_all_inbound" = {
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range         = "*"
      destination_port_range    = "*"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    }
  }

  # Combine all rules based on deployment type
  effective_nsg_rules = merge(
    local.base_nsg_rules,
    var.deployment_type != "private" ? local.public_nsg_rules : {},
    var.nsg_rules,
    local.deny_all_rule
  )
}

# Base VNet Configuration
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Standard Subnets without special configuration
resource "azurerm_subnet" "standard" {
  for_each             = var.standard_subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value
}

# Service Endpoint Subnets
resource "azurerm_subnet" "service_endpoints" {
  for_each             = var.deployment_type != "public" ? var.service_endpoint_subnets : {}
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

# NSG with predefined rules
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Separate NSG rules as individual resources
resource "azurerm_network_security_rule" "rules" {
  for_each                    = local.effective_nsg_rules
  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  resource_group_name        = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
