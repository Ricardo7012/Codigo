## VERSION ##  Compress-7Zip REQUIRES WF 5.0 and 7Zip
## Windows Management Framework 5.0 KB -- Win8.1AndW2K12R2-KB3134758-x64.msu 
## https://www.microsoft.com/en-us/download/details.aspx?id=50395 

$PSVersionTable.PSVersion

###############################################################################
#Copy the dbo.AuditTrail table to a local file.
#    2.1 Open an administrative Command Prompt.
#    2.2 Change the local directory to the desired directory for the BCP file.
#    2.3 Execute the BCP command:
CLS
CD \
CD C:\Audit
#CD "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn"

###############################################################################
CLS
$FilePath = "C:\Audit\"
$FileName1 = "HSP1S1A_FormattedNames.dat"
$FileName2 = "HSP1S1A_AuditTrail.dat"


###############################################################################
## BCP ##
#bcp HSP.dbo.FormattedNames out $FilePath$FileName1 -S HSP1S1A.iehp.local -T -n
#bcp HSP.dbo.AuditTrail out $FilePath$FileName2 -S HSP1S1A.iehp.local -T -n


###############################################################################
## COMPRESS ## Compress-Archive 5.0 ONLY ## & RENAME ##
$datetime = Get-Date -uformat "%Y-%m-%d_%H-%M-%S_"
$NewFileName1 = $datetime+$FileName1+".7z"
$NewFileName2 = $datetime+$FileName2+".7z"

if (-not (Test-Path "$env:ProgramFiles\7-Zip\7z.exe")){
    Write-Warning "$env:ProgramFiles\7-Zip\7z.exe needed!"
} 

## PowerShell 5.0 or later, install 7Zip4PowerShell from the PSGallery over the Internet like this:
#Install-Module -Name 7Zip4PowerShell -Verbose ##
#Get-Command -Module 7Zip4PowerShell

Compress-7Zip -Path $FilePath -ArchiveFileName $NewFileName1 -WarningAction SilentlyContinue
Compress-7Zip -Path $FilePath -ArchiveFileName $NewFileName2 -WarningAction SilentlyContinue


###############################################################################
## CLEANUP ##
Remove-Item -path $FilePath$FileName1 #-WhatIf 
Remove-Item -path $FilePath$FileName2 #-WhatIf 

###############################################################################
## MOVE ##
$Destination = "\\dtsqlbkups\qvsqllit01backups\NonProduction\~HSPTableArchive"
Move-Item -Path $FilePath$FileName1 -Destination $Destination$newFileName1 #-WhatIf
Move-Item -Path $FilePath$FileName2 -Destination $Destination$newFileName2 #-WhatIf

###############################################################################
## CONFIRM CLEANUP ## 
Get-ChildItem -Path $FilePath

