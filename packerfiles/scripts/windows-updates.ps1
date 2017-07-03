#https://www.petri.com/manage-windows-updates-with-powershell-module
#install Windows Updates
Install-PackageProvider -Name Nuget -Force
Install-Module PSWindowsUpdate -Force -Confirm:$false

Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false
$loops = 0
While ((Get-WUList) -and ($loops -lt 10))
{
    Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreReboot
    $loops++
}

# Clean Up WinSxS Folder
# https://www.eightforums.com/tutorials/44351-winsxs-folder-component-store-clean-up-windows-8-1-a.html#option3
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
Dism.exe /online /Cleanup-Image /SPSuperseded