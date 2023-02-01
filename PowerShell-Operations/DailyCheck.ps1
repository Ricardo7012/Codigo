cls
Write-Host -ForegroundColor green "HSP1S1A*************************************************************************************************************************"
$Server = 'HSP1S1A'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "application" -After 01/01/2019 -EntryType "Error" -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

$Server = 'HSP1S1A'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "system" -After 01/01/2019 -EntryType "Error" -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

Write-Host -ForegroundColor green "HSP1S1B*************************************************************************************************************************"
$Server = 'HSP1S1B'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "application" -After 01/01/2019 -EntryType "Error" -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

$Server = 'HSP1S1B'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "system" -After 01/01/2019 -EntryType "Error" -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

Write-Host -ForegroundColor green "HSP1S1C*************************************************************************************************************************"
$Server = 'HSP1S1C'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "application" -After 01/01/2019 -EntryType "Error" -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

$Server = 'HSP1S1C'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "system" -After 01/01/2019 -EntryType "Error" -Newest 10 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"
