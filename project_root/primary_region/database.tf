resource "azurerm_mssql_server" "primary-web-tier-server01" {
  name                = "primary-web-tier-server01"
  location            = data.azurerm_resource_group.primary_rg.location
  resource_group_name = data.azurerm_resource_group.primary_rg.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "12.0"
}

resource "azurerm_mssql_database" "primary-web-tier-db01" {
  name      = "primary-web-tier-db01"
  server_id = azurerm_mssql_server.primary-web-tier-server01.id
}

resource "azurerm_mssql_server" "primary-business-tier-server01" {
  name                = "primary-business-tier-server01"
  location            = data.azurerm_resource_group.primary_rg.location
  resource_group_name = data.azurerm_resource_group.primary_rg.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "12.0"
}

resource "azurerm_mssql_database" "primary-business-tier-db01" {
  name      = "primary-business-tier-db01"
  server_id = azurerm_mssql_server.primary-business-tier-server01.id
}