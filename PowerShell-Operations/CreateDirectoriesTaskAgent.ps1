#

[system.io.directory]::CreateDirectory("C:\Program Files\HSP\HSPCurrentTaskAgent")
[system.io.directory]::CreateDirectory("C:\Program Files (x86)\HSP\HSPCurrentTaskAgent")

########################################
# COPY DATA
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item?view=powershell-5.1
########################################

#Get-ChildItem "C:\Program Files\HSP" -filter "IEHP*" -Directory | % { $_.fullname }

$Folder = "C:\Program Files\HSP"
$Filt = "IEHP*"
$source = ""

$source = Get-ChildItem $Folder -Filter $Filt | Where { $_.PSIsContainer } |Sort CreationTime -Descending | Select -First 1 

Write-Host $source

$source = "C:\Program Files\HSP\" + $source
Write-Host $source

$destination = "C:\Program Files\HSP\HSPCurrentTaskAgent"
Write-Host $destination

Copy-Item -Path $source -Recurse -Destination $destination -Container -Force
