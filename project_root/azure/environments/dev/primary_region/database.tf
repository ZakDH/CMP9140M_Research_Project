# Configuration for database resources
module "database_primary" {
  source               = "../modules/database"
  database_name_prefix = "primary"
  location             = data.azurerm_resource_group.primary_rg.location
  resource_group_name  = data.azurerm_resource_group.primary_rg.name
}