variable "number" {
    type                   = number
}
variable "hostname" {
    type                   = string
}

variable "subnet_id" {
    type                   = string
}

variable "network_security_group_id" {
    type                   = string
}

variable "location" {
    type                   = string
}

variable "intance_type" {
    type                   = string
}

variable "OS_disk" {
    type                   = number
    default = 32
    description = "Disk size of OS Disk"
}


variable "data_disks" {
  type = map(object({
    storage_account_type = string
    disk_size_gb         = number
    caching              = string
    lun                  = number
  }))
  default = {}
  description = "list of data disks"
}