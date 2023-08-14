resource "azurerm_subnet" "primary-web-subnet" {
  name                 = "primary-web-subnet"
  resource_group_name  = data.azurerm_resource_group.primary_rg.name
  virtual_network_name = data.azurerm_virtual_network.primary_network.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "primary-business-subnet" {
  for_each             = var.subnet_map
  name                 = each.value.name
  resource_group_name  = data.azurerm_resource_group.primary_rg.name
  virtual_network_name = data.azurerm_virtual_network.primary_network.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}