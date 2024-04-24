CLS
# LAST BOOT TIME
Get-WmiObject win32_operatingsystem | select csname, @{LABEL=’LastBootUpTime’ ;EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"

#RESTART
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"
gwmi win32_ntlogevent -filter "LogFile='System' and EventCode='1074' and Message like '%restart%'" | 
	select User,@{n="Time";e={$_.ConvertToDateTime($_.TimeGenerated)}}
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"

#1076
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"
Get-EventLog -ComputerName "localhost" -LogName "system" -Newest 10 | Where-Object {$_.EventID -eq 1076} #| out-gridview
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"

#6008
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"
Get-EventLog -ComputerName "localhost" -LogName "system" -Newest 10 | Where-Object {$_.EventID -eq 6008} #| out-gridview
Write-Host -ForegroundColor "green" "*************************************************************************************************************************"

#ERROR
Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-EventLog -ComputerName localhost -LogName "system" -After 1/1/2024 -EntryType Error -Newest 200 #| out-gridview
Write-Host -ForegroundColor green "*************************************************************************************************************************"

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
} | Select-Object Date, Action, Reason, User
