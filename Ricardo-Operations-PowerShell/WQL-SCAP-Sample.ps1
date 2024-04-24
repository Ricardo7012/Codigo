## https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wql?view=powershell-5.1
$query = "Select * from Win32_Bios"
Get-WmiObject -Query $query

$queryNameVersion = "Select Name, Version from Win32_Bios"
Get-WmiObject -Query $queryNameVersion

Get-CimInstance -Query "Select * from Win32_Bios"

Get-WmiObject -Query "Select * from Win32_Process where name='Teams.exe'"

################################################################################
## https://www.stigviewer.com/stig/windows_10/2017-12-01/finding/V-74719
$query2 ="SELECT startmode FROM Win32_Service WHERE name='seclogon'"
Get-WmiObject -Query $query2

## V-220726 Rule Title: Data Execution Prevention (DEP) must be configured to at least OptOut.
### Note: Suspend BitLocker before making changes to the DEP configuration.####
#CHECK:
BCDEDIT /enum "{current}" 

#FIX
BCDEDIT /set '{current}' nx OptOut

#REVERT
BCDEDIT /set '{current}' nx OptIn

################################################################################
## V-220707 - Rule Title: The Windows 10 system must use an anti-virus program. 
get-service | Where-Object {$_.DisplayName -Like "*Defender*"} | Select-Object Status,DisplayName

Clear-Host
