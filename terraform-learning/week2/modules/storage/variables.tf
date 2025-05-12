# Storage Module - Variables
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "Terraform-Test-RG"
}
variable "location" {
  description = "The Azure location where the resource group will be created."
  type        = string
  default     = "uksouth"
}
variable "storage_account_name_prefix" {
  description = "The prefix of the storage account name"
  type        = string
  default     = "tfstore"
}

variable "account_tier" {
  description = "The storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The storage account replication type"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags to apply to the storage account"
  type        = map(string)
  default     = {
    Environment = "Test"
    Owner       = "Terraform"
  }
}
variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "tfStorageAccount"
}
