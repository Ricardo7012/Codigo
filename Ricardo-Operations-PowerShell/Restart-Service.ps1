#Get-Service -Name SQL* -ComputerName qvsqlhsp01
Get-Service -Name MSSQL* -ComputerName qvsqlhsp01
#Get-Service -Name MSSQL* -ComputerName qvsqlhsp01 | Set-Service -Status Running

Get-Service -Name MSSQL* -ComputerName QVSQLHSP01 | Restart-Service -Force