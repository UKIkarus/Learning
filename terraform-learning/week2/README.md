# Terraform Learning - Week 2

## Description
Week 2 focuses on HCL (HashiCorp Configuration Language) basics, modules, and remote state. Building upon week 1, we'll:
- Deep dive into HCL block types
- Configure remote state with Azure Storage backend
- Build and consume a storage module
- Deploy additional resources

## Prerequisites
- Terraform
- AZ CLI configured
- Completed Week 1

## Usage
```bash
terraform init
terraform plan
terraform apply
```

## Block Types Overview
The project demonstrates the use of various Terraform block types:
- terraform: Core configuration
- provider: Azure provider setup
- resource: Azure resources definition
- variable: Input variables
- output: Output values
- data: External read-only data sources

## Security Considerations
The current implementation of remote state storage uses:
- Azure CLI authentication
- Shared key access for the storage account
- IP-based access restrictions
- Public network access (restricted to specific IPs)

While this setup is functional for learning purposes, it's not recommended for production environments. A more secure approach would include:
- Private Endpoints for the storage account
- VNet integration
- Managed Identities for authentication
- Complete removal of shared key access

These more secure patterns will be explored in future weeks as we progress through more advanced Azure and Terraform concepts.
