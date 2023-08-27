# Configuration for storage account
resource "azurerm_storage_account" "primary_web_storage" {
  name                     = "primaryvmssstorage"
  resource_group_name      = azurerm_resource_group.RG-Primary-Region.name
  location                 = azurerm_resource_group.RG-Primary-Region.location
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

# Configuration for storage container
resource "azurerm_storage_container" "primary_web_container" {
  name                  = "primaryvmsscontainer"
  storage_account_name  = "primaryvmssstorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.primary_web_storage]
}

# Configuration for storage blob
resource "azurerm_storage_blob" "primary_web_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "primaryvmssstorage"
  storage_container_name = "primaryvmsscontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.primary_web_container]
}

resource "azurerm_storage_account" "primary_business_storage" {
  name                     = "primarybusinessstorage"
  resource_group_name      = azurerm_resource_group.RG-Primary-Region.name
  location                 = azurerm_resource_group.RG-Primary-Region.location
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

# STORAGE FOR SECONDARY WEB-VMSS
resource "azurerm_storage_account" "secondary_web_storage" {
  name                     = "secondaryvmssstorage"
  resource_group_name      = azurerm_resource_group.RG-Secondary-Region.name
  location                 = azurerm_resource_group.RG-Secondary-Region.location
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
  resource_group_name      = azurerm_resource_group.RG-Secondary-Region.name
  location                 = azurerm_resource_group.RG-Secondary-Region.location
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

resource "azurerm_storage_object_replication" "primary_web_replication" {
  source_storage_account_id      = azurerm_storage_account.primary_web_storage.id
  destination_storage_account_id = azurerm_storage_account.secondary_web_storage.id
  rules {
    source_container_name      = azurerm_storage_container.primary_web_container.name
    destination_container_name = azurerm_storage_container.secondary_web_container.name
  }
}

resource "azurerm_storage_object_replication" "primary_business_replication" {
  source_storage_account_id      = azurerm_storage_account.primary_business_storage.id
  destination_storage_account_id = azurerm_storage_account.secondary_business_storage.id
  rules {
    source_container_name      = azurerm_storage_container.primary_business_container.name
    destination_container_name = azurerm_storage_container.secondary_business_container.name
  }
}