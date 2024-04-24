$key = Get-Item HKLM:\security\sam\domains\account
$values = Get-ItemProperty $key.pspath
$bytearray = $values.V
New-Object System.Security.Principal.SecurityIdentifier($bytearray[272..295],0) | Format-List *

Get-ADComputer -Filter “name -eq 'PVSQLCMS01'” -Properties sid | select name, sid

ping hsp3s1a