# Terraform State Storage Infrastructure

This module sets up the infrastructure required for secure and centralized Terraform state management in Azure. It creates a dedicated storage account with appropriate security controls and access restrictions.

## Features

- Secure Azure Storage Account with:
  - Default deny network rules
  - IP-based access restrictions
  - Infrastructure encryption
  - Resource locks
  - Versioning and retention policies
- Dedicated container for Terraform state files
- Comprehensive security controls
- Access logging and monitoring

## Prerequisites

- Azure subscription
- Azure CLI installed and configured
- Terraform installed (version 1.x or later)
- Appropriate Azure permissions to create resources

## Usage

1. Initialize the State-Storage infrastructure first:

```bash
cd State-Storage
terraform init
terraform plan
terraform apply
```

2. Note the outputs, which will be needed to configure other projects' backend.

3. Update other projects' backend configuration:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "<storage_account_name>"
    container_name       = "tfstate"
    key                  = "project.tfstate"
  }
}
```

## Security Considerations

- The storage account is configured with network rules that deny access by default
- Access is automatically granted to the deploying client's IP address
- Additional IP ranges can be specified via variables
- All data is encrypted at rest with infrastructure encryption enabled
- Resource locks prevent accidental deletion
- Access is logged and monitored
- Soft delete and versioning enabled for state file protection with 30-day retention

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| resource_group_name | Name of the resource group | string | "rg-terraform-state" |
| location | Azure region for resources | string | "uksouth" |
| storage_account_name | Name of the storage account | string | "tfstatestorage" |
| container_name | Name of the state container | string | "tfstate" |
| allowed_ip_ranges | Allowed IP ranges for access | list(string) | [] |

## Outputs

| Name | Description |
|------|-------------|
| storage_account_name | Name of the created storage account |
| container_name | Name of the state container |
| storage_account_id | Resource ID of the storage account |
| storage_account_url | URL of the storage account |

## Migration Steps

To migrate existing state to this centralized storage:

1. Note the current state file location
2. Configure the new backend in your Terraform configuration
3. Run `terraform init` and confirm the migration
4. Verify the state has been transferred successfully

## Maintenance

- Regularly review and update allowed IP ranges
- Monitor access logs for unauthorized attempts
- Periodically verify resource locks are in place
- Review and clean up old state versions as needed
