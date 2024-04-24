
Get-Command -Noun WindowsCapability

#need to run PS as administrator
Install-WindowsFeature RSAT-AD-PowerShell
#Get-WindowsCapability -Name RSAT* -Online
#Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State
#Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online

Import-Module ActiveDirectory

Clear-Host
Write-Host -ForegroundColor Green "###################################################"
###################################################################
Get-ADUser -Filter {Name -like "Carlos gomez"} |
    Select-Object Name,SamAccountName,UserPrincipalName,DistinguishedName,SID,Enabled;

Get-ADuser -Filter "Name -eq 'Divyan*'"

Clear-Host
$user = 'Dynatracesvc'
Get-ADUser $user -Properties * # whencreated, whenchanged


#GET GROUPS A USER IS IN
(Get-ADUser $user –Properties MemberOf | Select-Object MemberOf).MemberOf | Sort-Object name -Descending

#GET USER VIA SID
$sid = 'S-1-5-21-1116368803-1477248739-1928362250-31255'
Get-ADUser –Filter {SID –eq $sid}

$objSID = New-Object System.Security.Principal.SecurityIdentifier ("S-1-5-21-1116368803-1477248739-1928362250-500")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value


function GetGroups 
{ 
 param ( $strGroup )

$CurrentGroupGroups = (GET-ADGROUP –Identity $strGroup –Properties MemberOf | Select-Object MemberOf).MemberOf 
 foreach($Memgroup in $CurrentGroupGroups) 
 { 
 $strMemGroup = $Memgroup.split(',')[0] 
 $strMemGroup = $strMemGroup.split('=')[1] 
 $strMemGroup 
 GetGroups -strGroup $strMemGroup 
 } 
}

Import-Module ActiveDirectory

$CurrentUser = $user 
$CurrentUserGroups = (GET-ADUSER –Identity $CurrentUser –Properties MemberOf | Select-Object MemberOf).MemberOf

foreach($group in $CurrentUserGroups) 
{ 
 $strGroup = $group.split(',')[0] 
 $strGroup = $strGroup.split('=')[1] 
 $strGroup 
 GetGroups -strGroup $strGroup 
}
###################################################################


# ------ List AD Group ------ 
Clear-Host
Get-ADGroup -Filter {name -eq "RabbitMQ_Admin"} -Properties * | 
    Select-Object * 


Clear-Host
$sid = “S-1-5-21-1116368803-1477248739-1928362250-30660”
$object = New-Object System.Security.Principal.SecurityIdentifier ($sid) 
$result = $object.Translate([System.Security.Principal.NTAccount]) 
$result.Value


Get-ADGroupMember -identity "HSPSQLPExecute" -Recursive | ForEach-Object{ get-aduser $_} | Select-Object SamAccountName,objectclass,name
Get-ADGroupMember -identity "_edpssrv"  | ForEach-Object{ get-aduser $_} | Select-Object SamAccountName,objectclass,name
Clear-Host
Import-Module ActiveDirectory
Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -Identity "DEV-RabbitMQ_Admin" | Select-Object name,objectclass,displayname | Sort-Object name -Descending

Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -Identity "" | Select-Object name | Sort-Object name -Descending

Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -identity "ArchDevDBOwner" | Select-Object name | Sort-Object name -Descending
Clear-Host
Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -identity "_tallan" | Select-Object name | Sort-Object name -Descending

Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -identity "HSP1DataReader" | Select-Object name | Sort-Object name -Descending

Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -identity "HSP1Execute" | Select-Object name | Sort-Object name -Descending

Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -identity "HSP1Datawriter" | Select-Object name | Sort-Object name -Descending

Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -identity "HSP1DDLAdmins" | Select-Object name | Sort-Object name -Descending
Write-Host -ForegroundColor Green "###################################################"

net user /domain username
net group "DATASCIENCE_ADMIN" 

systeminfo

Clear-Host
Get-HotFix -Description "Security*" 

Clear-Host
(Get-HotFix | Sort-Object installedon)#[-4]

Clear-Host
$Server = $env:computername
$Server
Get-HotFix -ComputerName $Server -Id "KB3126587"

Get-HotFix -id kb968934

ping QLVNNHSP01
ping QLVNNHSP02

PING 172.18.207.116

#GET CUMPUTER SID
#Use PowerShell to Find Computers SIDs in AD DS

Get-ADComputer -Filter “name -eq 'IEHP-4698'” -Properties sid | Select-Object *

Get-ADGroup -Identity ReportUsers_BH
Get-ADGroup -Identity ITDevelopment 
Get-ADGroup -Identity IT_Development 

Get-Date

$Host.Version 
(Get-Host).Version
$PSVersionTable.PSVersion


$ComputerIPAddress = ‘172.20.36.36’
[System.Net.Dns]::GetHostEntry($ComputerIPAddress).HostName

Get-ADComputer "iehp-4698" -Properties * 
