resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.RG-Primary-Region.location
  resource_group_name = azurerm_resource_group.RG-Primary-Region.name
  address_space       = ["10.0.0.0/24"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "web-subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.RG-Primary-Region.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "business-subnet" {
  for_each             = var.subnet_map
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.RG-Primary-Region.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet2"
  location            = azurerm_resource_group.RG-Secondary-Region.location
  resource_group_name = azurerm_resource_group.RG-Secondary-Region.name
  address_space       = ["10.1.0.0/24"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.RG-Secondary-Region.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.0.0/27"]
}

resource "azurerm_virtual_network_peering" "peering_primary_to_secondary" {
  name                         = "primary-to-secondary"
  resource_group_name          = azurerm_resource_group.RG-Primary-Region.name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peering_secondary_to_primary" {
  name                         = "secondary-to-primary"
  resource_group_name          = azurerm_resource_group.RG-Secondary-Region.name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}