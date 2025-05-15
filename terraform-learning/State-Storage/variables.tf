variable "resource_group_name" {
  description = "Name of the resource group for state storage"
  type        = string
  default     = "rg-terraform-state"
}

variable "location" {
  description = "Azure region for state storage resources"
  type        = string
  default     = "uksouth"
}

variable "storage_account_name" {
  description = "Name of the storage account for Terraform state"
  type        = string
  default     = "tfstatestorage"
}

variable "container_name" {
  description = "Name of the container for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "allowed_ip_ranges" {
  description = "Additional IP ranges that can access the storage account (deployer's IP is automatically added)"
  type        = list(string)
  default     = [] # Additional IPs can be added here in CIDR format (e.g., ["203.0.113.0/24"])
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Purpose     = "Terraform State"
    Managed_By  = "Terraform"
  }
}
