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

# STORAGE FOR PRIMARY WEB-VMSS
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

resource "azurerm_storage_container" "primary_web_container" {
  name                  = "primaryvmsscontainer"
  storage_account_name  = "primaryvmssstorage"
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.primary_web_storage]
}

resource "azurerm_storage_blob" "primary_web_blob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "primaryvmssstorage"
  storage_container_name = "primaryvmsscontainer"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on             = [azurerm_storage_container.primary_web_container]
}

# STORAGE FOR PRIMARY BUSINESS VMS
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

output "primary_network" {
  value = azurerm_virtual_network.primary-network.name
}

output "secondary_network" {
  value = azurerm_virtual_network.secondary-network.name
}

output "primary_rg" {
  value = azurerm_resource_group.RG-Primary-Region.name
}

output "RG-Secondary-Region" {
  value = azurerm_resource_group.RG-Secondary-Region.name
}

output "primarywebstorage" {
  value = azurerm_storage_account.secondary_web_storage.id
}

output "primarywebcontainer" {
  value = azurerm_storage_container.secondary_web_container.name
}

output "primarybusinessstorage" {
  value = azurerm_storage_account.secondary_business_storage.id
}

output "primarybusinesscontainer" {
  value = azurerm_storage_container.secondary_business_container.name
}

output "secondarywebstorage" {
  value = azurerm_storage_account.secondary_web_storage.id
}

output "secondarywebcontainer" {
  value = azurerm_storage_container.secondary_web_container.name
}

output "secondarybusinessstorage" {
  value = azurerm_storage_account.secondary_business_storage.id
}

output "secondarybusinesscontainer" {
  value = azurerm_storage_container.secondary_business_container.name
}