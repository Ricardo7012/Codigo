Clear-Host

##
## https://learn.microsoft.com/en-us/microsoft-365/compliance/create-sensitivity-labels?view=o365-worldwide#example-configuration-to-configure-a-sensitivity-label-for-different-languages
##
## https://learn.microsoft.com/en-us/powershell/exchange/connect-to-scc-powershell?view=exchange-ps
##
## https://www.powershellgallery.com/packages/ExchangeOnlineManagement/3.1.0
##
# Find-Module -Name ExchangeOnlineManagement
 
#NEED TO RUN AS ADMINISTRATOR AND INCLUDE SCOPE
# Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -RequiredVersion 2.0.5
 
Import-Module ExchangeOnlineManagement
#Connect-IPPSSessionIEHP
Connect-IPPSSession -UserPrincipalName "admin@M365x28310700.onmicrosoft.com" ## 3Fv9D9t61P ##

## Use PowerShell for sensitivity labels and their policies
## https://learn.microsoft.com/en-us/microsoft-365/compliance/create-sensitivity-labels?view=o365-worldwide#use-powershell-for-sensitivity-labels-and-their-policies
##
## https://learn.microsoft.com/en-us/powershell/module/exchange/new-label?view=exchange-ps
## 
## SAMPLE
## New-Label 
##     -DisplayName "General" 
##     -Name "General" 
##     -Tooltip "Business data that is not intended for public consumption." 
##     -AdvancedSettings @{color="#3A96DD"}
## 
## https://iehpwiki.iehp.org/wiki/Data_Classification_-_Sensitivity_Labels
## 

New-Label -DisplayName "Public" -Name "Public" -AdvancedSettings @{color="#3A96DD"} -Tooltip "Data should be classified as Public when the unauthorized disclosure, alteration or destruction of that data would result in little or no risk to IEHP and its affiliates. Examples of Public data include press releases, training information and summarized/research data that contains no identifiable content. While little or no controls are required to protect the confidentiality of Public data, some level of control is required to prevent unauthorized modification or destruction of Public data."
New-Label -DisplayName "Internal Only" -Name "Internal Only" -AdvancedSettings @{color="#13A10E"} -Tooltip "This type of data is strictly accessible to internal company personnel or internal employees who are granted access. This might include internal-only memos or other communications, business plans, etc."
New-Label -DisplayName "Confidential" -Name "Confidential" -AdvancedSettings @{color="#EAA300"} -Tooltip "Data should be classified as Private when the unauthorized disclosure, alteration or destruction of that data could result in a moderate level of risk to IEHP or its affiliates. By default, all Institutional Data that is not explicitly classified as Restricted or Public data should be treated as Private data.  A reasonable level of security controls should be applied to Private data."
New-Label -DisplayName "Regulated" -Name "Regulated" -AdvancedSettings @{color="#A4262C"} -Tooltip "Data should be classified as Restricted when the unauthorized disclosure, alteration or destruction of that data could cause a significant level of risk to IEHP or its affiliates. Examples of Restricted data include data protected by state or federal privacy regulations and data protected by confidentiality agreements. The highest level of security controls should be applied to Restricted data."


Disconnect-ExchangeOnline
# Disconnect-ExchangeOnline -Confirm:$false

## https://learn.microsoft.com/en-us/microsoft-365/compliance/sit-limits?view=o365-worldwide
