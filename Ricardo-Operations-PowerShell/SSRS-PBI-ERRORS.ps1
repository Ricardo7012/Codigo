cd \

Clear-Host

$env:UserName
$env:UserDomain
$env:ComputerName

Get-Date -Format G

$Server = 'PVSQLSRS01'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "application" -After 02/01/2022 -EntryType "Error" -Newest 20 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

$Server = 'PVSQLSRS02'
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName $Server -LogName "application" -After 02/01/2022 -EntryType "Error" -Newest 20 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-Content \\PVSQLSRS01\LogFiles\RSPowerBI_2022_02_24_00_00_01.log | Where-Object {$_ -like '*|ERROR|*'}

Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-Content \\PVSQLSRS02\LogFiles\RSPowerBI_2022_02_23_00_00_09.log | Where-Object {$_ -like "*|ERROR|*"}
