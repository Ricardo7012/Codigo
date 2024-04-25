#Get-Module -ListAvailable
#LOOKING FOR NETSECURITY - COMMANDS WORK ON WIN 8, 2012 AND GREATER ONLY!
#Manifest   2.0.0.0    NetSecurity {Get-DAPolicyChange, New-NetIPsecAuthProposal, New-NetIPsecMainModeCryptoProposal, New-NetIPsecQuickModeCryptoProposal...}

#Get-Command *-*firewall*

## cmd prompt to see port   
## netstat -ao -p tcp

## https://documentation.delphix.com/continuous-data-9-0-0-0/docs/en/network-security?highlight=ports

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  

Write-host ========= OUTBOUND ===================
Write-host ========= 21 ===================
#netsh firewall set portopening "21"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 21 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 21 -Protocol TCP -Action Allow

Write-host ========= 25 ===================
#netsh firewall set portopening "25"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 25 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 25 -Protocol TCP -Action Allow

Write-host ========= 53 ===================
#netsh firewall set portopening "53"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 53 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 53 -Protocol TCP -Action Allow

Write-host ========= 123 ===================
##netsh firewall set portopening "123"
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 123 -Protocol UDP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 123 -Protocol UDP -Action Allow

Write-host ========= 389 ===================
#netsh firewall set portopening "389"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 389 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 389 -Protocol TCP -Action Allow

Write-host ========= 389 ===================
#netsh firewall set portopening "389"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 389 -Protocol UDP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 389 -Protocol UDP -Action Allow

Write-host ========= 636 ===================
#netsh firewall set portopening "636"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 636 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 636 -Protocol TCP -Action Allow

Write-host ========= 636 ===================
#netsh firewall set portopening "636"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 636 -Protocol UDP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 636 -Protocol UDP -Action Allow

Write-host ========= 1023 ===================
#netsh firewall set portopening "1023"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 1023 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 1023 -Protocol TCP -Action Allow

Write-host ========= 8410 ===================
#netsh firewall set portopening "8410"
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 8410 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 8410 -Protocol TCP -Action Allow

Write-host ========= INBOUND ===================
Write-host ========= 22 ===================
#netsh firewall set portopening "22"
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 22 -Protocol TCP -Action Allow
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 22 -Protocol TCP -Action Allow

Write-host ========= 22 ===================
#netsh firewall set portopening "22"
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 22 -Protocol UDP -Action Allow
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 22 -Protocol UDP -Action Allow

Write-host ========= 80 ===================
#netsh firewall set portopening "80"
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 80 -Protocol TCP -Action Allow
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 80 -Protocol TCP -Action Allow

Write-host ========= 443 ===================
#netsh firewall set portopening "443"
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 443 -Protocol TCP -Action Allow
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 443 -Protocol TCP -Action Allow

Write-host ========= 8415 ===================
#netsh firewall set portopening "8415"
New-NetFirewallRule -DisplayName "DELPHIX-" –Direction inbound –LocalPort 8415 -Protocol TCP -Action Allow
#New-NetFirewallRule -DisplayName "DELPHIX-" –Direction outbound –LocalPort 8415 -Protocol TCP -Action Allow

#Enable Windows Firewall
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

## https://documentation.delphix.com/continuous-data-10-0-0-0/docs/overview-of-requirements-for-sql-server-environments?highlight=sql%20user%20permissions#staging-windows-user-requirements
Write-host ========= ADD ACCOUNT TO LOCAL ADMIN ===================
$DomainName = "xxx"
$ComputerName = "localhost"
$UserName = ""
$AdminGroup = [ADSI]"WinNT://$ComputerName/Administrators,group"
$User = [ADSI]"WinNT://$DomainName/$UserName,user"
$AdminGroup.Add($User.Path)
