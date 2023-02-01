cls
Get-Service -ComputerName bizprod -Name "BTS*" 


# | Start-service

#gpupdate /force 

$sess = New-PSSession -ComputerName bizprod -Credential (Get-Credential)
Invoke-Command -Session $sess -ScriptBlock {get-service}

Remove-PSSession -Session $sess

whoami