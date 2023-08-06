resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.RG-UK-South.location
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  address_space       = ["10.0.0.0/24"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "web-subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.RG-UK-South.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "business-subnet" {
  for_each             = var.subnet_map
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.RG-UK-South.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}