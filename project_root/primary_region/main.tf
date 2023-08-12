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

data "azurerm_resource_group" "primary_rg" {
  name = "RG-Primary-Region"
}

data "azurerm_resource_group" "secondary_rg" {
  name = "RG-Secondary-Region"
}

data "azurerm_virtual_network" "primary_network" {
  name = "primary-network"
  resource_group_name = "RG-Primary-Region"
}

data "azurerm_virtual_network" "secondary_network" {
  name = "secondary-network"
  resource_group_name = "RG-Secondary-Region"
}