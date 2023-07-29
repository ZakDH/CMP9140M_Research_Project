resource "azurerm_public_ip" "publicip" {
  for_each            = var.ip_map
  name                = each.value.name
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  location            = azurerm_resource_group.RG-UK-South.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = each.value.zones
  tags = {
    environment = "dev"
  }
}