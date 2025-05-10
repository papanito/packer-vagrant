packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
    # Declaring the vagrant plugin
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.1.1"
    }
    # Declaring the virtualbox plugin
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = ">= 1.0.0"
    }
  }
}

variable "user" {
  type    = string
  default = "packer"
}

variable "pwd" {
  type      = string
  default   = "ins3CURE"
  sensitive = true
}

variable "iso_mirror" {
  type = string
}

variable "iso_name" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "headless" {
  type    = string
  default = "true"
}

variable "keep_artifacts" {
  type    = string
  default = "true"
}

variable "preseed_name" {
  type    = string
  default = "linux_de-ch_dhcp.cfg"
}

variable "shutdown_command" {
  type    = string
  default = "sudo -S shutdown -P now"
}

variable "ssh_timeout" {
  type    = string
  default = "2000s"
}

source "qemu" "linux" {
  accelerator = "kvm"
  boot_command = [
    " <wait>",
    " <wait>",
    " <wait>",
    " <wait>",
    " <wait>",
    "c",
    "<wait>",
    "set gfxpayload=keep",
    "<enter><wait>",
    "linux /casper/vmlinuz quiet<wait>",
    " autoinstall<wait>",
    " ---",
    "<enter><wait>",
    "initrd /casper/initrd",
    " preseed/file=/floppy/unattended/linux/${var.preseed_name}",
    "<enter><wait>",
  ]
  boot_wait      = "5s"
  disk_interface = "virtio"
  floppy_dirs = [
    "./unattended/linux",
    "./packerfiles/scripts"
  ]
  format           = "qcow2"
  headless         = "${var.headless}"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_mirror}${var.iso_name}"
  net_device       = "virtio-net"
  shutdown_command = "echo '${var.pwd}' | ${var.shutdown_command}"
  shutdown_timeout = "1m"
  ssh_password     = "${var.pwd}"
  ssh_pty          = "true"
  ssh_timeout      = "${var.ssh_timeout}"
  ssh_username     = "${var.user}"
}

source "virtualbox-iso" "linux" {
  boot_command = [
    " <wait>",
    " <wait>",
    " <wait>",
    " <wait>",
    " <wait>",
    "c",
    "<wait>",
    "set gfxpayload=keep",
    "<enter><wait>",
    "linux /casper/vmlinuz quiet<wait>",
    " autoinstall<wait>",
    " ---",
    "<enter><wait>",
    "initrd /casper/initrd<wait>",
    " preseed/file=/floppy/unattended/linux/${var.preseed_name}",
    "<enter><wait>",
    "boot<enter><wait>"
  ]
  boot_wait = "5s"
  floppy_dirs = [
    "./unattended/",
    "./packerfiles/scripts"
  ]
  guest_os_type    = "Ubuntu_64"
  headless         = "${var.headless}"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_mirror}${var.iso_name}"
  shutdown_command = "echo '${var.pwd}' | ${var.shutdown_command}"
  ssh_password     = "${var.pwd}"
  ssh_pty          = "true"
  ssh_timeout      = "${var.ssh_timeout}"
  ssh_username     = "${var.user}"
  vboxmanage       = [["modifyvm", "{{ .Name }}", "--natdnshostresolver1", "on"]]
  vm_name          = "${var.iso_name}"
}

build {
  sources = ["source.qemu.linux"]

  provisioner "shell" {
    scripts = ["packerfiles/scripts/ubuntu.sh"]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "./boxes/${var.iso_name}/${var.iso_name}.box"
  }
}
