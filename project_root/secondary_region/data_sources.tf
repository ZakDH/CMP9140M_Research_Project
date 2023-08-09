data "azurerm_resource_group" "secondary_rg" {
  name = module.root.secondary_rg_name
}
