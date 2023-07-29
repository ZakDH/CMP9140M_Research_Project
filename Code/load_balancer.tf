resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "UK South"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "publicip-lb" {
  name                = "publicip-lb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "vmss-lb" {
  name                = "vmss-lb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "vmss-ipconfig"
    public_ip_address_id = azurerm_public_ip.publicip-lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "vmss-lb-bap" {
  loadbalancer_id = azurerm_lb.vmss-lb.id
  name            = "vmss-lb-bap"
}

resource "azurerm_lb_rule" "vmss-lb-rule" {
  loadbalancer_id                = azurerm_lb.vmss-lb.id
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
  #admin_password                  = "P@ssw0rd123!"
  user_data = base64encode(templatefile("linux_userdata.tftpl", local.data_inputs))
  zones     = each.value.zone
  #disable_password_authentication = false
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