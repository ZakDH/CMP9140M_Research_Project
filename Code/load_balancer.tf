resource "azurerm_lb" "vmss-lb" {
  name                = "vmss-lb"
  location            = azurerm_resource_group.RG-UK-South.location
  resource_group_name = azurerm_resource_group.RG-UK-South.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "vmss-lb-frontendip"
    public_ip_address_id = azurerm_public_ip.publiciplb.id
  }
}

resource "azurerm_lb_backend_address_pool" "vmss-lb-bap" {
  loadbalancer_id = azurerm_lb.vmss-lb.id
  name            = "vmss-lb-bap"
}

resource "azurerm_lb_rule" "vmss-lb-rule" {
  loadbalancer_id                = azurerm_lb.vmss-lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "vmss-lb-frontendip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.vmss-lb-bap.id]
}
