# Week 3: Conditional Network Infrastructure with Terraform

This week explores creating an intelligent network module that adapts its configuration based on deployment type. We've implemented conditional logic to create different network architectures from a single, flexible module.

## Learning Objectives

- Understanding Terraform conditional expressions
- Implementing dynamic network configurations
- Using locals for complex logic
- Creating reusable, multi-purpose modules

## Features

### Dynamic Network Types
The module automatically configures different network patterns based on the `deployment_type` variable:

- **Private Networks**
  - No public endpoints
  - All private endpoints enabled
  - Internal-only NSG rules
  - Service endpoints for Azure services
  - Ideal for: databases, internal services, sensitive workloads

- **Public Networks**
  - HTTPS/HTTP endpoints enabled
  - Dynamic IP allowlisting
  - Public endpoint support
  - Automatic deployer IP detection
  - Ideal for: web applications, public APIs

- **Hybrid Networks**
  - DMZ architecture
  - Public and private subnet segregation
  - Layered security approach
  - Controlled internal traffic flow
  - Ideal for: enterprise applications, multi-tier systems

### Smart Security Controls
- Automatic NSG rule generation based on network type
- Built-in deny-all rules with proper priorities
- Dynamic IP restriction support
- Conditional service endpoint enablement

## Implementation Details

### Conditional Logic
The module uses several types of conditional logic:

1. **Deployment Type Validation**
```hcl
variable "deployment_type" {
  type        = string
  validation {
    condition     = contains(["public", "private", "hybrid"], var.deployment_type)
    error_message = "deployment_type must be 'public', 'private', or 'hybrid'"
  }
}
```

2. **Dynamic NSG Rules**
```hcl
locals {
  # Base rules for all deployments
  base_nsg_rules = { ... }
  
  # Conditional public access rules
  public_nsg_rules = var.deployment_type == "public" ? { ... } : {}
  
  # Combine rules based on deployment type
  effective_nsg_rules = merge(
    local.base_nsg_rules,
    var.deployment_type != "private" ? local.public_nsg_rules : {},
    var.nsg_rules
  )
}
```

### Module Usage Examples

#### Private Network (Internal Systems)
```hcl
module "private_network" {
  source           = "../modules/network"
  deployment_type  = "private"
  vnet_name        = "private-vnet"
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
}
```

#### Public Network (Internet-Facing)
```hcl
module "public_network" {
  source           = "../modules/network"
  deployment_type  = "public"
  vnet_name        = "public-vnet"
  vnet_address_space = ["10.1.0.0/16"]
  
  standard_subnets = {
    "web_tier" = ["10.1.1.0/24"]
    "api_tier" = ["10.1.2.0/24"]
  }

  # Automatically includes deployer's IP
  allowed_public_ips = concat([local.current_ip], var.additional_allowed_ips)
}
```

#### Hybrid Network (DMZ Architecture)
```hcl
module "hybrid_network" {
  source           = "../modules/network"
  deployment_type  = "hybrid"
  vnet_name        = "hybrid-vnet"
  vnet_address_space = ["10.2.0.0/16"]
  
  standard_subnets = {
    "dmz"      = ["10.2.1.0/24"]
    "web_tier" = ["10.2.2.0/24"]
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
}
```

## Prerequisites

- Azure subscription
- Terraform installed (v1.0.0 or newer)
- Azure CLI installed and authenticated
- Existing state storage configuration (from root level)

## Getting Started

1. Initialize Terraform with remote state:
```bash
terraform init -backend-config="storage_account_name=<your-storage-account>"
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform validate
terraform apply
```

## Module Configuration

### Core Parameters
| Parameter | Description | Type | Required |
|-----------|-------------|------|----------|
| `deployment_type` | Network type (public/private/hybrid) | string | Yes |
| `resource_group_name` | Resource group name | string | Yes |
| `location` | Azure region | string | Yes |
| `vnet_name` | Virtual network name | string | Yes |
| `vnet_address_space` | VNet address ranges | list(string) | No |

### Network Security Parameters
| Parameter | Description | Type | Default |
|-----------|-------------|------|---------|
| `allowed_public_ips` | Allowed public IPs for public networks | list(string) | `[local.current_ip]` |
| `additional_allowed_ips` | Additional allowed IP ranges | list(string) | `[]` |
| `nsg_rules` | Custom NSG rules | map(object) | `{}` |

### Subnet Configuration
| Parameter | Description | Type | Notes |
|-----------|-------------|------|-------|
| `standard_subnets` | Basic subnets | map(list(string)) | Required |
| `service_endpoint_subnets` | Subnets with service endpoints | map(object) | Optional |

## Key Learnings

### Terraform Techniques
1. **Conditional Logic**
   - Using variables to control resource creation
   - Implementing dynamic configurations
   - Managing complex dependencies

2. **Local Values**
   - Combining multiple conditions
   - Creating reusable logic blocks
   - Simplifying complex expressions

3. **Dynamic Blocks**
   - Avoiding repetitive configuration
   - Creating flexible resource definitions
   - Managing variable-length configurations

### Network Design Patterns
1. **Security by Design**
   - Automatic NSG rule generation
   - Layered security approach
   - Network segregation

2. **Flexible Architecture**
   - Multi-purpose module design
   - Adaptable configurations
   - Reusable components

3. **Best Practices**
   - Clear separation of concerns
   - Consistent naming conventions
   - Comprehensive documentation

## Common Issues and Solutions

1. **IP Range Management**
   ```hcl
   # Ensure VNet contains all subnets
   vnet_address_space = ["10.0.0.0/16"]
   standard_subnets = {
     "subnet1" = ["10.0.1.0/24"]  # Must be within VNet range
   }
   ```

2. **NSG Rule Priorities**
   ```hcl
   # Rules processed in priority order
   nsg_rules = {
     "allow_specific" = { priority = 100, ... }
     "deny_all"      = { priority = 4096, ... }
   }
   ```

3. **Service Endpoints**
   ```hcl
   # Only enabled in private/hybrid networks
   service_endpoint_subnets = var.deployment_type != "public" ? {...} : {}
   ```

## Future Enhancements

1. **Network Features**
   - Route tables for traffic control
   - VPN Gateway integration
   - Azure Firewall implementation
   - Network Watcher integration

2. **Security Enhancements**
   - DDoS protection
   - Azure Private Link support
   - Just-in-Time access
   - Network flow logs

3. **Module Extensions**
   - Peering configurations
   - Multi-region support
   - Custom route tables
   - Advanced NSG rules
