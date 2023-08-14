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
    "secondary-business-subnet-1" = {
      name             = "secondary-business-subnet-1"
      address_prefixes = ["10.0.1.32/27"]
    }
    "secondary-business-subnet-2" = {
      name             = "secondary-business-subnet-2"
      address_prefixes = ["10.0.1.64/27"]
    }
    "secondary-business-subnet-3" = {
      name             = "secondary-business-subnet-3"
      address_prefixes = ["10.0.1.96/27"]
    }
  }
}

variable "ip_map" {
  type = map(object({
    name  = string
    zones = list(string)
  }))
  default = {
    "business-ip-1" = {
      name  = "business-ip-1"
      zones = ["1"]
    }
    "business-ip-2" = {
      name  = "business-ip-2"
      zones = ["2"]
    }
    "business-ip-3" = {
      name  = "business-ip-3"
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
      ipconfig = "business-ip-1"
      subnet   = "secondary-business-subnet-1"
    }
    "nic-2" = {
      name     = "nic-2"
      ipconfig = "business-ip-2"
      subnet   = "secondary-business-subnet-2"
    }
    "nic-3" = {
      name     = "nic-3"
      ipconfig = "business-ip-3"
      subnet   = "secondary-business-subnet-3"
    }
  }
}

variable "vm_map" {
  type = map(object({
    name = string
    zone = string
    nic  = string
  }))
  default = {
    "business-vm-1" = {
      name = "business-vm-1"
      zone = "1"
      nic  = "nic-1"
    }
    "business-vm-2" = {
      name = "business-vm-2"
      zone = "2"
      nic  = "nic-2"
    }
    "business-vm-3" = {
      name = "business-vm-3"
      zone = "3"
      nic  = "nic-3"
    }
  }
}

variable "vme_map" {
  type = map(object({
    name = string
    vm   = string
  }))
  default = {
    "business-vm-server-1" = {
      name = "business-vm-server-1"
      vm   = "business-vm-1"
    }
    "business-vm-server-2" = {
      name = "business-vm-server-2"
      vm   = "business-vm-2"
    }
    "business-vm-server-3" = {
      name = "business-vm-server-3"
      vm   = "business-vm-3"
    }
  }
}

variable "public-applications" {
  default = {
    "http" = {
      frontendPort = "80",
      backendPort  = "80",
      protocol     = "Tcp",
    },
    "https" = {
      frontendPort = "443",
      backendPort  = "443",
      protocol     = "Tcp",
    },
    # "breaks" = {
    #   frontendPort = "445",
    #   backendPort  = "445",
    #   protocol     = "Tcp",
    # },
  }
}