resource "azurerm_virtual_network" "secondary-network" {
  name                = "network"
  location            = data.azurerm_resource_group.secondary_rg.location
  resource_group_name = data.azurerm_resource_group.secondary_rg.name
  address_space       = ["10.0.0.0/24"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "secondary-web-subnet" {
  name                 = "secondary-web-subnet"
  resource_group_name  = data.azurerm_resource_group.secondary_rg.name
  virtual_network_name = azurerm_virtual_network.secondary-network.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "secondary-business-subnet" {
  for_each             = var.subnet_map
  name                 = each.value.name
  resource_group_name  = data.azurerm_resource_group.secondary_rg.name
  virtual_network_name = azurerm_virtual_network.secondary-network.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}

# resource "azurerm_virtual_network" "secondary-network" {
#   name                = "network"
#   location            = data.azurerm_resource_group.secondary_rg.location
#   resource_group_name = data.azurerm_resource_group.secondary_rg.name
#   address_space       = ["10.1.0.0/24"]
#   tags = {
#     environment = "dev"
#   }
# }

# resource "azurerm_subnet" "secondary-web-subnet" {
#   name                 = "secondary-web-subnet"
#   resource_group_name  = data.azurerm_resource_group.secondary_rg.name
#   virtual_network_name = azurerm_virtual_network.secondary-network.name
#   address_prefixes     = ["10.1.0.0/27"]
# }

# resource "azurerm_virtual_network_peering" "peering_secondary_to_secondary" {
#   name                         = "secondary-to-secondary"
#   resource_group_name          = data.azurerm_resource_group.secondary_rg.name
#   virtual_network_name         = azurerm_virtual_network.secondary-network.name
#   remote_virtual_network_id    = azurerm_virtual_network.secondary-network.id
#   allow_forwarded_traffic      = true
#   allow_virtual_network_access = true
# }

# resource "azurerm_virtual_network_peering" "peering_secondary_to_secondary" {
#   name                         = "secondary-to-secondary"
#   resource_group_name          = data.azurerm_resource_group.secondary_rg.name
#   virtual_network_name         = azurerm_virtual_network.secondary-network.name
#   remote_virtual_network_id    = azurerm_virtual_network.secondary-network.id
#   allow_forwarded_traffic      = true
#   allow_virtual_network_access = true
# }