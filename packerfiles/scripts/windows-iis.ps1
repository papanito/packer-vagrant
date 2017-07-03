# This script is usesd to provision Web
# Image containing .Net4.5 and Web plus required Web extensions
Import-Module servermanager

Add-WindowsFeature Web-Webserver -IncludeAllSubFeature
Add-WindowsFeature Web-Net-Ext45 -IncludeAllSubFeature
Add-WindowsFeature Web-ISAPI-Filter -IncludeAllSubFeature
Add-WindowsFeature Web-Asp-Net45 -IncludeAllSubFeature
Add-WindowsFeature Web-ASP -IncludeAllSubFeature
Add-WindowsFeature Web-CGI -IncludeAllSubFeature
Add-WindowsFeature NET-WCF-Services45 -IncludeAllSubFeature
Add-WindowsFeature NET-WCF-HTTP-Activation45 -IncludeAllSubFeature
Add-WindowsFeature NET-WCF-TCP-Activation45 -IncludeAllSubFeature
Add-WindowsFeature NET-WCF-Pipe-Activation45 -IncludeAllSubFeature
Add-WindowsFeature NET-WCF-MSMQ-Activation45 -IncludeAllSubFeature
Add-WindowsFeature NET-WCF-TCP-PortSharing45 -IncludeAllSubFeature