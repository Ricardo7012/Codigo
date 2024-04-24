$env:UserName
$env:UserDomain
$env:ComputerName

Get-Date -Format G

$kerb_tickets = Get-EventLog -LogName Security -InstanceId 4769 -After "11/05/2021"

$kerb_events | % { Write-Output $_.Message.split("`n")[8] }
$kerb_events | % { Write-Output $_.Message.split("`n")[3] }
$kerb_events | % { Write-Output $_.Message.split("`n")[18] }
$kerb_events | % { Write-Output $_.Message.split("`n")[17] }

