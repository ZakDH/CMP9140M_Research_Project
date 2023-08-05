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

resource "azurerm_resource_group" "RG-UK-South" {
  name     = "RG-UK-South"
  location = "UK South"
  tags = {
    environment = "dev"
  }
}
