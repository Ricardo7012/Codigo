Clear-Host

##
## https://learn.microsoft.com/en-us/microsoft-365/compliance/create-sensitivity-labels?view=o365-worldwide#example-configuration-to-configure-a-sensitivity-label-for-different-languages
##
## https://learn.microsoft.com/en-us/powershell/exchange/connect-to-scc-powershell?view=exchange-ps
##
## https://www.powershellgallery.com/packages/ExchangeOnlineManagement/3.1.0
##
#Find-Module -Name ExchangeOnlineManagement
 
#NEED TO RUN AS ADMINISTRATOR AND INCLUDE SCOPE
#Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -RequiredVersion 2.0.5
 
Import-Module ExchangeOnlineManagement
#Connect-IPPSSession
Connect-IPPSSession -UserPrincipalName admin@M365x18011736.onmicrosoft.com    #-#-99Yad8L4QG---
 
#Connect-IPPSSession -UserPrincipalName <UPN> [-ConnectionUri <URL>] [-AzureADAuthorizationEndpointUri <URL>] [-DelegatedOrganization <String>] [-PSSessionOption $ProxyOptions]
#Connect-IPPSSession -UserPrincipalName  -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/ -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common
 
## Use PowerShell for sensitivity labels and their policies
## https://learn.microsoft.com/en-us/microsoft-365/compliance/create-sensitivity-labels?view=o365-worldwide#use-powershell-for-sensitivity-labels-and-their-policies
##
## https://learn.microsoft.com/en-us/powershell/module/exchange/new-label?view=exchange-ps
## New-Label
##

#Get-Label -Identity "Highly Confidential"
Get-Label -Identity "Public" -IncludeDetailedLabelActions |Format-List
Get-Label -Identity "Internal Only" -IncludeDetailedLabelActions |Format-List
Get-Label -Identity "Confidential" -IncludeDetailedLabelActions |Format-List
Get-Label -Identity "Highly Confidential" -IncludeDetailedLabelActions |Format-List

#Get-Label | Format-Table -Property DisplayName, Name, Priority, Guid, ContentType

New-Label -DisplayName "" -Name "" -Tooltip ""

Remove-Label -Identity "f9122270-8772-4666-a564-c8704b72373c"

Get-Label | Format-Table -Property DisplayName, Name, Guid, ContentType, IsParent, ReadOnly, IsValid, Mode

#Set-Label -Identity 8faca7b8-8d20-48a3-8ea2-0f96310a848e -AdvancedSettings @{DefaultSharingScope=""}
#(Get-Label -Identity 8faca7b8-8d20-48a3-8ea2-0f96310a848e).settings

Disconnect-ExchangeOnline
# Disconnect-ExchangeOnline -Confirm:$false
# https://social.technet.microsoft.com/wiki/contents/articles/54498.sensitivity-labels-in-powershell-detailedlabelactions.aspx

