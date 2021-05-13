
source "virtualbox-ovf" "autogenerated_1" {
  communicator         = "winrm"
  floppy_files         = ["./packerfiles/scripts"]
  guest_additions_mode = "attach"
  headless             = true
  output_directory     = "./output/win${var.winversion}-package/"
  shutdown_command     = "C:/Scripts/sysprep.cmd"
  shutdown_timeout     = "1h"
  source_path          = "./output/win${var.winversion}-updates/win${var.winversion}-updates.ovf"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "2048"], ["modifyvm", "{{ .Name }}", "--vram", "128"], ["modifyvm", "{{ .Name }}", "--cpus", "1"]]
  vm_name              = "win${var.winversion}-package"
  winrm_password       = "${var.pwd}"
  winrm_timeout        = "12h"
  winrm_username       = "${var.user}"
}

build {
  sources = ["source.virtualbox-ovf.autogenerated_1"]

  provisioner "powershell" {
    elevated_password = "${var.pwd}"
    elevated_user     = "${var.user}"
    script            = "./packerfiles/scripts/windows-tools_and_stuff.ps1"
  }

  provisioner "powershell" {
    elevated_password = "${var.pwd}"
    elevated_user     = "${var.user}"
    script            = "./packerfiles/scripts/import-certificate.ps1"
  }

  provisioner "powershell" {
    elevated_password = "${var.pwd}"
    elevated_user     = "${var.user}"
    script            = "./packerfiles/scripts/windows-configurewinrm.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "1h"
  }

  provisioner "powershell" {
    elevated_password = "${var.pwd}"
    elevated_user     = "${var.user}"
    script            = "./packerfiles/scripts/windows-compress.ps1"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "${var.output}.box"
  }
}
