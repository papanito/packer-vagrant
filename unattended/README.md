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
    "unattended/windows/server-2016-std/*"
]
```
Keep attention to use the wildcard * otherwise unattended installation will not kick in. Alternatively you can map the files individually
```
"floppy_files": [
    "unattended/windows/server-2016-std/Autounattend.xml",
    "unattended/windows/unattend.xml"
]
```

For detailed information about the windows answer files check out related README.md file.