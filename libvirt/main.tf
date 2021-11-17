
################################
### KVM Virtual Machine ########
################################


### libvirt pool 

resource "libvirt_pool" "ubuntu" {
  name = "ubuntu"
  type = "dir"
  path = var.libvirt_disk_path
}

### libvirt volume  

# argument reference, see: https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/website/docs/r/volume.html.markdown#argument-reference
resource "libvirt_volume" "ubuntu-qcow2" {
  name = "os_image.${var.vm_hostname}"
  pool = "${libvirt_pool.ubuntu.name}"
  #source = var.ubuntu_18_img_url
  source = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
  format = "qcow2"
  #size = 10*1024*1024*1024
}

### libvirt cloudinit disk  

# argument reference, see: https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/website/docs/r/cloudinit.html.markdown#argument-reference
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = libvirt_pool.ubuntu.name
}
data "template_file" "user_data" {
  template = file("${path.module}/userdata.yaml")
}


### Create the machine

# libvirt_domain, argument reference, see https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/website/docs/r/domain.html.markdown#argument-reference

resource "libvirt_domain" "db1" {
  name   = var.vm_hostname
  memory = "1024"
  vcpu   = 1

  network_interface {
    network_name = "default"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = "${libvirt_volume.ubuntu-qcow2.id}"
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}



