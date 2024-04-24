## THIS CODE MUST BE RUN FROM A PC THAT CAN CONNECT TO AZURE

#Install-Module -Name ExchangeOnlineManagement
#Install-Module -Name MSOnline
#Install-Module -Name ExchangePowerShell


Import-Module -Name ExchangeOnlineManagement
#Import-Module MSOnline
#Import-Module -Name ExchangePowerShell

$Credential = Get-Credential

Connect-IPPSSession -Credential $Credential

Get-DlpSensitiveInformationType -Identity "Credit Card Number" | Format-List
Get-DlpSensitiveInformationTypeRulePackage
Get-DlpSensitiveInformationTypeRulePackage -Identity "Microsoft.SCCManaged.CustomRulePack" | Format-List

Get-DlpSensitiveInformationType -Identity "Microsoft.SCCManaged.CustomRulePack" | Format-List


Get-Label

#
Disconnect-ExchangeOnline