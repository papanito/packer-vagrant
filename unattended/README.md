# Introduction to Unattendend Installation
More infos on how to create unattended installation for Windows and Linux can be found on my blog:
https://wyssmann.com/unattended/

# Linux
Files follow simple naming convention:
```<distro>_<version>_<locale>_<additional info>_cfg```

# Windows
There are two ways to map the unattended files on floppy:
```
"floppy_dirs": [
    "unattended/windows/10/*"
]
```
Keep attention to use the wildcard * otherwise unattended installation will not kick in. Alternatively you can map the files individually
```
"floppy_files": [
    "unattended/windows/10/Autounattend.xml",
    "unattended/windows/10/Unattend.xml"
]
```

For detailed information about the windows answer files check out related README.md file.
