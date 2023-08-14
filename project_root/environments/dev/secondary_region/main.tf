# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    virtual_machine_scale_set {
      force_delete                  = false
      roll_instances_when_required  = true
      scale_to_zero_before_deletion = true
    }
  }
}

data "azurerm_resource_group" "secondary_rg" {
  name = "RG-Secondary-Region"
}

data "azurerm_virtual_network" "secondary_network" {
  name                = "secondary-network"
  resource_group_name = "RG-Secondary-Region"
}

# data "azurerm_storage_account" "secondary_web_storage" {
#   name                = "secondaryvmssstorage"
#   resource_group_name = data.azurerm_resource_group.secondary_rg.name
# }

# data "azurerm_storage_container" "secondary_web_container" {
#   name                 = "secondaryvmsscontainer"
#   storage_account_name = "secondaryvmssstorage"
# }

# data "azurerm_storage_account" "secondary_business_storage" {
#   name                = "secondarybusinessstorage"
#   resource_group_name = data.azurerm_resource_group.secondary_rg.name
# }

# data "azurerm_storage_container" "secondary_business_container" {
#   name                 = "secondarybusinesscontainer"
#   storage_account_name = "secondarybusinessstorage"
# }