# resource "azurerm_network_security_group" "project-sg" {
#   name                = "project-sg"
#   location            = azurerm_resource_group.RG-UK-South.location
#   resource_group_name = azurerm_resource_group.RG-UK-South.name
#   security_rule {
#     name                       = "AllowHTTP"
#     description                = "Allow HTTP"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "Internet"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "AllowHTTPS"
#     description                = "Allow HTTPS"
#     priority                   = 101
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "Internet"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "AllowRDP"
#     description                = "Allow RDP"
#     priority                   = 150
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "Internet"
#     destination_address_prefix = "*"
#   }
#   tags = {
#     environment = "dev"
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "sga" {
#   for_each                  = var.subnet_map
#   subnet_id                 = azurerm_subnet.subnet[each.key].id
#   network_security_group_id = azurerm_network_security_group.project-sg.id
# }