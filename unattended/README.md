## Introduction to Unattendend Installation

More infos on how to create unattended installation for Windows and Linux can be found on my [blog](https://wyssmann.com/blog/2017/04/unattended-installation-of-linux-and-windows/)

### Linux

Files follow simple naming convention:

```
<distro>_<version>_<locale>>_x64|x32_<additional info>.pkrvars.hcl
```

### Windows

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