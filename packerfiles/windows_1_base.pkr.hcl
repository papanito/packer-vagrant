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
  type    = string
  default = "ins3CURE"
  sensitive = true
}

variable "iso_mirror" {
  type    = string
  default = "/home/papanito/Downloads/iso/"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "keep_artifacts" {
  type    = string
  default = "false"
}

variable "iso_name" {
  type    = string
}

variable "iso_checksum" {
  type    = string
}

variable "license_key" {
  type    = string
}

variable "guest_os_type" {
  type    = string
}

variable "winversion" {
  type    = string
}

variable "output" {
  type    = string
}

source "qemu" "windows" {
  accelerator          = "kvm"
  communicator         = "winrm"
  disk_size            = "102400"
  floppy_files         = ["./unattended/windows/${var.winversion}/*", "./unattended/windows/unattend.xml", "./packerfiles/scripts/*"]
  format               = "qcow2"
  headless             = "${var.headless}"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_mirror}//${var.iso_name}"
  output_directory     = "./output/win${var.winversion}-base/"
  shutdown_command     = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout     = "15m"
  vm_name              = "win${var.winversion}-base"
  winrm_password       = "${var.pwd}"
  winrm_timeout        = "8h"
  winrm_username       = "${var.user}"
}

source "virtualbox-iso" "windows" {
  communicator         = "winrm"
  disk_size            = "102400"
  floppy_files         = ["./unattended/windows/${var.winversion}/*", "./unattended/windows/unattend.xml", "./packerfiles/scripts/*"]
  guest_additions_mode = "disable"
  guest_os_type        = "${var.guest_os_type}"
  headless             = "${var.headless}"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_mirror}/${var.iso_name}"
  output_directory     = "./output/win${var.winversion}-base/"
  shutdown_command     = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout     = "15m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--natpf1", "guest_winrm,tcp,,55985,,5985"], ["modifyvm", "{{ .Name }}", "--memory", "2048"], ["modifyvm", "{{ .Name }}", "--vram", "128"], ["modifyvm", "{{ .Name }}", "--cpus", "1"]]
  vm_name              = "win${var.winversion}-base"
  winrm_password       = "${var.pwd}"
  winrm_timeout        = "8h"
  winrm_username       = "${var.user}"
}

build {
  sources = ["source.qemu.windows"]

  provisioner "powershell" {
    elevated_password = "${var.pwd}"
    elevated_user     = "${var.user}"
    script            = "./packerfiles/scripts/windows-base.ps1"
  }

}
