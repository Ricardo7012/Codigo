$env:UserName
$env:UserDomain
$env:ComputerName

Get-Date -Format G

Clear-Host
Get-ExecutionPolicy

# Restricted (Default)
# RemoteSigned (Guy's favourite. Local scripts OK)
# Unrestricted (Gung-ho setting, useful for testing)
# AllSigned (Secure but a pain to setup)
# Bypass (Never used)
# Undefined (Tricky setting)

Set-ExecutionPolicy Unrestricted -Force 

$host.version 
#Import-Module -Name sqlserver

#Get-Command -Module sqlserver

Get-EventLog -List

CLS
$Server = 'localhost'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "application" -After 04/17/2024 -EntryType "Error" -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

$Server = 'localhost'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "system" -After 04/17/2024 -EntryType "Error" -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

$Server = 'localhost'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "security" -After 04/17/2024 -EntryType "Error"  -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"


Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "application" -Source SQLISPackage130 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "system" -EntryType error -Newest 15 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "security"  -Newest 15 #| Out-GridView 
Write-Host -ForegroundColor green "*************************************************************************************************************************"

#
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "system" -Newest 5 | Where-Object {$_.EventID -eq 17828} #| out-gridview
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"

Get-EventLog -ComputerName $Server -LogName "security" -After (Get-Date).AddDays(-1)# | Where-Object {$_.EventID -eq 1076} #| out-gridview

Write-Host -ForegroundColor "green" "*************************************************************************************************************************"
$AfterDate = ([datetime]'8/16/2017 11:40:00 pm')
$BeforeDate = ([datetime]'8/17/2017 12:40:00 am')

Get-Eventlog -ComputerName $Server -Logname "security" -after $AfterDate -Before $BeforeDate



$Targets = "localhost"
$Targets | % { 
Get-WmiObject Win32_DiskPartition -ComputerName $_ | select SystemName, Name, Index, BlockSize, StartingOffset | Format-Table}

CLS
Get-EventLog -LogName Application | Where-Object {$_.EventID -eq 1645} #| fl

#Get-WinEvent -FilterHashtable @{Logname='Application';ID=1645}  -MaxEvents 100

ping iehpshare


cd \
clear-host
Get-Date
Write-Host "HOSTNAME: " 
hostname
systeminfo /fo csv | ConvertFrom-Csv | select OS*, System*, Hotfix* | Format-List
#[environment]::OSVersion.Version
#(Get-WmiObject Win32_OperatingSystem).OSArchitecture
Get-EventLog -List

$Server = hostname
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "application" -After 12/01/2021 -EntryType "Error" -Newest 1 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"


#sfc /scannow 