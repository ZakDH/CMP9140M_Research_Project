variable "resource_group_name" {
  description = "Name of the Azure resource group"
  default     = "project-resources"
}

variable "location" {
  description = "Location for Azure resources"
  default     = "UK South"
}

variable "vm_name" {
  description = "Virtual Machine Name"
  default     = "project-vm-"
}

variable "instance_count" {
  description = "Number of Session Host VMs to create"
  default     = "3"
}
variable "vm_zones" {
  type        = list(any)
  description = "Number of zones"
  default     = ["1", "2", "3"]
}

variable "subnets" {
  type = map(list(string))
  default = {
    "subnet-1" = ["10.0.0.0/27"],
    "subnet-2" = ["10.0.0.32/27"],
    "subnet-3" = ["10.0.0.64/27"]
  }
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}