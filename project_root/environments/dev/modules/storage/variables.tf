variable "storage_name_prefix" {
  description = "Prefix for storage names"
  type        = string
  default     = "primary"
}

variable "location" {
  description = "The location of the storage resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "destination_storage_account_id" {
  description = "ID of the destination storage account for replication"
  type        = string
}

variable "destination_container_name" {
  description = "Name of the destination storage container for replication"
  type        = string
}