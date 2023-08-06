resource "azurerm_network_interface" "nic" {
  for_each            = var.nic_map
  name                = each.value.name
  location            = azurerm_resource_group.RG-UK-South.location
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  ip_configuration {
    name                          = "${each.value.name}-internal"
    subnet_id                     = azurerm_subnet.business-subnet[each.value.subnet].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.business-ip[each.value.ipconfig].id
  }
  tags = {
    environment = "dev"
  }
}