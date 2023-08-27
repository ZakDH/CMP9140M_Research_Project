# Configures the web tier SQL server along with login credentials
resource "azurerm_mssql_server" "web-tier-server" {
  name                = "${var.database_name_prefix}-web-tier-server01"
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "12.0"
}

# Configures the business tier SQL server along with login credentials
resource "azurerm_mssql_server" "business-tier-server" {
  name                = "${var.database_name_prefix}-business-tier-server01"
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "12.0"
}

#Configures the web tier SQL database
resource "azurerm_mssql_database" "web-tier-db" {
  name      = "${var.database_name_prefix}-web-tier-db01"
  server_id = azurerm_mssql_server.web-tier-server.id
}

# Configures the business tier SQL database
resource "azurerm_mssql_database" "business-tier-db" {
  name      = "${var.database_name_prefix}-business-tier-db01"
  server_id = azurerm_mssql_server.business-tier-server.id
}
