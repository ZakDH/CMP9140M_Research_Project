resource "azurerm_network_interface" "nic" {
  name                = "nic-01-${var.vm_name}${count.index + 1}"
  location            = azurerm_resource_group.RG-UK-South.location
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  count               = var.instance_count
  ip_configuration {
    name                          = "${var.vm_name}${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip[count.index].id
  }
  tags = {
    environment = "dev"
  }
}