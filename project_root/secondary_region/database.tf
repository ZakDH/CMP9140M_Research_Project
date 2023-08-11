resource "azurerm_mssql_server" "secondary-web-tier-server01" {
  name                = "secondary-web-tier-server01"
  location            = data.azurerm_resource_group.secondary_rg.location
  resource_group_name = data.azurerm_resource_group.secondary_rg.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "12.0"
}

resource "azurerm_mssql_database" "secondary-web-tier-db01" {
  name      = "secondary-web-tier-db01"
  server_id = azurerm_mssql_server.secondary-web-tier-server01.id
}

resource "azurerm_mssql_server" "secondary-business-tier-server01" {
  name                = "secondary-business-tier-server01"
  location            = data.azurerm_resource_group.secondary_rg.location
  resource_group_name = data.azurerm_resource_group.secondary_rg.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "12.0"
}

resource "azurerm_mssql_database" "secondary-business-tier-db01" {
  name      = "secondary-business-tier-db01"
  server_id = azurerm_mssql_server.secondary-business-tier-server01.id
}