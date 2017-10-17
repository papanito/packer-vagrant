# Common Errors and Troubleshooting
## ==> virtualbox-iso: Waiting for WinRM to become available...
This may have various reasons but most probably the username and/or password for the user defined in the packer files does not match the one in the answer file.
Usually for packer you would pass the password and username by variables as suggested [here](https://www.packer.io/docs/templates/user-variables.html) but you also have the username and password hard-coded in the unattended files.