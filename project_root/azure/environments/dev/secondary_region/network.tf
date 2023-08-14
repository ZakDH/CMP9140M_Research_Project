resource "azurerm_subnet" "secondary-web-subnet" {
  name                 = "secondary-web-subnet"
  resource_group_name  = data.azurerm_resource_group.secondary_rg.name
  virtual_network_name = data.azurerm_virtual_network.secondary_network.name
  address_prefixes     = ["10.0.1.0/27"]
}

resource "azurerm_subnet" "secondary-business-subnet" {
  for_each             = var.subnet_map
  name                 = each.value.name
  resource_group_name  = data.azurerm_resource_group.secondary_rg.name
  virtual_network_name = data.azurerm_virtual_network.secondary_network.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}