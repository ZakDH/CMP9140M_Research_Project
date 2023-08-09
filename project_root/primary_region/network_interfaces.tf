resource "azurerm_network_interface" "primary-nic" {
  for_each            = var.nic_map
  name                = each.value.name
  location            = data.azurerm_resource_group.primary_rg.location
  resource_group_name = data.azurerm_resource_group.primary_rg.name
  ip_configuration {
    name                          = "${each.value.name}-internal"
    subnet_id                     = azurerm_subnet.primary-business-subnet[each.value.subnet].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.primary-business-ip[each.value.ipconfig].id
  }
  tags = {
    environment = "dev"
  }
}