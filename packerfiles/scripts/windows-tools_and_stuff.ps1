# add your customizations here in this script.
# e.g. install Chocolatey
Write-Host "** Install Chocolatey from internet"
if (Test-Path "$env:windir\explorer.exe") {
  Invoke-Webrequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
}

# adding a syscrep script to c:\scripts. This will set the winrm service to start manually
# https://github.com/mwrock/packer-templates/issues/49
Write-Host "** Add sysprep script to c:\scripts to call when Packer performs a shutdown."
$SysprepCmd = @"
sc config winrm start=demand
C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:C:/Windows/Panther/Unattend/unattend.xml /quiet /shutdown
"@

Set-Content -path "C:\Scripts\sysprep.cmd" -Value $SysprepCmd

# we need to set the winrm service to auto upon first boot
# https://technet.microsoft.com/en-us/library/cc766314(v=ws.10).aspx
$SetupComplete = @"
cmd.exe /c sc config winrm start= auto
cmd.exe /c net start winrm
"@

New-Item -Path 'C:\Windows\Setup\Scripts' -ItemType Directory -Force
Set-Content -path "C:\Windows\Setup\Scripts\SetupComplete.cmd" -Value $SetupComplete

if (Test-Path "C:\Users\Vagrant\Desktop\extend-trial.cmd") {
  Remove-Item -path "C:\Users\Vagrant\Desktop\extend-trial.cmd"
}


# Installing Guest Additions or Parallels tools
Write-Host 'Installing Guest Additions or Parallels Tools'
if (Test-Path d:\VBoxWindowsAdditions.exe) {
  Write-Host "Adding VBox certificates..."
  pushd d:\cert
   & .\VBoxCertUtil.exe add-trusted-publisher .\vbox-sha1.cer
   & .\VBoxCertUtil.exe add-trusted-publisher .\vbox-sha256.cer
   & .\VBoxCertUtil.exe add-trusted-publisher .\vbox-sha256-r3.cer
  popd

  Write-Host "Installing VBoxWindowsAdditions..."
  Start-Process 'd:\VBoxWindowsAdditions.exe' -Wait -ArgumentList @('/S')
}

if (-not (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Oracle VM VirtualBox Guest Additions'))
{
  throw "VBox Guest Additions not installed."
}
exit 0