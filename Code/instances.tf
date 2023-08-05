locals {
  data_inputs = {
    heading_one = var.heading_one
  }
}

resource "azurerm_windows_virtual_machine_scale_set" "web-vmss" {
  name                = "web-vmss"
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  location            = azurerm_resource_group.RG-UK-South.location
  sku                 = "Standard_F2"
  instances           = 3
  admin_username      = "adminuser"
  admin_password      = "Azure@123"
  upgrade_mode        = "Automatic"
  zones               = ["1", "2", "3"]
  zone_balance        = true
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "web-vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "publiciplb"
      primary                                = true
      subnet_id                              = azurerm_subnet.internal.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vmss-lb-bap.id]
    }
  }
}

resource "azurerm_storage_account" "appstore" {
  name                     = "appstore457768709"
  resource_group_name      = azurerm_resource_group.RG-UK-South.name
  location                 = azurerm_resource_group.RG-UK-South.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #allow_blob_public_access = true
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "appstore457768709"
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.appstore
  ]
}

resource "azurerm_storage_blob" "IIS_config" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "appstore457768709"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.data]
}

resource "azurerm_virtual_machine_scale_set_extension" "scaleset_extension" {
  name                         = "scaleset-extension"
  virtual_machine_scale_set_id = azurerm_windows_virtual_machine_scale_set.web-vmss.id
  publisher                    = "Microsoft.Compute"
  type                         = "CustomScriptExtension"
  type_handler_version         = "1.9"
  depends_on = [
    azurerm_storage_blob.IIS_config
  ]
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.appstore.name}.blob.core.windows.net/data/IIS_Config.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config.ps1"     
    }
SETTINGS
}

resource "azurerm_monitor_autoscale_setting" "example" {
  name                = "myAutoscaleSetting"
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  location            = azurerm_resource_group.RG-UK-South.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.web-vmss.id

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["admin@contoso.com"]
    }
  }

  profile {
    name = "defaultProfile"

    capacity {
      default = 3
      minimum = 3
      maximum = 9
    }
    #PERCENTAGE CPU METRIC RULES
    #Scale Out
    rule {
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }

      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.web-vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }
    }
    #Scale in
    rule {
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }

      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.web-vmss.id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }
    }

    #Memory-bytes Metric Rules
    #Scale Out
    rule {
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }

      metric_trigger {
        metric_name        = "Available Memory Bytes"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.web-vmss.id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 1073741824 #Increase 1 VM when memory in Bytes is less than 
      }
    }
    #Scale In
    rule {
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }

      metric_trigger {
        metric_name        = "Available Memory Bytes"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.web-vmss.id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 2147483648 #Increase 1 VM when memory in Bytes is greater than 
      }
    }
  }
  predictive {
    scale_mode = "Enabled"
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

  # boot_diagnostics {
  #   storage_account_uri = data.azurerm_storage_blob.primarystorage01
  # }
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