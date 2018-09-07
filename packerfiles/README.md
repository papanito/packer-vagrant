# Introduction

For Linux boxes there is a .json file per OS version (e.g. Ubuntu 17.04 and Ubuntu 16.10).
For Windows boxes there are always at least 3 .json files - base, updates and package - per OS version (e.g. Windows 10, Windows 2016, ...) - this is inspired by  [https://hodgkins.io/best-practices-with-packer-and-windows](https://hodgkins.io/best-practices-with-packer-and-windows). 

For different variations of a system (e.g. Ubuntu Desktop 32-bit or 64-bit, Ubuntu Server, Windows 10 Enterprise 2016 LTSB, Windows 10 Enterprise 2016 N LTSB, ...) I have a separate config file with specific parameters like ISO name and Checksum. So a creation of a base image is called with appropriate -var-file. Example:

```bash
packer build -var-file=iso/windows_10_enterprise_2016_ltsb_en_n_x64.cfg windows_10.json
packer build -var-file=iso/ubuntu_16.10_x64_server.cfg ubuntu_16.10.json
```

In additon certain variables defined in the packer files are set to null and therefore should be specified when calling ```packer build```. Mainly this are user credentials and mirrors for e.g. iso files - I keep them on an internal sever which is faster for download than over internet. There is an example config file which I usually copy and modify to my needs.

```bash
packer build -var-file=iso/windows_10_enterprise_2016_ltsb_en_n_x64.cfg -var-file=myconfig.cfg windows_10.json
packer build -var-file=iso/ubuntu_16.10_x64_server.cfg -var-file=myconfig.cfg ubuntu_16.10.json
```

**Remark:** All packer, answer and script files contain ant-like tokens for username and passwords. If you want to manually create the vms as mentioned above, please replace the respective tokens with the desired values. Otherwise, use the gradle script ```build.gradle``` as described [here](https://github.com/papanito/packer-vagrant/tree/master)

## Remarks for Linux

### boot_command

The boot_command is essential to initiate the unattended installation. For Linux systems one has to modify the boot parameters and specify a pre-seed file either by an url or a file location. If taken from a file, is shall be mounted in the vm for example via the floppy

```yaml
"floppy_dirs": [
    "../unattended",
    "../scripts"
], 
```

And then used in the boot command as follows

```yaml
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

### shutdown_command
As for any sudo command, it expects a password to be provided unless it is configured passwordless. If not you might have packer stuck at "Gracefully halting virtual machine" and then will timeout (see https://github.com/hashicorp/packer/issues/4813). So my shutdown_command looks like this:

```shutdown_command": "echo '{{user `pwd`}}' | {{user `shutdown_command`}}"```

## Remarks for Windows

TBD

# Scripts

Scripts for provisioning machines with packer, more details at https://github.com/papanito/packer-vagrant/blob/master/packerfiles/scripts/README.md

# Common Errors and Troubleshooting

## ==> virtualbox-iso: Waiting for WinRM to become available...

This may have various reasons but most probably the username and/or password for the user defined in the packer files does not match the one in the answer file.
Usually for packer you would pass the password and username by variables as suggested [here](https://www.packer.io/docs/templates/user-variables.html) but you also have the username and password hard-coded in the unattended files.