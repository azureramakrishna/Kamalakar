variable "resource_group_name" {
  type        = string
  description = "Name of the resourcegroup"
}

variable "location" {
  type        = string
  description = "Name of the location"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "virtual_address_space" {
  type        = list(string)
  description = "address_space of the virtual network"
  default = [ "10.0.0.0/16" ]
}

variable "subnets" {
  type        = map(any)
  description = "number of subnets"
  default     = {
    subnet_1 = {
      name = "subnet1"
      address_prefixes = ["10.0.0.0/24"]
    }
    subnet_2 = {
      name = "subnet2"
      address_prefixes = ["10.0.1.0/24"]
    }
    subnet_3 = {
      name = "subnet3"
      address_prefixes = ["10.0.2.0/24"]
    }
  }
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the network security group"
}

variable "network_interface_name" {
  type        = string
  description = "Name of the network interface"
}

variable "count_value" {
  type        = number
  description = "number of resources"
  default = 3
}

variable "virtual_machine_name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "virtual_machine_size" {
  type        = string
  description = "size of the virtual machine"
}

variable "adminUser" {
  type        = string
  description = "Name of the virtual machine"
}

variable "adminPassword" {
  type        = string
  description = "Name of the virtual machine"
}




