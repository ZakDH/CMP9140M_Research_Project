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

resource "azurerm_virtual_network" "primary-network" {
  name                = "primary-network"
  location            = azurerm_resource_group.RG-Primary-Region.location
  resource_group_name = azurerm_resource_group.RG-Primary-Region.name
  address_space       = ["10.0.0.0/24"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "secondary-network" {
  name                = "secondary-network"
  location            = azurerm_resource_group.RG-Secondary-Region.location
  resource_group_name = azurerm_resource_group.RG-Secondary-Region.name
  address_space       = ["10.0.1.0/24"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network_peering" "peering_primary_to_secondary" {
  name                         = "primary-to-secondary"
  resource_group_name          = azurerm_resource_group.RG-Primary-Region.name
  virtual_network_name         = azurerm_virtual_network.primary-network.name
  remote_virtual_network_id    = azurerm_virtual_network.secondary-network.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  depends_on = [
    azurerm_virtual_network.primary-network,
    azurerm_virtual_network.secondary-network
  ]
}

resource "azurerm_virtual_network_peering" "peering_secondary_to_primary" {
  name                         = "secondary-to-primary"
  resource_group_name          = azurerm_resource_group.RG-Secondary-Region.name
  virtual_network_name         = azurerm_virtual_network.secondary-network.name
  remote_virtual_network_id    = azurerm_virtual_network.primary-network.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  depends_on = [
    azurerm_virtual_network.primary-network,
    azurerm_virtual_network.secondary-network
  ]
}

output "primary_rg" {
  value = azurerm_resource_group.RG-Primary-Region.name
}

output "secondary_rg" {
  value = azurerm_resource_group.RG-Secondary-Region.name
}

output "primary_network" {
  value = azurerm_virtual_network.primary-network.name
}

output "secondary_network" {
  value = azurerm_virtual_network.secondary-network.name
}