# General
For general information checkout https://github.com/papanito/packer-vagrant

# Answer file generation
Due to the  complex structure of answer files you shall use tools for that, the Windows System Image Manager (Windows SIM) – which is part of the [https://developer.microsoft.com/en-us/windows/hardware/windows-assessment-deployment-kit](Windows Assessment and Deployment Kit).

Keys in WIM (source: http://www.msfn.org/board/topic/88048-amd64-wow64-x86-in-the-wsim/)
- amd_64 - 64bit components, only used on x64 installs
- wow_64 - 32bit components or support components for 32bit compat installed on x64, only used on x64 installs
- x86 - 32bit components installed on x86, only used on x86 installs

As windows relies on a fixed name "Unattend.xml" or "Autounattended.xml" respectively, they are divided in sub folders (1 per Windows version). YOu may wonder why you may need two files, I recommend read trough https://technet.microsoft.com/en-us/library/cc749415(v=ws.10).aspx
> As a rule, only answer files named Unattend.xml are used. However, because some answer files include destructive actions such as disk partitioning, you must rename your Unattend.xml file to Autounattend.xml in the windowsPE and offlineServicing configuration passes. These passes run when you first run Windows PE or Setup.exe. You typically use the Autounattend.xml file when you use the Windows Setup DVD boot method and supply an answer file on a USB flash drive (UFD) or floppy disk.

Product keys for Windows eventually need to be updated. I currently use the ones mentioned here:
http://technet.microsoft.com/en-us/library/jj612867.aspx

More info to language locales:
https://msdn.microsoft.com/en-us/library/dd318693(v=vs.85).aspx

More info to timezone identifiers:
https://technet.microsoft.com/en-us/library/cc749073(v=ws.10).aspx

# Passes
The file is divided in different sections called “Configuration passes” and are used to specify different phases of the Windows Setup. More info to this can be found at MSDN:

https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/how-configuration-passes-work

https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/automate-windows-setup

## windowsPE
https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/windowspe

This pass is triggered when booting the Windows Setup media (.iso) . As we don't use a [https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/winpe-intro](Windows PE) we do not use Windows PE options but only Windows Setup options.

- Partition and format a hard disk.
-- Single NTFS partition with a size of 80GB
-- https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-diskconfiguration
https://msdn.microsoft.com/en-us/windows/hardware/commercialize/customize/desktop/unattend/microsoft-windows-setup-diskconfiguration-disk-createpartitions-createpartition

Order: starting with 1 and increasing
- Select a specific Windows image to install, the path of that image, and any credentials required to access that image.
--
- Select a partition on the destination computer where you install Windows.
-- 
- Apply a product key and administrator password.
--
- Run specific commands during Windows Setup.