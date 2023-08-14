module "secondary_storage" {
  source             = "../modules/storage"
  storage_prefix     = "secondary"
  location           = azurerm_resource_group.secondary_rg.location
  resource_group_name = azurerm_resource_group.secondary_rg.name
  destination_storage_account_id = azurerm_storage_account.primary_web_storage.id
  destination_container_name = azurerm_storage_container.primary_web_container.name
}

resource "azurerm_storage_object_replication" "web_replication" {
  source_storage_account_id      = module.secondary_storage.web_storage_id
  destination_storage_account_id = module.primary_storage.web_storage_name
  rules {
    source_container_name      = module.secondary_storage.web_container_name
    destination_container_name = module.primary_storage.web_container_name
  }
  depends_on = [
    azurerm_storage_container.web_container,
    data.azurerm_storage_container.web_container
  ]
}

resource "azurerm_storage_object_replication" "business_replication" {
  source_storage_account_id      = module.secondary_storage.business_storage_id
  destination_storage_account_id = module.primary_storage.business_storage_name
  rules {
    source_container_name      = module.secondary_storage.business_container_name
    destination_container_name = module.primary_storage.business_container_name
  }
  depends_on = [
    azurerm_storage_container.business_container,
    data.azurerm_storage_container.business_container
  ]
}

# # STORAGE FOR SECONDARY WEB-VMSS
# resource "azurerm_storage_account" "secondary_web_storage" {
#   name                     = "secondaryvmssstorage"
#   resource_group_name      = data.azurerm_resource_group.secondary_rg.name
#   location                 = data.azurerm_resource_group.secondary_rg.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags = {
#     environment = "dev"
#   }
# }

# resource "azurerm_storage_container" "secondary_web_container" {
#   name                  = "secondaryvmsscontainer"
#   storage_account_name  = "secondaryvmssstorage"
#   container_access_type = "blob"
#   depends_on            = [azurerm_storage_account.secondary_web_storage]
# }

# resource "azurerm_storage_blob" "secondary_web_blob" {
#   name                   = "IIS_Config.ps1"
#   storage_account_name   = "secondaryvmssstorage"
#   storage_container_name = "secondaryvmsscontainer"
#   type                   = "Block"
#   source                 = "IIS_Config.ps1"
#   depends_on             = [azurerm_storage_container.secondary_web_container]
# }

# # STORAGE FOR SECONDARY BUSINESS VMS
# resource "azurerm_storage_account" "secondary_business_storage" {
#   name                     = "secondarybusinessstorage"
#   resource_group_name      = data.azurerm_resource_group.secondary_rg.name
#   location                 = data.azurerm_resource_group.secondary_rg.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags = {
#     environment = "dev"
#   }
# }

# resource "azurerm_storage_container" "secondary_business_container" {
#   name                  = "secondarybusinesscontainer"
#   storage_account_name  = "secondarybusinessstorage"
#   container_access_type = "blob"
#   depends_on            = [azurerm_storage_account.secondary_business_storage]
# }

# resource "azurerm_storage_blob" "secondary_business_blob" {
#   name                   = "IIS_Config.ps1"
#   storage_account_name   = "secondarybusinessstorage"
#   storage_container_name = "secondarybusinesscontainer"
#   type                   = "Block"
#   source                 = "IIS_Config.ps1"
#   depends_on             = [azurerm_storage_container.secondary_business_container]
# }

# output "secondarywebstorage" {
#   value = azurerm_storage_account.secondary_web_storage.id
# }

# output "secondarywebcontainer" {
#   value = azurerm_storage_container.secondary_web_container.name
# }

# output "secondarybusinessstorage" {
#   value = azurerm_storage_account.secondary_business_storage.id
# }

# output "secondarybusinesscontainer" {
#   value = azurerm_storage_container.secondary_business_container.name
# }