#GET IP
ping IEHP-6286

#GET PCNAME
$ComputerIPAddress = '172.20.36.146'
[System.Net.Dns]::GetHostEntry($ComputerIPAddress).HostName

#GET USER PROFILES
Get-ChildItem 'HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'| get-itemproperty | select ProfileImagePath

#GET USER
Import-Module ActiveDirectory
Get-ADUser i2614 #-Properties *

#GET USER PROFILES
$path = 'Registry::HKey_Local_Machine\Software\Microsoft\Windows NT\CurrentVersion\ProfileList\*'
$items = Get-ItemProperty -path $path
Foreach ($item in $items) {
$objUser = New-Object System.Security.Principal.SecurityIdentifier($item.PSChildName)
$objName = $objUser.Translate([System.Security.Principal.NTAccount])
$item.PSChildName = $objName.value
}
echo $items | Select-Object -Property PSChildName, ProfileImagePath
