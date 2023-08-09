# STORAGE FOR PRIMARY WEB-VMSS
resource "azurerm_storage_account" "primary_web_storage" {
  name                     = "primaryvmssstorage"
  resource_group_name      = data.azurerm_resource_group.primary_rg.name
  location                 = data.azurerm_resource_group.primary_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "primary_web_container" {
  name                  = "primaryvmsscontainer"
  storage_account_name  = "primaryvmssstorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.primary_web_storage]
}

resource "azurerm_storage_blob" "primary_web_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "primaryvmssstorage"
  storage_container_name = "primaryvmsscontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.primary_web_container]
}

# STORAGE FOR PRIMARY BUSINESS VMS
resource "azurerm_storage_account" "primary_business_storage" {
  name                     = "primarybusinessstorage"
  resource_group_name      = data.azurerm_resource_group.primary_rg.name
  location                 = data.azurerm_resource_group.primary_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "primary_business_container" {
  name                  = "primarybusinesscontainer"
  storage_account_name  = "primarybusinessstorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.primary_business_storage]
}

resource "azurerm_storage_blob" "primary_business_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "primarybusinessstorage"
  storage_container_name = "primarybusinesscontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.primary_business_container]
}