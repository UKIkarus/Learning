variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "deployment_type" {
  description = "Type of network deployment (public, private, or hybrid)"
  type        = string
  default     = "private"
  
  validation {
    condition     = contains(["public", "private", "hybrid"], var.deployment_type)
    error_message = "deployment_type must be 'public', 'private', or 'hybrid'"
  }
}

variable "standard_subnets" {
  description = "Map of subnet names to address prefixes"
  type        = map(list(string))
  default     = {}
}

variable "service_endpoint_subnets" {
  description = "Map of subnet names to configuration with service endpoints"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
  default = {}
}

variable "allowed_public_ips" {
  description = "List of allowed public IPs when deployment_type is public"
  type        = list(string)
  default     = []
}

variable "nsg_rules" {
  description = "Additional network security group rules"
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range         = string
    destination_port_range    = string
    source_address_prefix     = string
    destination_address_prefix = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
