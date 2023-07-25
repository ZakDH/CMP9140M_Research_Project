resource "azurerm_public_ip" "project-ip-1" {
  name                = "project-ip-1"
  resource_group_name = azurerm_resource_group.project-rg.name
  location            = azurerm_resource_group.project-rg.location
  allocation_method   = "Dynamic"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_public_ip" "project-ip-2" {
  name                = "project-ip-2"
  resource_group_name = azurerm_resource_group.project-rg.name
  location            = azurerm_resource_group.project-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_public_ip" "project-ip-3" {
  name                = "project-ip-3"
  resource_group_name = azurerm_resource_group.project-rg.name
  location            = azurerm_resource_group.project-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}