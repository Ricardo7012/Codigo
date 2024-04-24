#Get-Module -ListAvailable
#LOOKING FOR NETSECURITY - COMMANDS WORK ON WIN 8, 2012 AND GREATER ONLY!
#Manifest   2.0.0.0    NetSecurity {Get-DAPolicyChange, New-NetIPsecAuthProposal, New-NetIPsecMainModeCryptoProposal, New-NetIPsecQuickModeCryptoProposal...}

#Get-Command *-*firewall*

## cmd prompt to see port   
## netstat -ao -p tcp

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  

Write-host ========= SQL Server Ports ===================
Write-host Enabling SQLServer default instance port 1433

#netsh firewall set portopening TCP 1433 "SQLServer"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 1433" –Direction inbound –LocalPort 1433 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 1433" –Direction outbound –LocalPort 1433 -Protocol TCP -Action Allow
Write-host Enabling Dedicated Admin Connection port 1434

#netsh firewall set portopening TCP 1434 "SQL Admin Connection"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 1434" -Direction inbound –LocalPort 1434 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 1434" -Direction outbound –LocalPort 1434 -Protocol TCP -Action Allow
Write-host Enabling conventional SQL Server Service Broker port 4022

#netsh firewall set portopening TCP 4022 "SQL Service Broker"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 4022" -Direction inbound –LocalPort 4022 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 4022" -Direction outbound –LocalPort 4022 -Protocol TCP -Action Allow
Write-host Enabling Transact-SQL Debugger/RPC port 135

#netsh firewall set portopening TCP 135 "SQL Debugger/RPC"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 135" -Direction inbound –LocalPort 135 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 135" -Direction outbound –LocalPort 135 -Protocol TCP -Action Allow

Write-host Enabling conventional SQL Server ENDPOINT port 5022
#netsh firewall set portopening TCP 5022 "SQL Service Broker"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 5022" -Direction inbound –LocalPort 5022 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 5022" -Direction outbound –LocalPort 5022 -Protocol TCP -Action Allow

Write-host ========= Analysis Services Ports ==============
Write-host Enabling SSAS Default Instance port 2383
#netsh firewall set portopening TCP 2383 "Analysis Services"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 2383" -Direction inbound –LocalPort 2383 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 2383" -Direction outbound –LocalPort 2383 -Protocol TCP -Action Allow
Write-host Enabling SQL Server Browser Service port 2382

#netsh firewall set portopening TCP 2382 "SQL Browser"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 2382" -Direction inbound –LocalPort 2382 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 2382" -Direction outbound –LocalPort 2382 -Protocol TCP -Action Allow
Write-host ========= Misc Applications ==============

Write-host Enabling HTTP port 80
#netsh firewall set portopening TCP 80 "HTTP"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 80" -Direction inbound –LocalPort 80 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 80" -Direction outbound –LocalPort 80 -Protocol TCP -Action Allow
Write-host Enabling SSL port 80

#netsh firewall set portopening TCP 443 "SSL"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 443" -Direction inbound –LocalPort 443 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 443" -Direction outbound –LocalPort 443 -Protocol TCP -Action Allow
Write-host Enabling port for SQL Server Browser Service's 'Browse

#netsh firewall set portopening TCP 139 "FILESTREAM"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 139" -Direction inbound –LocalPort 139 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 139" -Direction outbound –LocalPort 139 -Protocol TCP -Action Allow
Write-host Enabling port for SQL Server FILESTREAM

#netsh firewall set portopening TCP 445 "FILESTREAM"
New-NetFirewallRule -DisplayName "SQL Allow inbound TCP Port 445" -Direction inbound –LocalPort 445 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQL Allow outbound TCP Port 445" -Direction outbound –LocalPort 445 -Protocol TCP -Action Allow
Write-host Enabling port for SQL Server FILESTREAM

#NEEDED FOR WINDOWS UPDATES
enable-netfirewallrule -displaygroup "file and printer sharing"
enable-netfirewallrule -displaygroup "windows management instrumentation (wmi)"


#http://wiki.idera.com/display/SQLDM/IDERA+Dashboard+and+web+console+requirements
#IDERA
New-NetFirewallRule -DisplayName "IDERA Dashboard Core Services port: 9292" -Direction inbound –LocalPort 9292 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA Dashboard Core Services port: 9292" -Direction outbound –LocalPort 9292 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA Dashboard Web Application Service port: 9290" -Direction inbound –LocalPort 9290 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA Dashboard Web Application Service port: 9290" -Direction outbound –LocalPort 9290 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA Dashboard Web Application Monitor port: 9094" -Direction inbound –LocalPort 9094 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA Dashboard Web Application Monitor port: 9094" -Direction outbound –LocalPort 9094 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA Dashboard Web Application SSL port: 9291" -Direction inbound –LocalPort 9291 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA Dashboard Web Application SSL port: 9291" -Direction outbound –LocalPort 9291 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "IDERA ServicePort Services port: 5167" -Direction inbound –LocalPort 5167 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA ServicePort Services port: 5167" -Direction outbound –LocalPort 5167 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA managementServicePort Services port: 5166" -Direction inbound –LocalPort 5166 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA managementServicePort Services port: 5166" -Direction outbound –LocalPort 5166 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "IDERA RPC Services port: 1304" -Direction inbound –LocalPort 1304 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA RPC Services port: 1304" -Direction outbound –LocalPort 1304 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "IDERA RPC Services port: 135" -Direction inbound –LocalPort 135 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "IDERA RPC Services port: 135" -Direction outbound –LocalPort 135 -Protocol TCP -Action Allow

#Enable Windows Firewall
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
