resource "azurerm_network_security_group" "project-sg" {
  name                = "project-sg"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "project-dev-rule" {
  name                        = "project-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.project-rg.name
  network_security_group_name = azurerm_network_security_group.project-sg.name
}

resource "azurerm_subnet_network_security_group_association" "project-sga-1" {
  subnet_id                 = azurerm_subnet.az1_subnet.id
  network_security_group_id = azurerm_network_security_group.project-sg.id
}
resource "azurerm_subnet_network_security_group_association" "project-sga-2" {
  subnet_id                 = azurerm_subnet.az2_subnet.id
  network_security_group_id = azurerm_network_security_group.project-sg.id
}
resource "azurerm_subnet_network_security_group_association" "project-sga-3" {
  subnet_id                 = azurerm_subnet.az3_subnet.id
  network_security_group_id = azurerm_network_security_group.project-sg.id
}
