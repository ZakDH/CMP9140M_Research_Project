# Create a web app in the web tier
resource "azurerm_service_plan" "web_tier_plan" {
  name                = "web_tier_plan"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "web-tier-app" {
  name                = "web-tier-app"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name
  service_plan_id     = azurerm_service_plan.web_tier_plan.id
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
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
}