# STORAGE FOR PRIMARY WEB-VMSS
resource "azurerm_storage_account" "web_storage" {
  name                     = "${var.storage_name_prefix}vmssstorage"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    environment = "dev"
  }
  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true
  }
}

resource "azurerm_storage_container" "web_container" {
  name                  = "${var.storage_name_prefix}vmsscontainer"
  storage_account_name  = "${var.storage_name_prefix}vmssstorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.web_storage]
}

resource "azurerm_storage_blob" "web_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "${var.storage_name_prefix}vmssstorage"
  storage_container_name = "${var.storage_name_prefix}vmsscontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.web_container]
}

# STORAGE FOR PRIMARY BUSINESS VMS
resource "azurerm_storage_account" "business_storage" {
  name                     = "${var.storage_name_prefix}businessstorage"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    environment = "dev"
  }
  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true
  }
}

resource "azurerm_storage_container" "business_container" {
  name                  = "${var.storage_name_prefix}businesscontainer"
  storage_account_name  = "${var.storage_name_prefix}businessstorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.business_storage]
}

resource "azurerm_storage_blob" "business_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "${var.storage_name_prefix}businessstorage"
  storage_container_name = "${var.storage_name_prefix}businesscontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.business_container]
}