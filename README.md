# Example templates for Vagrant and Packer

## Intro

There are already some existing GitHub projects providing templates to create machines with Packer. However I created this project for learning purposes . In addition to the packer documentation I also took some inspiration from these great projects:

* [kaorimatz: packer-templates](https://github.com/kaorimatz/packer-templates)
* [mwrock: packer-templates](https://github.com/mwrock/packer-templates)
* [MattHodge: PackerTemplates](https://github.com/MattHodge/PackerTemplates)
* [jacqinthebox: packer-templates](https://github.com/jacqinthebox/packer-templates)
* [chef-bento: packer-templates](https://github.com/chef/bento/tree/master/packer_templates)

## Structure

* [images](./images) - images for better illustration in the README.txt
* [packerfiles](./packerfiles) - hcl (variables) for packera
  * [iso](./packerfiles/iso) - os specific variables like iso name and checksum
  * [scripts](./packerfiles/scripts) - scripts for provisioning machines with packer
* [scripts](./scripts) - script to be used for provisioning
* [unattended](./unattended) - preseed files for Linux and Autounattend files for Windows
  * [windows](./unattended/windows) - autounattended files for Windows
    * 10-ent-n-2016-LTSB - Windows 10 Enterprise Edition N2016 LTSB
    * ...
  * [linux](./unattended/linux) - answer files for Linux
    * Ubuntu - Ubuntu specific files
    * ...
* [vagrantfiles](./vagrantfiles)
  * @os version@ - 

Additional information can be found in the related subfolders

## Build

In order to build VMs with packer you can use the gradle script `build.gradle` as follows

1. Add a `gradle.properties` file and define the following values. The values represent tokens which will be replaced in respective answer and packer files

   * `username=@username for user account to be created@`
   * `password=@password for user account 'username'@`
   * `rootpassword=@password for root/Administrator account@`

2. Define additional parameters

   * `builders=@packer builders to execute e.g. virtualbox-iso@`

3. Build machines by calling either `gradle buildLinux -PconfigFile=xxx` or `gradle buildWindows -PconfigFile=xxx`. You have to submit a config file (name form `packerfiles/iso` folder) which defines which distro / windows version to build

   `gradle clean buildWindows -PconfigFile=windows_server_2016_standard_x64.hcl`

**Remark: Some characters may break the scripts e.g. using `$` will break `windows-base.ps1`**
