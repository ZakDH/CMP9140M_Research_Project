# STORAGE FOR SECONDARY WEB-VMSS
resource "azurerm_storage_account" "secondary_web_storage" {
  name                     = "secondaryvmssstorage"
  resource_group_name      = data.azurerm_resource_group.secondary_rg.name
  location                 = data.azurerm_resource_group.secondary_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "secondary_web_container" {
  name                  = "secondaryvmsscontainer"
  storage_account_name  = "secondaryvmssstorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.secondary_web_storage]
}

resource "azurerm_storage_blob" "secondary_web_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "secondaryvmssstorage"
  storage_container_name = "secondaryvmsscontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.secondary_web_container]
}

# STORAGE FOR SECONDARY BUSINESS VMS
resource "azurerm_storage_account" "secondary_business_storage" {
  name                     = "secondarybusinessstorage"
  resource_group_name      = data.azurerm_resource_group.secondary_rg.name
  location                 = data.azurerm_resource_group.secondary_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "secondary_business_container" {
  name                  = "secondarybusinesscontainer"
  storage_account_name  = "secondarybusinessstorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.secondary_business_storage]
}

resource "azurerm_storage_blob" "secondary_business_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "secondarybusinessstorage"
  storage_container_name = "secondarybusinesscontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.secondary_business_container]
}

output "secondary_web_storage" {
  value = azurerm_storage_account.secondary_web_storage.id
}

output "secondary_web_container" {
  value = azurerm_storage_container.secondary_web_container.name
}

output "secondary_business_storage" {
  value = azurerm_storage_account.secondary_business_storage.id
}

output "secondary_business_container" {
  value = azurerm_storage_container.secondary_business_container.name
}