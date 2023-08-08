resource "azurerm_public_ip" "business-ip" {
  for_each            = var.ip_map
  name                = each.value.name
  resource_group_name = azurerm_resource_group.RG-Primary-Region.name
  location            = azurerm_resource_group.RG-Primary-Region.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = each.value.zones
  tags = {
    environment = "dev"
  }
}

resource "azurerm_public_ip" "web-ip" {
  name                = "web-ip"
  resource_group_name = azurerm_resource_group.RG-Primary-Region.name
  location            = azurerm_resource_group.RG-Primary-Region.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags = {
    environment = "dev"
  }
}