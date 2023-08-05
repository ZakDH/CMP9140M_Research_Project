locals {
  data_inputs = {
    heading_one = var.heading_one
  }
}
resource "azurerm_lb" "vmss-lb" {
  for_each            = var.vmss_lb_map
  name                = each.value.name
  location            = azurerm_resource_group.RG-UK-South.location
  resource_group_name = azurerm_resource_group.RG-UK-South.name

  frontend_ip_configuration {
    name                 = "${each.value.name}-frontendip"
    public_ip_address_id = azurerm_public_ip.publicip[each.value.publicip].id
  }
}

resource "azurerm_lb_backend_address_pool" "vmss-lb-bap" {
  for_each            = var.vmss_lb_map
  loadbalancer_id = azurerm_lb.vmss-lb[each.value.vmss-lb].id
  name            = "${each.value.name}-bap"
}

resource "azurerm_lb_rule" "vmss-lb-rule" {
  for_each            = var.vmss_lb_map
  loadbalancer_id                = azurerm_lb.vmss-lb[each.value.vmss-lb].id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "vmss-ipconfig"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.vmss-lb-bap.id]
}

resource "azurerm_linux_virtual_machine_scale_set" "web-vmss" {
  for_each            = var.vmss_map
  name                = each.value.name
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  location            = azurerm_resource_group.RG-UK-South.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"
  user_data = base64encode(templatefile("linux_userdata.tftpl", local.data_inputs))
  zones     = each.value.zone
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("vm.pub")
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  # custom_data = base64encode(<<EOF
  # #!/bin/bash
  # echo "Hello from the outside world!"
  # EOF
  # )

  network_interface {
    name    = "${each.value.name}-nic"
    primary = true

    ip_configuration {
      name                                   = "${each.value.name}-ipconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet[each.value.subnet].id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vmss-lb-bap.id]
    }
  }
}

resource "azurerm_windows_virtual_machine" "business-vm" {
  for_each              = var.vm_map
  name                  = each.value.name
  resource_group_name   = azurerm_resource_group.RG-UK-South.name
  location              = azurerm_resource_group.RG-UK-South.location
  zone                  = each.value.zone
  size                  = "Standard_B2s"
  admin_username        = "adminuser"
  admin_password        = "P@ssw0rd123!"
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic].id]
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
# # Install IIS web server to the virtual machine
# resource "azurerm_virtual_machine_extension" "web-server" {
#   name                       = "web-server-${count.index + 1}"
#   count                      = var.instance_count
#   virtual_machine_id         = azurerm_windows_virtual_machine.vm[count.index].id
#   publisher                  = "Microsoft.Compute"
#   type                       = "CustomScriptExtension"
#   type_handler_version       = "1.8"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#       "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
#     }
#   SETTINGS
# }