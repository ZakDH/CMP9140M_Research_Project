variable "database_name_prefix" {
  description = "Prefix for database names"
  type        = string
  default     = "primary"
}
variable "location" {
  description = "The location of the resource group"
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}