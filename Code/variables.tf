variable "heading_one" {
  default = "Hi i am a virtual machine."
  type    = string
}

variable "subnet_map" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = {
    "subnet-1" = {
      name             = "subnet-1"
      address_prefixes = ["10.0.0.0/27"]
    }
    "subnet-2" = {
      name             = "subnet-2"
      address_prefixes = ["10.0.0.32/27"]
    }
    "subnet-3" = {
      name             = "subnet-3"
      address_prefixes = ["10.0.0.64/27"]
    }
  }
}

variable "ip_map" {
  type = map(object({
    name  = string
    zones = list(string)
  }))
  default = {
    "publicip-1" = {
      name  = "publicip-1"
      zones = ["1"]
    }
    "publicip-2" = {
      name  = "publicip-2"
      zones = ["2"]
    }
    "publicip-3" = {
      name  = "publicip-3"
      zones = ["3"]
    }
  }
}

variable "nic_map" {
  type = map(object({
    name     = string
    ipconfig = string
    subnet   = string
  }))
  default = {
    "nic-1" = {
      name     = "nic-1"
      ipconfig = "ipconfig-1"
      subnet   = "subnet-1"
    }
    "nic-2" = {
      name     = "nic-2"
      ipconfig = "ipconfig-2"
      subnet   = "subnet-2"
    }
    "nic-3" = {
      name     = "nic-3"
      ipconfig = "ipconfig-3"
      subnet   = "subnet-3"
    }
  }
}

variable "vm_map" {
  type = map(object({
    name = string
    zone = string
    nic = string
  }))
  default = {
    "business-vm-1" = {
      name = "business-vm-1"
      zone = "1"
      nic = "nic-1"
    }
    "business-vm-2" = {
      name = "business-vm-2"
      zone = "2"
      nic = "nic-2"
    }
    "business-vm-3" = {
      name = "business-vm-3"
      zone = "3"
      nic = "nic-3"
    }
  }
}

variable "vmss_map" {
  type = map(object({
    name     = string
    zone     = list(string)
    nic      = string
    ipconfig = string
    subnet   = string
  }))
  default = {
    "web-vmss-1" = {
      name     = "web-vmss-1"
      zone     = ["1"]
      nic      = "nic-01"
      ipconfig = "ipconfig-1"
      subnet   = "subnet-1"
    }
    "web-vmss-2" = {
      name     = "web-vmss-2"
      zone     = ["2"]
      nic      = "nic-02"
      ipconfig = "ipconfig-2"
      subnet   = "subnet-2"
    }
    "web-vmss-3" = {
      name     = "web-vmss-3"
      zone     = ["3"]
      nic      = "nic-03"
      ipconfig = "ipconfig-3"
      subnet   = "subnet-3"
    }
  }
}