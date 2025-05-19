output "private_network" {
  description = "Private network configuration"
  value = {
    vnet_id     = module.private_network.vnet_id
    vnet_name   = module.private_network.vnet_name
    subnet_ids  = module.private_network.subnet_ids
    nsg_id      = module.private_network.nsg_id
  }
}

output "public_network" {
  description = "Public network configuration"
  value = {
    vnet_id     = module.public_network.vnet_id
    vnet_name   = module.public_network.vnet_name
    subnet_ids  = module.public_network.subnet_ids
    nsg_id      = module.public_network.nsg_id
  }
}

output "hybrid_network" {
  description = "Hybrid network configuration"
  value = {
    vnet_id     = module.hybrid_network.vnet_id
    vnet_name   = module.hybrid_network.vnet_name
    subnet_ids  = module.hybrid_network.subnet_ids
    nsg_id      = module.hybrid_network.nsg_id
  }
}
