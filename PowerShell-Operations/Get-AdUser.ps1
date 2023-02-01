Import-Module ActiveDirectory
Write-Host -ForegroundColor Green "###################################################"
###################################################################
CLS
$user = 'i4269'
Get-ADUser $user #-Properties * 

#GET GROUPS A USER IS IN
(Get-ADUser $user –Properties MemberOf | Select-Object MemberOf).MemberOf | Sort-Object name -Descending

#GET USER VIA SID
$sid = 'S-1-5-21-1116368803-1477248739-1928362250-27047'
Get-ADUser –Filter {SID –eq $sid}

$objSID = New-Object System.Security.Principal.SecurityIdentifier ("S-1-5-21-1116368803-1477248739-1928362250-27047")
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
CLS
Get-ADGroup -Filter {name -like "HSP*"} -Properties Description | 
    Select Name,Description,GroupCategory,GroupScope 


CLS
$sid = “S-1-5-21-1116368803-1477248739-1928362250-30660”
$object = New-Object System.Security.Principal.SecurityIdentifier ($sid) 
$result = $object.Translate([System.Security.Principal.NTAccount]) 
$result.Value


Get-ADGroupMember -identity "DataManagement_Developer" -Recursive | foreach{ get-aduser $_} | select SamAccountName,objectclass,name
Get-ADGroupMember -identity "_edpssrv"  | foreach{ get-aduser $_} | select SamAccountName,objectclass,name
CLS
Import-Module ActiveDirectory
Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -Identity "SQL_Admins" | Select-Object name,objectclass,displayname | Sort-Object name -Descending

Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -Identity "_sqladmins" | Select-Object name | Sort-Object name -Descending

Write-Host -ForegroundColor Green "###################################################"
Get-ADGroupMember -identity "ArchDevDBOwner" | Select-Object name | Sort-Object name -Descending
CLS
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

cls
Get-HotFix -Description "Security*" 

CLS
(Get-HotFix | sort installedon)#[-4]

cls
$Server = $env:computername
$Server
Get-HotFix -ComputerName $Server -Id "KB3126587"

Get-HotFix -id kb968934

ping QLVNNHSP01
ping QLVNNHSP02

PING 172.18.207.116

#GET CUMPUTER SID
#Use PowerShell to Find Computers SIDs in AD DS

Get-ADComputer -Filter “name -eq 'IEHP-4698'” -Properties sid | select *

Get-ADGroup -Identity IT_QA_USER
Get-ADGroup -Identity ITDevelopment 
Get-ADGroup -Identity IT_Development 

Get-Date

$Host.Version 
(Get-Host).Version
$PSVersionTable.PSVersion


$ComputerIPAddress = ‘172.20.36.36’
[System.Net.Dns]::GetHostEntry($ComputerIPAddress).HostName

Get-ADComputer "iehp-4698" -Properties * 
