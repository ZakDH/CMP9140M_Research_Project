resource "azurerm_public_ip" "publicip" {
  name                = "publicip-${count.index + 1}"
  count               = var.instance_count
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  location            = azurerm_resource_group.RG-UK-South.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags = {
    environment = "dev"
  }
}