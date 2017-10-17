# General
For general information checkout https://github.com/papanito/packer-vagrant

# Answer file generation
Due to the  complex structure of answer files you shall use tools for that, the Windows System Image Manager (Windows SIM) – which is part of the [https://developer.microsoft.com/en-us/windows/hardware/windows-assessment-deployment-kit](Windows Assessment and Deployment Kit).

Keys in WIM (source: http://www.msfn.org/board/topic/88048-amd64-wow64-x86-in-the-wsim/)
* amd_64 - 64bit components, only used on x64 installs
* wow_64 - 32bit components or support components for 32bit compat installed on x64, only used on x64 installs
* x86 - 32bit components installed on x86, only used on x86 installs

As windows relies on a fixed name "Unattend.xml" or "Autounattended.xml" respectively, they are divided in sub folders (1 per Windows version). You may wonder why you may need two files, I recommend read trough https://technet.microsoft.com/en-us/library/cc749415(v=ws.10).aspx
> As a rule, only answer files named Unattend.xml are used. However, because some answer files include destructive actions such as disk partitioning, you must rename your Unattend.xml file to Autounattend.xml in the windowsPE and offlineServicing configuration passes. These passes run when you first run Windows PE or Setup.exe. You typically use the Autounattend.xml file when you use the Windows Setup DVD boot method and supply an answer file on a USB flash drive (UFD) or floppy disk.

More info to language locales:
https://msdn.microsoft.com/en-us/library/dd318693(v=vs.85).aspx

More info to timezone identifiers:
https://msdn.microsoft.com/en-us/library/ms912391%28v=winembedded.11%29.aspx?f=255&MSPPError=-2147217396

# Passes
The file is divided in different sections called “Configuration passes” and are used to specify different phases of the Windows Setup. More info to this can be found at MSDN:
* https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/how-configuration-passes-work
* https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/automate-windows-setup

![alt text](https://i-msdn.sec.s-msft.com/en-us/windows/hardware/commercialize/manufacture/desktop/images/dep-win8-l-configpassesandexes.jpg "configuration passes")

## windowsPE
https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/windowspe

This pass is triggered when booting the Windows Setup media (.iso) . As we don't use a [https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/winpe-intro](Windows PE) we do not need Windows PE options but only Windows Setup options.
So this is what we do:
### Partition and format a hard disk.
Reference: https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-diskconfiguration

We create a single NTFS partition with a size of 80GB

Tips: Order: starting with 1 and increasing
https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-diskconfiguration-disk-createpartitions-createpartition

### Windows image and target partition
Reference: https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-imageinstall-osimage

First step is to select a specific Windows image to install, the path of that image, and any credentials required to access that image. We use the image provided with the iso. So no credentials needed.
Second step is to select a partition on the destination computer where you install Windows. We only have one partition so we use this.
```
<ImageInstall>
    <OSImage>
        <InstallFrom>
            <MetaData wcm:action="add">
                <Key>/IMAGE/NAME</Key>
                <Value>Windows 10 Enterprise N 2016 LTSB</Value>
            </MetaData>
        </InstallFrom>
        <InstallTo>
            <DiskID>0</DiskID>
            <PartitionID>1</PartitionID>
        </InstallTo>
    </OSImage>
</ImageInstall>
```
### Apply a product key and administrator password.
Reference: https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-userdata

Product keys for Windows eventually need to be updated. I currently use the ones mentioned here:
http://technet.microsoft.com/en-us/library/jj612867.aspx

### Run specific commands during Windows Setup.
References: 
* https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-runsynchronous
* https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-runasynchronous
During setup no commands will be executed. We will do this later.

## offline Servicing

Reference https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-shell-setup-offlineuseraccounts

## oobeSytem (Out-Of-the-Box-Experience)
Reference: https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/oobesystem

It runs the first time the user starts a newly configured computer and  before a user first logs on to Windows®.

# Common Errors and Troubleshooting
Unfortunately the validation of the Windows System Image Manager does not point out all possible issues. So it is sometimes a trial and error until you get a working answer file.

## Windows cannot parse the unattend answer file's <DiskConfiguration> setting
Some settings just don't go together unfortunately with this message it is not really clear what's wrong.
* often empty values cause this problem so instead remove settingsnot used by "Revert changes". The difference of both is "Revert changes" also removes the tag in the xml while with an empty value there is still a tag in the xml
* I tried TypeID "Primary" in in the [https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-diskconfiguration-disk-modifypartitionsDisk](Configuration > Disk > Modify Partition) but unfortunatley it caused the error. Removing it solved it.


## "Select OS" dialog is shown
Unattended installation stopped quite early and showd "Select OS" screen. This is caused if no image source is specified.

## "Get Going Fast" page opens during setup
This happens if there is no default valueset for [https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-shell-setup-oobe-protectyourpc?f=255&MSPPError=-2147217396](ProtectYourPC)

## "Other user" is shwon after first login
...

## User is not administrator
You missed to specify the "group" in the "Offline User Accounts" settings. 
```
<OfflineLocalAccounts>
    <LocalAccount wcm:action="add">
        ...
        <Group>Administrators</Group>
    </LocalAccount>
</OfflineLocalAccounts>
```

## Problems parsing unattend file
Under certain circumstances you may get the following or a similar error after first reboot of the unattended installation:

```Windows could not parse or process the unattend answer file for pass [specialize]. The settings specified in the answer file cannot be applied.```

This means there is something wrong with your unnattend.xml or Autounattend.xml respectively. There is no generic solution to the problem but rather needs you to debug the problem. For this you can open a terminal by pressing [Shift]+[F10]. From the terminal you can open the log file `c:\windows\panther\setupact.log` or `c:\windows\panther\unattendGC\setupact.log` respectively using the command

```notepad c:\windows\panther\setupact.log```

Checkout for terms like "error", "not defined" and "not found" and analyze related messages in the log file.