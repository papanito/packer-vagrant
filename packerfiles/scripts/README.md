# Packer script files
These script files are used by packer to create the vms. The scripts are usually provided via the ```floppy_files``` instruction in the packer file as follows - the can be explicitly specified or via wildcard *

```"floppy_files": [
   "../scripts/*"
],

Some of the windows scripts are provided from others, I will add references in the files directly to reflect that.
## Window
Windows scripts are essentially Powershell-Scripts ending with .ps1, but for convenience, I prefixed them with `windows-`. These files are called by the Packer-Provisioner in one of the stages (base, updates or package). 
`bootstrap.ps1` is an exception as it is called by the unattended process. It's intention is to setup WinRM so that it is usable.
## Linux
Linux scripts are Bash-Scripts ending with .sh. There are generic scripts like sshconfig.sh and distro-specific files.