variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/var/lib/libvirt/images/tf-examples"
}

variable "ubuntu_18_img_url" {
  description = "ubuntu 18.04 image"
  default     = "/home/lmarkov/OS_iso/ubuntu-20.04.3-desktop-amd64.iso"
}

variable "vm_hostname" {
  type    = string
  description = "vm hostname"
  default = "dev1.kras"
}

variable "memory" { 
  default = 1024*2 
}

variable "cpu" { 
  default = 2 
}

variable "ssh_username" {
  description = "the ssh user to use"
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "the private key to use"
  default     = "~/.ssh/id_rsa"
}