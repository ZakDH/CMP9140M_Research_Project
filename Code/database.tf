resource "azurerm_mssql_server" "web-tier-server01" {
  name                = "web-tier-server01"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "12.0"
}

resource "azurerm_mssql_database" "web-tier-db01" {
  name      = "web-tier-db01"
  server_id = azurerm_mssql_server.web-tier-server01.id
}

resource "azurerm_mssql_server" "business-tier-server01" {
  name                = "business-tier-server01"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "12.0"
}

resource "azurerm_mssql_database" "business-tier-db01" {
  name      = "business-tier-db01"
  server_id = azurerm_mssql_server.business-tier-server01.id
}