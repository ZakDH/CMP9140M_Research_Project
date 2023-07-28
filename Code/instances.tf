locals {
  data_inputs = {
    heading_one = var.heading_one
  }
}
# # Create a web app in the web tier
# resource "azurerm_service_plan" "web_plan" {
#   name                = "web_plan-${count.index + 1}"
#   location            = azurerm_resource_group.RG-UK-South.location
#   resource_group_name = azurerm_resource_group.RG-UK-South.name
#   count               = var.instance_count
#   sku_name            = "P1v2"
#   os_type             = "Windows"
# }

# resource "azurerm_windows_web_app" "zakdh-web-app" {
#   name                = "zakdh-web-app-${count.index + 1}"
#   location            = azurerm_resource_group.RG-UK-South.location
#   resource_group_name = azurerm_resource_group.RG-UK-South.name
#   service_plan_id     = azurerm_service_plan.web_plan[count.index].id
#   count               = var.instance_count
#   site_config {
#   }
# }

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  location            = azurerm_resource_group.RG-UK-South.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "web-subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.RG-UK-South.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  location            = azurerm_resource_group.RG-UK-South.location
  sku                 = "Standard_F2"
  instances           = 3
  admin_username      = "adminuser"
  admin_password        = "P@ssw0rd123!"
  user_data = base64encode(templatefile("linux_userdata.tftpl",local.data_inputs))
  zones = ["1","2","3"]
  disable_password_authentication = false
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

   network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name                          = "my-vmss-ipconfig"
      subnet_id                     = azurerm_subnet.web-subnet.id # Associate the first instance with subnet-1
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.example.id]
    }
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm-${count.index + 1}"
  resource_group_name   = azurerm_resource_group.RG-UK-South.name
  location              = azurerm_resource_group.RG-UK-South.location
  count                 = var.instance_count
  zone                  = (count.index % 3) + 1
  size                  = "Standard_B2s"
  admin_username        = "adminuser"
  admin_password        = "P@ssw0rd123!"
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
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