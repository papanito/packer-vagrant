Example templates for Vagrant and Packer.
# Intro
There are already some existing GitHub projects providing templates to create machines with Packer. However I created this project for learning purposes . In addition to the packer documentation I also took some inspiration from these great projects:
* https://github.com/kaorimatz/packer-templates
* https://github.com/mwrock/packer-templates
* https://github.com/MattHodge/PackerTemplates
* https://github.com/jacqinthebox/packer-templates

# Structure
```
+ images         - images for better illustration in the README.txt
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

Checkout subfolders for additional information