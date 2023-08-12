terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.68.0"
    }
  }
}

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

resource "azurerm_resource_group" "RG-Primary-Region" {
  name     = "RG-Primary-Region"
  location = "UK South"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_resource_group" "RG-Secondary-Region" {
  name     = "RG-Secondary-Region"
  location = "North Europe"
  tags = {
    environment = "dev"
  }
}

output "primary_rg" {
  value = azurerm_resource_group.RG-Primary-Region.name
}

output "secondary_rg" {
  value = azurerm_resource_group.RG-Secondary-Region.name
}