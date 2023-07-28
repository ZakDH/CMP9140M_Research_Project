resource "azurerm_virtual_network" "project-vn" {
  name                = "project-vn"
  location            = azurerm_resource_group.RG-UK-South.location
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  address_space       = ["10.0.0.0/24"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "subnet" {
  count                = var.instance_count
  name                 = "subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.RG-UK-South.name
  virtual_network_name = azurerm_virtual_network.project-vn.name
  address_prefixes     = ["10.0.0.${count.index * 32}/27"]
  service_endpoints    = ["Microsoft.Storage"]
}