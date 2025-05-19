variable "resource_group_prefix" {
  description = "Prefix for resource group names"
  type        = string
  default     = "rg-week3"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-week3-network"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "uksouth"
}

variable "environment" {
  description = "Environment name - used for resource naming"
  type        = string
  default     = "dev"
}

# Added for demonstration of different network types
variable "allowed_public_ips" {
  description = "List of allowed public IPs for public network"
  type        = list(string)
  default     = []
}

variable "additional_allowed_ips" {
  description = "Additional IP addresses to allow access to public networks"
  type        = list(string)
  default     = []  # e.g. ["10.0.0.0/24", "20.0.0.0/24"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "Development"
    Project     = "Week3-Network"
    ManagedBy   = "Terraform"
  }
}
