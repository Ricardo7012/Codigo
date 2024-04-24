## THIS CODE MUST BE RUN FROM A PC THAT CAN CONNECT TO AZURE

#Install-Module -Name ExchangeOnlineManagement


Import-Module -Name ExchangeOnlineManagement


$Credential = Get-Credential
Connect-IPPSSession -Credential $Credential

# https://learn.microsoft.com/en-us/purview/create-sensitivity-labels?view=o365-worldwide#powershell-tips-for-specifying-the-advanced-settings 
# https://learn.microsoft.com/en-us/powershell/module/exchange/get-label?view=exchange-ps

Get-Label
Get-Label | Format-Table -Property DisplayName, Name, Guid, ContentType
(Get-Label -Identity defa4170-0d19-0005-0001-bc88714345d2).settings
Get-Label -Identity "defa4170-0d19-0005-0001-bc88714345d2" | Format-List
# https://learn.microsoft.com/en-us/purview/create-sensitivity-labels

#Disconnect-ExchangeOnline