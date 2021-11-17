terraform {
  required_version = ">= 1.0.1"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.11"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# provider "libvirt" {
#   uri = "qemu+ssh://deploys@ams-kvm-remote-host/system"
# }
