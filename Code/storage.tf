# STORAGE FOR PRIMARY WEB-VMSS
resource "azurerm_storage_account" "primary_web_storage" {
  name                     = "vmssprimarystorage"
  resource_group_name      = azurerm_resource_group.RG-Primary-Region.name
  location                 = azurerm_resource_group.RG-Primary-Region.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "primary_web_container" {
  name                  = "vmssprimarycontainer"
  storage_account_name  = "vmssprimarystorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.primary_web_storage]
}

resource "azurerm_storage_blob" "primary_web_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "vmssprimarystorage"
  storage_container_name = "vmssprimarycontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.primary_web_container]
}

# STORAGE FOR PRIMARY BUSINESS VMS
resource "azurerm_storage_account" "primary_business_storage" {
  name                     = "businessprimarystorage"
  resource_group_name      = azurerm_resource_group.RG-Primary-Region.name
  location                 = azurerm_resource_group.RG-Primary-Region.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "primary_business_container" {
  name                  = "businessprimarycontainer"
  storage_account_name  = "businessprimarystorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.primary_business_storage]
}

resource "azurerm_storage_blob" "primary_business_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "businessprimarystorage"
  storage_container_name = "businessprimarycontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.primary_business_container]
}



# STORAGE FOR SECONDARY WEB-VMSS
resource "azurerm_storage_account" "secondary_storage" {
  name                     = "vmsssecondarystorage"
  resource_group_name      = azurerm_resource_group.RG-Secondary-Region.name
  location                 = azurerm_resource_group.RG-Secondary-Region.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "secondary_container" {
  name                  = "vmsssecondarycontainer"
  storage_account_name  = "vmsssecondarystorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.secondary_storage]
}