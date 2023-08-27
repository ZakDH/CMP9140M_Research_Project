# Configuration for the network security group
resource "azurerm_network_security_group" "secondary-security-group" {
  name                = "security-group"
  location            = data.azurerm_resource_group.secondary_rg.location
  resource_group_name = data.azurerm_resource_group.secondary_rg.name
# Configures HTTP, HTTPS and RDP inbound security rules from any source
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
  security_rule {
    name                       = "Allow_RDP"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
# Configures security rules for outbound traffic to any destination
  security_rule {
    name                       = "Allow_Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Configures the business network security group association to each subnet ID
resource "azurerm_subnet_network_security_group_association" "secondary-business-sga" {
  for_each                  = var.subnet_map
  subnet_id                 = azurerm_subnet.secondary-business-subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.secondary-security-group.id
}
# Configures the web network security group association to each subnet ID
resource "azurerm_subnet_network_security_group_association" "secondary-web-sga" {
  subnet_id                 = azurerm_subnet.secondary-web-subnet.id
  network_security_group_id = azurerm_network_security_group.secondary-security-group.id
}