resource "azurerm_resource_group" "project-rg" {
  name     = "project-resources"
  location = "UK South"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "project-vn" {
  name                = "project-vn"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name
  address_space       = ["10.0.0.0/24"]
  tags = {
    environment = "dev"
  }
}

# Create three subnets with /27 CIDR blocks for each availability zone
resource "azurerm_subnet" "az1_subnet" {
  name                 = "az1-subnet"
  resource_group_name  = azurerm_resource_group.project-rg.name
  virtual_network_name = azurerm_virtual_network.project-vn.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "az2_subnet" {
  name                 = "az2-subnet"
  resource_group_name  = azurerm_resource_group.project-rg.name
  virtual_network_name = azurerm_virtual_network.project-vn.name
  address_prefixes     = ["10.0.0.32/27"]
}

resource "azurerm_subnet" "az3_subnet" {
  name                 = "az3-subnet"
  resource_group_name  = azurerm_resource_group.project-rg.name
  virtual_network_name = azurerm_virtual_network.project-vn.name
  address_prefixes     = ["10.0.0.64/27"]
}