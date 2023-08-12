resource "azurerm_windows_virtual_machine_scale_set" "secondary-web-vmss" {
  name                = "web-vmss"
  resource_group_name = data.azurerm_resource_group.secondary_rg.name
  location            = data.azurerm_resource_group.secondary_rg.location
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
      name                                   = "web-ip"
      primary                                = true
      subnet_id                              = azurerm_subnet.secondary-web-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.secondary-vmss-lb-bap.id]
    }
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "scaleset_extension" {
  name                         = "scaleset-extension"
  virtual_machine_scale_set_id = azurerm_windows_virtual_machine_scale_set.secondary-web-vmss.id
  publisher                    = "Microsoft.Compute"
  type                         = "CustomScriptExtension"
  type_handler_version         = "1.9"
  settings = <<SETTINGS
    {
        "fileUris": ["https://${data.azurerm_storage_account.secondary_web_storage.name}.blob.core.windows.net/${data.azurerm_storage_container.secondary_web_container.name}/IIS_Config.ps1"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config.ps1"
    }
SETTINGS
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "myAutoscaleSetting"
  resource_group_name = data.azurerm_resource_group.secondary_rg.name
  location            = data.azurerm_resource_group.secondary_rg.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.secondary-web-vmss.id

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
      maximum = 10
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
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.secondary-web-vmss.id
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
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.secondary-web-vmss.id
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
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.secondary-web-vmss.id
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
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.secondary-web-vmss.id
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