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
variable "tags" {
  description = "A map of tags to assign to the resource group."
  type        = map(string)
  default = {
    Environment = "Test"
    Owner       = "Terraform"
  }
}
variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "myVnet"
}
variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
variable "storage_account_prefix" {
  description = "The prefix for the storage account name"
  type        = string
  default     = "tfstore"
}
