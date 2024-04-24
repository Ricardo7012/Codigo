## THIS CODE MUST BE RUN FROM A PC THAT CAN CONNECT TO AZURE

#Install-Module -Name ExchangeOnlineManagement
#Install-Module -Name MSOnline
#Install-Module -Name ExchangePowerShell

####################################444
### 
####################################444
Import-Module ExchangeOnlineManagement
Import-Module MSOnline

$Credential = Get-Credential
Connect-IPPSSession -Credential $Credential
Connect-MsolService -Credential $Credential

#Get-Label

#Get-Label | Out-GridView 
#
#Get-Label | Format-Table -Property DisplayName, Name, Guid, ContentType 
#
#Get-Label | Format-Table -Wrap -AutoSize -Property *

Get-JournalRule

Get-LabelPolicy

Get-AutoSensitivityLabelPolicy 

Get-AutoSensitivityLabelPolicy | Format-List *

Set-AutoSensitivityLabelPolicy -Identity "IEHP Highly Confidential" -RetryDistribution

## https://learn.microsoft.com/en-us/microsoft-365/troubleshoot/retention/resolve-errors-in-retention-and-retention-label-policies
Get-AutoSensitivityLabelPolicy -Identity "IEHP Highly Confidential" -DistributionDetail | Select -ExpandProperty DistributionResults

# Disconnect-ExchangeOnline


Get-Date