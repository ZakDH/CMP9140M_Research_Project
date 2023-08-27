# Configures the database name prefix to accomodate the unique name requirements
variable "database_name_prefix" {
  description = "Prefix for database names"
  type        = string
  default     = "primary"
}
# Configures the location variable for the resource group
variable "location" {
  description = "The location of the resource group"
  type        = string
}
# Configures the resource group name
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}