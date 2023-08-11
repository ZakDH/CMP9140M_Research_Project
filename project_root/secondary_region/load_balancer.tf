resource "azurerm_lb" "secondary-vmss-lb" {
  name                = "vmss-lb"
  location            = data.azurerm_resource_group.secondary_rg.location
  resource_group_name = data.azurerm_resource_group.secondary_rg.name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                 = "vmss-lb-frontend"
    public_ip_address_id = azurerm_public_ip.secondary-web-ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "secondary-vmss-lb-bap" {
  loadbalancer_id = azurerm_lb.secondary-vmss-lb.id
  name            = "vmss-lb-bap"
}

resource "azurerm_lb_probe" "secondary-lb-probe" {
  for_each        = var.public-applications
  loadbalancer_id = azurerm_lb.secondary-vmss-lb.id
  name            = "healthProbe-${each.key}"
  protocol        = each.value.protocol
  port            = each.value.backendPort
}

resource "azurerm_lb_rule" "vmss-lb-rule" {
  for_each                       = var.public-applications
  loadbalancer_id                = azurerm_lb.secondary-vmss-lb.id
  name                           = "loadBalancingRule-${each.key}"
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontendPort
  backend_port                   = each.value.backendPort
  frontend_ip_configuration_name = "vmss-lb-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.secondary-vmss-lb-bap.id]
  probe_id                       = azurerm_lb_probe.secondary-lb-probe[each.key].id
}