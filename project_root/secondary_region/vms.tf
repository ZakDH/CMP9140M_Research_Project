resource "azurerm_windows_virtual_machine" "business-vm" {
  for_each              = var.vm_map
  name                  = each.value.name
  resource_group_name   = data.azurerm_resource_group.secondary_rg.name
  location              = data.azurerm_resource_group.secondary_rg.location
  zone                  = each.value.zone
  size                  = "Standard_B2s"
  admin_username        = "adminuser"
  admin_password        = "P@ssw0rd123!"
  network_interface_ids = [azurerm_network_interface.secondary-nic[each.value.nic].id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web-server" {
  for_each             = var.vme_map
  name                 = each.value.name
  virtual_machine_id   = azurerm_windows_virtual_machine.business-vm[each.value.vm].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.secondary_business_storage.name}.blob.core.windows.net/${azurerm_storage_container.secondary_business_container.name}/IIS_Config.ps1"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config.ps1"
    }
  SETTINGS
}