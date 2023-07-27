# Create a web app in the web tier
resource "azurerm_service_plan" "web_plan" {
  name                = "web_plan-${count.index + 1}"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name
  count               = var.instance_count
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "zakdh-web-app" {
  name                = "zakdh-web-app-${count.index + 1}"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name
  service_plan_id     = azurerm_service_plan.web_plan[count.index].id
  count               = var.instance_count
  site_config {
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm-${count.index + 1}"
  resource_group_name   = azurerm_resource_group.project-rg.name
  location              = azurerm_resource_group.project-rg.location
  count                 = var.instance_count
  zone                  = (count.index % 3) + 1
  size                  = "Standard_B2s"
  admin_username        = "adminuser"
  admin_password        = "P@ssw0rd123!"
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  os_disk {
    name                 = "vm-${count.index + 1}-c"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.primarystorage1.primary_blob_endpoint
  }
}

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web-server" {
  name                       = "web-server-${count.index + 1}"
  count                      = var.instance_count
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
  SETTINGS
}