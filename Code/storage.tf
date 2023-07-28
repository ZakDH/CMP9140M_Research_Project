# Create Azure Storage Account required for Function App
resource "azurerm_storage_account" "primarystorage1" {
  name                     = "primarystorage1"
  resource_group_name      = azurerm_resource_group.RG-UK-South.name
  location                 = azurerm_resource_group.RG-UK-South.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}