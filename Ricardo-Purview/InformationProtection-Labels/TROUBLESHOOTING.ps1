#####################################################
#Requires -Modules ExchangeOnlineManagement, MSOnline
#Requires -RunAsAdministrator 
#####################################################
Import-Module ExchangeOnlineManagement
Import-Module MSOnline

$Credential = Get-Credential
Connect-IPPSSession -Credential $Credential
Connect-MsolService -Credential $Credential

## THIS CODE MUST BE RUN FROM A PC THAT CAN CONNECT TO AZURE

Import-Module -Name ExchangeOnlineManagement

$Credential = Get-Credential
Connect-IPPSSession -Credential $Credential

# https://learn.microsoft.com/en-us/purview/create-sensitivity-labels?view=o365-worldwide#powershell-tips-for-specifying-the-advanced-settings 
# https://learn.microsoft.com/en-us/powershell/module/exchange/get-label?view=exchange-ps

Get-Label
Get-Label | Format-Table -Property DisplayName, Name, Guid, ContentType
Get-Label | Format-Table -Property DisplayName, Name, Guid, ContentType, Settings -Wrap
## GUID FROM admin@M365x78962251.onmicrosoft.com
(Get-Label -Identity ef3844ad-c263-4a3f-b719-bff6e282915e).settings
Get-Label -Identity "ef3844ad-c263-4a3f-b719-bff6e282915e" | Format-List
# https://learn.microsoft.com/en-us/purview/create-sensitivity-labels

Get-LabelPolicy
Get-AutoSensitivityLabelPolicy 
Get-AutoSensitivityLabelPolicy | Format-List *
#Set-AutoSensitivityLabelPolicy -Identity "IEHP Highly Confidential" -RetryDistribution

## https://learn.microsoft.com/en-us/microsoft-365/troubleshoot/retention/resolve-errors-in-retention-and-retention-label-policies
Get-AutoSensitivityLabelPolicy -Identity "IEHP Highly Confidential" -DistributionDetail | Select -ExpandProperty DistributionResults

Disconnect-ExchangeOnline