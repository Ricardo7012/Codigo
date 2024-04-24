clear
Write-Host "SQL Server 2019"
Write-Host "====================="
Get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL15.*\MSSQLServer\SuperSocketNetLib\Tcp" | Select-Object -Property Enabled, KeepAlive, ListenOnAllIps,@{label='ServerInstance';expression={$_.PSPath.Substring(74)}} |Format-Table -AutoSize
Get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL15.*\MSSQLServer\SuperSocketNetLib\Tcp\IP*\" | Select-Object -Property TcpDynamicPorts,TcpPort,DisplayName, @{label='ServerInstance_and_IP';expression={$_.PSPath.Substring(74)}}, IpAddress |Format-Table -AutoSize

Write-Host "SQL Server 2017"
Write-Host "====================="
Get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL14.*\MSSQLServer\SuperSocketNetLib\Tcp" | Select-Object -Property Enabled, KeepAlive, ListenOnAllIps,@{label='ServerInstance';expression={$_.PSPath.Substring(74)}} |Format-Table -AutoSize
Get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL14.*\MSSQLServer\SuperSocketNetLib\Tcp\IP*\" | Select-Object -Property  TcpDynamicPorts,TcpPort, DisplayName, @{label='ServerInstance_and_IP';expression={$_.PSPath.Substring(74)}}, IpAddress |Format-Table -AutoSize

Write-Host "SQL Server 2016"
Write-Host "====================="
Get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL13.*\MSSQLServer\SuperSocketNetLib\Tcp" | Select-Object -Property Enabled, KeepAlive, ListenOnAllIps,@{label='ServerInstance';expression={$_.PSPath.Substring(74)}} |Format-Table -AutoSize
Get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL13.*\MSSQLServer\SuperSocketNetLib\Tcp\IP*\" | Select-Object -Property  TcpDynamicPorts,TcpPort, DisplayName, @{label='ServerInstance_and_IP';expression={$_.PSPath.Substring(74)}}, IpAddress |Format-Table -AutoSize

Write-Host "SQL Server 2014"
Write-Host "====================="
Get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.*\MSSQLServer\SuperSocketNetLib\Tcp" | Select-Object -Property Enabled, KeepAlive, ListenOnAllIps,@{label='ServerInstance';expression={$_.PSPath.Substring(74)}} |Format-Table -AutoSize
Get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.*\MSSQLServer\SuperSocketNetLib\Tcp\IP*\" | Select-Object -Property  TcpDynamicPorts,TcpPort, DisplayName, @{label='ServerInstance_and_IP';expression={$_.PSPath.Substring(74)}}, IpAddress |Format-Table -AutoSize

### https://docs.microsoft.com/en-us/troubleshoot/sql/connect/static-or-dynamic-port-config 
