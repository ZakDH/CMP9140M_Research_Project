# Create availability sets for each tier
resource "azurerm_availability_set" "project-as-web" {
  name                         = "project-as-web"
  location                     = azurerm_resource_group.project-rg.location
  resource_group_name          = azurerm_resource_group.project-rg.name
  platform_update_domain_count = 1
  platform_fault_domain_count  = 1
}

resource "azurerm_windows_virtual_machine" "project-vm" {
  name                = "project-vm"
  resource_group_name = azurerm_resource_group.project-rg.name
  location            = azurerm_resource_group.project-rg.location
  size                = "Standard_B2s"
  zone                = "1"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd123!"
  network_interface_ids = [
    azurerm_network_interface.project-nic-1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
}