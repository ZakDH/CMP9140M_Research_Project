resource "azurerm_network_security_group" "primary-security-group" {
  name                = "security-group"
  location            = data.azurerm_resource_group.primary_rg.location
  resource_group_name = data.azurerm_resource_group.primary_rg.name

  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "primary-business-sga" {
  for_each                  = var.subnet_map
  subnet_id                 = azurerm_subnet.primary-business-subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.primary-security-group.id
}

resource "azurerm_subnet_network_security_group_association" "primary-web-sga" {
  subnet_id                 = azurerm_subnet.primary-web-subnet.id
  network_security_group_id = azurerm_network_security_group.primary-security-group.id
}