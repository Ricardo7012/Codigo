# *****************************************************************************
# https://support.microsoft.com/en-us/help/3153756/how-to-configure-sql-server-2016-to-send-feedback-to-microsoft
# How to configure SQL Server 2016 or later to send feedback to Microsoft
# New-ItemProperty Module: Microsoft.PowerShell.Management 
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-itemproperty?view=powershell-5.1 
# *****************************************************************************
Clear-Host
Get-ExecutionPolicy

# Restricted (Default)
# RemoteSigned (Guy's favourite. Local scripts OK)
# Unrestricted (Gung-ho setting, useful for testing)
# AllSigned (Secure but a pain to setup)
# Bypass (Never used)
# Undefined (Tricky setting)

Set-ExecutionPolicy Unrestricted -Force 

#$PSVersionTable.PSVersion
#$host.version 
#Get-Module -ListAvailable

CD \
$registryPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL13.MSSQLSERVER\CPE\"
$registryPath2 = "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\130\"
$Telemetry = "Registry::HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\Telemetry"
$Name1 = "CustomerFeedback"
$Name2 = "EnableErrorReporting"
$value = "0"

#Test-Path $registryPath

#Get-ChildItem -Path $registryPath

#Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL13.MSSQLSERVER\CPE" | ForEach-Object {Get-ItemProperty $_.pspath}

Write-Host "VALUES BEFORE:"
(Get-ItemProperty -Path $registryPath -Name CustomerFeedback).CustomerFeedback
(Get-ItemProperty -Path $registryPath -Name EnableErrorReporting).EnableErrorReporting
#(Get-ItemProperty -Path $Telemetry -Name TurnOffSwitch).TurnOffSwitch
(Get-ItemProperty -Path $registryPath2 -Name CustomerFeedback).CustomerFeedback
(Get-ItemProperty -Path $registryPath2 -Name EnableErrorReporting).EnableErrorReporting


IF(!(Test-Path $registryPath))
{
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $Name1 -Value $value -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $Name2 -Value $value -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPath2 -Name $Name1 -Value $value -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPath2 -Name $Name2 -Value $value -PropertyType DWORD -Force | Out-Null
}
ELSE 
{
    New-ItemProperty -Path $registryPath -Name $Name1 -Value $value -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $Name2 -Value $value -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPath2 -Name $Name1 -Value $value -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPath2 -Name $Name2 -Value $value -PropertyType DWORD -Force | Out-Null
}

Write-Host "VALUES AFTER:"
(Get-ItemProperty -Path $registryPath -Name CustomerFeedback).CustomerFeedback
(Get-ItemProperty -Path $registryPath -Name EnableErrorReporting).EnableErrorReporting
#(Get-ItemProperty -Path $Telemetry -Name TurnOffSwitch).TurnOffSwitch
(Get-ItemProperty -Path $registryPath2 -Name CustomerFeedback).CustomerFeedback
(Get-ItemProperty -Path $registryPath2 -Name EnableErrorReporting).EnableErrorReporting 
