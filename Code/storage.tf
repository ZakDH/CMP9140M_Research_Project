# Create Azure Storage Account required for Function App
resource "azurerm_storage_account" "primarystorage1" {
  name                     = "primarystorage1"
  resource_group_name      = azurerm_resource_group.project-rg.name
  location                 = azurerm_resource_group.project-rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "primaryblob1" {
  name                  = "primaryblob1"
  storage_account_name  = azurerm_storage_account.primarystorage1.name
  container_access_type = "blob"
}