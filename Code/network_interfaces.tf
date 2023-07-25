resource "azurerm_network_interface" "project-nic-1" {
  name                = "project-nic-1"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name

  ip_configuration {
    name                          = "internal-nic-1"
    subnet_id                     = azurerm_subnet.az1_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "project-nic-2" {
  name                = "project-nic-2"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name

  ip_configuration {
    name                          = "internal-nic-2"
    subnet_id                     = azurerm_subnet.az2_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.project-ip-2.id
  }
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "project-nic-3" {
  name                = "project-nic-3"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name

  ip_configuration {
    name                          = "internal-nic-3"
    subnet_id                     = azurerm_subnet.az3_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.project-ip-3.id
  }
  tags = {
    environment = "dev"
  }
}