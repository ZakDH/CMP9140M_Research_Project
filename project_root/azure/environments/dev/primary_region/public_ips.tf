# Configuration for business IPs
resource "azurerm_public_ip" "primary-business-ip" {
  for_each            = var.ip_map
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.primary_rg.name
  location            = data.azurerm_resource_group.primary_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = each.value.zones
  tags = {
    environment = "dev"
  }
}

# Configuration for web IPs in 3 separate zones
resource "azurerm_public_ip" "primary-web-ip" {
  name                = "web-ip"
  resource_group_name = data.azurerm_resource_group.primary_rg.name
  location            = data.azurerm_resource_group.primary_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags = {
    environment = "dev"
  }
}