## AVOID SCREEN SLEEP ##

Clear-Host

Get-Date

$WShell = New-Object -Com "Wscript.shell"
while (1) {$WShell.SendKeys("{SCROLLLOCK}"); Start-Sleep 60}
