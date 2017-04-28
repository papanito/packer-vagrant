Example templates for Vagrant and Packer.
# Intro
There are already some existing GitHub projects providing templates to create machines with Packer



# Structure
```
+ packerfiles    - json and cfg (variables) for packera
| + iso          - os specific variables like iso name and checksum
| + scripts      - scripts for provisioning machines with packer
+ scripts        - script to be used for provisioning
+ unattended     - preseed files for Linux and Autounattend files for Windows
| + windows      - autounattended files for Windows
|   + 10         - Windows 10
|   + ...
+ vagrantfiles 
  + <os version> - 
```

## packerfiles
I have .json file per OS version (e.g. Ubuntu 16.04 and Ubuntu 16.10). For different variations of a system (e.g. Ubuntu Desktop 32-bit or 64-bit, Ubuntu Server, Windows 10 Enterprise 2016 LTSB, Windows 10 Enterprise 2016 N LTSB, ...) I have a separate config file with specific parameters like ISO name and Checksum. So a creation of a base image is called with appropriate -var-file. Example:
```
packer build -var-file=iso/windows_10_enterprise_2016_ltsb_en_n_x64.cfg windows_10.json
packer build -var-file=iso/ubuntu_16.10_x64_server.cfg ubuntu_16.10.json
```

In additon certain variables defined in the packer files are set to null and therefore should be specified when calling ```packer build```. Mainly this are user credentials and mirrors for e.g. iso files - I keep them on an internal sever which is fatster for download than over internet. There is an example config file which I usually copy and modify to my needs.
```
packer build -var-file=iso/windows_10_enterprise_2016_ltsb_en_n_x64.cfg -var-file=myconfig.cfg windows_10.json
packer build -var-file=iso/ubuntu_16.10_x64_server.cfg -var-file=myconfig.cfg ubuntu_16.10.json
```

### Remarks for Linux
#### boot_command
The boot_command is essential to initiate the unattended installation. For Linux systems one has to modify the boot parameters and specify a pre-seed file either by an url or a file location. If taken from a file, is shall be mounted in the vm for example via the floppy
```
"floppy_dirs": [
    "../unattended",
    "../scripts"
], 
```
And then used in the boot command as follows
```
"boot_command": [
    "<esc><wait>",
    "<esc><wait>",
    "<enter><wait>",
    "/install/vmlinuz initrd=/install/initrd.gz ",
    "auto-install/enable=true ",
    "debconf/priority=critical ",
    "preseed/file=/floppy/unattended/{{user `preseed_name`}} ",
    "<enter>"
],
```
Alternatively one can specify an url as follows (replacing "preseed/file"):
```preseed/url=http://artifact-repo/{{user `preseed_name`}}```

The url can contain a host name or an ip but in case you use an IP you may enabled natdnshostresolver1 on virtualbox:
```["modifyvm", "{{.Name}}", "--natdnshostresolver1", "on"]```
#### shutdown_command
As for any sudo command, it expects a password to be provided unless it is configured passwordless. If not you might have packer stuck at "Gracefully halting virtual machine" and then will timeout (see https://github.com/hashicorp/packer/issues/4813). So my shutdown_command looks like this:
```shutdown_command": "echo '{{user `pwd`}}' | {{user `shutdown_command`}}"```

### Remarks for Windows
TBD

## scripts
Scripts for provisioning machines with packer

## unattended
More infos on how to create unattended installation for Windows and Linux can be found on my blog:
https://wyssmann.com/unattended/

### Linux
Files follow simple naming convention:
```<distor>_<version>_<locale>_<additional info>_cfg```

### Windows
As windows relies on a fixed name "Autounattended.xml", they are divided in sub folders (1 per Windows version).

Product keys for Windows eventually need to be updated. I currently use the ones mentioned here:
http://technet.microsoft.com/en-us/library/jj612867.aspx

## vagrantfiles
TBD