# module "database_secondary" {
#   source               = "../modules/database"
#   database_name_prefix = "secondary"
#   location             = data.azurerm_resource_group.secondary_rg.location
#   resource_group_name  = data.azurerm_resource_group.secondary_rg.name
# }