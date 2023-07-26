resource "azurerm_network_interface" "nic" {
  name                = "nic-01-${var.vm_name}${count.index + 1}"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name
  count               = var.instance_count

  ip_configuration {
    name                          = "${var.vm_name}${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    environment = "dev"
  }
}