# Create the load balancer for web tier
# resource "azurerm_lb" "project-web-lb" {
#   name                = "project-web-lb"
#   location            = azurerm_resource_group.project-rg.location
#   resource_group_name = azurerm_resource_group.project-rg.name
# }