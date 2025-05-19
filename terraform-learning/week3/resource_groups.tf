# Resource Groups for different network types
resource "azurerm_resource_group" "private" {
  name     = "${var.resource_group_prefix}-private"
  location = var.location
  tags     = merge(var.tags, {
    NetworkType = "Private"
  })
}

resource "azurerm_resource_group" "public" {
  name     = "${var.resource_group_prefix}-public"
  location = var.location
  tags     = merge(var.tags, {
    NetworkType = "Public"
  })
}

resource "azurerm_resource_group" "hybrid" {
  name     = "${var.resource_group_prefix}-hybrid"
  location = var.location
  tags     = merge(var.tags, {
    NetworkType = "Hybrid"
  })
}
