# Configuration for network interface card
resource "azurerm_network_interface" "secondary-nic" {
  for_each            = var.nic_map
  name                = each.value.name
  location            = data.azurerm_resource_group.secondary_rg.location
  resource_group_name = data.azurerm_resource_group.secondary_rg.name
  ip_configuration {
    name                          = "${each.value.name}-internal"
    subnet_id                     = azurerm_subnet.secondary-business-subnet[each.value.subnet].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.secondary-business-ip[each.value.ipconfig].id
  }
  tags = {
    environment = "dev"
  }
}