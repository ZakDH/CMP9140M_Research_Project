# Configuration for load balancer
resource "azurerm_lb" "primary-vmss-lb" {
  name                = "vmss-lb"
  location            = data.azurerm_resource_group.primary_rg.location
  resource_group_name = data.azurerm_resource_group.primary_rg.name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                 = "vmss-lb-frontend"
    public_ip_address_id = azurerm_public_ip.primary-web-ip.id
  }
}

# Configuration for backend address pool
resource "azurerm_lb_backend_address_pool" "primary-vmss-lb-bap" {
  loadbalancer_id = azurerm_lb.primary-vmss-lb.id
  name            = "vmss-lb-bap"
}

# Configuration for load balancing probe
resource "azurerm_lb_probe" "primary-lb-probe" {
  for_each        = var.public-applications
  loadbalancer_id = azurerm_lb.primary-vmss-lb.id
  name            = "healthProbe-${each.key}"
  protocol        = each.value.protocol
  port            = each.value.backendPort
}

# Configuration for scale set load balancer rule
resource "azurerm_lb_rule" "vmss-lb-rule" {
  for_each                       = var.public-applications
  loadbalancer_id                = azurerm_lb.primary-vmss-lb.id
  name                           = "loadBalancingRule-${each.key}"
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontendPort
  backend_port                   = each.value.backendPort
  frontend_ip_configuration_name = "vmss-lb-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.primary-vmss-lb-bap.id]
  probe_id                       = azurerm_lb_probe.primary-lb-probe[each.key].id
}