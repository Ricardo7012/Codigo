Clear-Host

$env:UserName
$env:UserDomain
$env:ComputerName

Get-Date -Format G

Write-Host -ForegroundColor Green "###################################################"
$Server = $Env:ComputerName
Write-Host $Server
Write-Host -ForegroundColor Green "####### RESTART USER AND TIME ############################################"
Get-WmiObject win32_ntlogevent -filter "LogFile='System' and EventCode='1074' and Message like '%restart%'" | 
	Select-Object User,@{n="Time";e={$_.ConvertToDateTime($_.TimeGenerated)}}
Write-Host -ForegroundColor Green "###################################################"


Write-Host -ForegroundColor "green" "###################################################"
$Server = $Env:ComputerName
Write-Host $Server
#
Get-WinEvent -FilterHashtable @{logname='System'; id=1074}  | ForEach-Object {
$rv = New-Object PSObject | Select-Object Date, User, Action, Process, Reason, ReasonCode, Comment
$rv.Date = $_.TimeCreated
$rv.User = $_.Properties[6].Value
$rv.Process = $_.Properties[0].Value
$rv.Action = $_.Properties[4].Value
$rv.Reason = $_.Properties[2].Value
$rv.ReasonCode = $_.Properties[3].Value
$rv.Comment = $_.Properties[5].Value
$rv
} | Select-Object Date, Action, User, Reason

Write-Host -ForegroundColor "green" "###################################################"

