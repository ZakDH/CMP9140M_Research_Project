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

# Calls the resource group reference from root directory output
data "azurerm_resource_group" "primary_rg" {
  name = "RG-Primary-Region"
}

# Calls the network resource reference from root directory output
data "azurerm_virtual_network" "primary_network" {
  name                = "primary-network"
  resource_group_name = "RG-Primary-Region"
}

# Calls storage account resource for web tier from root directory output
data "azurerm_storage_account" "primary_web_storage" {
  name                = "primaryvmssstorage"
  resource_group_name = data.azurerm_resource_group.primary_rg.name
}

# Calls storage container resource for web tier from root directory output
data "azurerm_storage_container" "primary_web_container" {
  name                 = "primaryvmsscontainer"
  storage_account_name = "primaryvmssstorage"
}

# Calls storage account resource for business tier from root directory output
data "azurerm_storage_account" "primary_business_storage" {
  name                = "primarybusinessstorage"
  resource_group_name = data.azurerm_resource_group.primary_rg.name
}

# Calls storage container resource for business tier from root directory output
data "azurerm_storage_container" "primary_business_container" {
  name                 = "primarybusinesscontainer"
  storage_account_name = "primarybusinessstorage"
}