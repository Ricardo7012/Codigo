# Search for then add SQL group to SecPol and also grant an account to Lock Pages in Memory

# Variables used - change as required
$TempLocation = "C:\Temp"
$SQLServiceAccount = "IEHP\CHANGEME" #Account used for the SQL Service
$SQLInstance = "MSSQLSERVER"

# Variables that you don't need to change

# This is the line we need to change in the cfg file
$ChangeFrom = "SeManageVolumePrivilege = "
$ChangeFrom2 = "SeLockMemoryPrivilege = "

# Build the new line using local computername (needs the ` to escape the $)
$ChangeTo = "SeManageVolumePrivilege = SQLServerSQLAgentUser$" + $env:computername + "`$" + "$SQLInstance,"
$ChangeTo2 = "SeLockMemoryPrivilege = $SQLServiceAccount,"

# Check if temp location exists and create if it doesn't

IF ((Test-Path $TempLocation) -eq $false)
{
New-Item -ItemType Directory -Force -Path $TempLocation
Write-Host "Folder $TempLocation created"
}

# Set a name for the Security Policy cfg file.
$fileName = "$TempLocation\SecPolExport.cfg"

#export currect Security Policy config
Write-Host "Exporting Security Policy to file"
secedit /export /cfg $filename

# Use Get-Content to change the text in the cfg file and then save it
(Get-Content $fileName) -replace $ChangeFrom, $ChangeTo | Set-Content $fileName

# As the line for SeLockMemoryPrivilege only exists if there is something already in the group
# this will check for it and add your $SQLServiceAccount or use Add-Contect to append SeLockMemoryPrivilege and your $SQLServiceAccount
IF ((Get-Content $fileName) | where { $_.Contains("SeLockMemoryPrivilege") })
{
Write-Host "Appending line containing SeLockMemoryPrivilege with $SQLServiceAccount"
(Get-Content $fileName) -replace $ChangeFrom2, $ChangeTo2 | Set-Content $fileName
}
else
{
Write-Host "Adding new line containing SeLockMemoryPrivilege"
Add-Content $filename "`nSeLockMemoryPrivilege = $SQLServiceAccount"
}

# Import new Security Policy cfg (using '1> $null' to keep the output quiet)
Write-Host "Importing Security Policy..."
secedit /configure /db secedit.sdb /cfg $fileName 1> $null
Write-Host "Security Policy has been imported"
