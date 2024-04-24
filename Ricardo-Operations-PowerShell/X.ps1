cls
Write-Host -ForegroundColor Green "###################################################"
hostname
Write-Host -ForegroundColor Green "####### RESTART USER AND TIME ############################################"
gwmi win32_ntlogevent -filter "LogFile='System' and EventCode='1074' and Message like '%restart%'" | 
	select User,@{n="Time";e={$_.ConvertToDateTime($_.TimeGenerated)}}
Write-Host -ForegroundColor Green "###################################################"

$Server = $Env:ComputerName
Write-Host $Server
#
Write-Host -ForegroundColor "green" "###################################################"

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
