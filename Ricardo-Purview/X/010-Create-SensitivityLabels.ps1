#Requires -Modules ExchangeOnlineManagement, MSOnline
#Requires -RunAsAdministrator

<#
###########################################################################
# License / Disclaimer                                                    #
###########################################################################
# MIT License
# Copyright (c) 2021 Microsoft
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#>

Import-Module ExchangeOnlineManagement
Import-Module MSOnline

$Credential = Get-Credential

Connect-IPPSSession -Credential $Credential

Connect-MsolService -Credential $Credential

#region Create the "Public" Sensitivity Label in IEHP tenant with the settings below:
$Tooltip = "Data should be classified as Public when the unauthorized disclosure, alteration or destruction of that data would result in 
little or no risk to IEHP and its affiliates. Examples of Public data include press releases, training information and 
summarized/research data that contains no identifiable content. While little or no controls are required to protect the 
confidentiality of Public data, some level of control is required to prevent unauthorized modification or destruction of Public data."

$Comment = "ADMIN: Data should be classified as Public when the unauthorized disclosure, alteration or destruction of that data would result 
in little or no risk to IEHP and its affiliates. Examples of Public data include press releases, training information and 
summarized/research data that contains no identifiable content. While little or no controls are required to protect the
confidentiality of Public data, some level of control is required to prevent unauthorized modification or destruction of Public data."

New-Label -DisplayName "Public" -Name "Public" -Tooltip $Tooltip -AdvancedSettings @{color="#3A96DD"} -ApplyContentMarkingFooterText "Public" `
-ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#0000FF" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#0000FF" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Public" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $false 
#endregion

#region Create the "Internal Only" Sensitivity Label in IEHP tenant with the settings below:
$Tooltip = "This type of data is strictly accessible to internal company personnel or internal employees who are granted access. This 
might include internal-only memos or other communications, business plans, etc."

$Comment = "ADMIN: This type of data is strictly accessible to internal company personnel or internal employees who are granted access. This 
might include internal-only memos or other communications, business plans, etc."

$DomainName = (Get-MsolDomain | Where-Object {$_.isDefault}).name

New-Label -DisplayName "Internal Only" -Name "Internal Only" -Tooltip $Tooltip -AdvancedSettings @{color="#13A10E"} -ApplyContentMarkingFooterText "Internal Only" `
-ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#008000" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#008000" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Internal Only" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $true -EncryptionPromptUser $false -EncryptionContentExpiredOnDateInDaysOrNever "Never" -EncryptionOfflineAccessDays $false `
-EncryptionProtectionType "Template" -EncryptionRightsDefinitions "$($DomainName):VIEW,VIEWRIGHTSDATA,DOCEDIT,EDIT,PRINT,EXTRACT,REPLY,REPLYALL,FORWARD,OBJMODEL"
#endregion

#region Create the "Confidential" Sensitivity Label in IEHP tenant with the settings below:
$Tooltip = "Data should be classified as Private when the unauthorized disclosure, alteration or destruction of that data could result in a moderate level of risk 
to IEHP or its affiliates. By default, all Institutional Data that is not explicitly classified as Restricted or Public data should be treated as 
Private data.  A reasonable level of security controls should be applied to Private data."

$Comment = "ADMIN: Data should be classified as Private when the unauthorized disclosure, alteration or destruction of that data could result in a moderate level of 
risk to IEHP or its affiliates. By default, all Institutional Data that is not explicitly classified as Restricted or Public data should be treated as 
Private data.  A reasonable level of security controls should be applied to Private data."

New-Label -DisplayName "Confidential" -Name "Confidential" -Tooltip $Tooltip -Comment $Comment -ContentType "File, Email" 

New-Label -DisplayName "Trusted People" -Name "Confidential Trusted People" -Tooltip $Tooltip -ParentId "Confidential" -AdvancedSettings @{Color="#EAA300"; SMimeEncrypt="True"}`
-ApplyContentMarkingFooterText "Confidential" -ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FFFF00" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FFFF00" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Confidential" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $true -EncryptionProtectionType "UserDefined" -EncryptionPromptUser $True -EncryptionDoNotForward $False -EncryptionEncryptOnly $true 

New-Label -DisplayName "Authenticated Users" -Name "Confidential Authenticated Users" -Tooltip $Tooltip -ParentId "Confidential" -AdvancedSettings @{Color="#EAA300"} `
-ApplyContentMarkingFooterText "Confidential" -ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FFFF00" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FFFF00" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Confidential" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $true -EncryptionPromptUser $false -EncryptionContentExpiredOnDateInDaysOrNever "Never" -EncryptionOfflineAccessDays $false `
-EncryptionProtectionType "Template" -EncryptionRightsDefinitions "AuthenticatedUsers:VIEW,VIEWRIGHTSDATA,DOCEDIT,EDIT,REPLY,REPLYALL,FORWARD,OBJMODEL"

#endregion

#region Create the "Regulated" Sensitivity Label in IEHP tenant with the settings below:
$Tooltip = "Data should be classified as Restricted when the unauthorized disclosure, alteration or destruction of that data could cause a significant level of risk 
to IEHP or its affiliates. Examples of Restricted data include data protected by state or federal privacy regulations and data protected by 
confidentiality agreements. The highest level of security controls should be applied to Restricted data."

$Comment = "ADMIN: Data should be classified as Restricted when the unauthorized disclosure, alteration or destruction of that data could cause a significant level 
of risk to IEHP or its affiliates. Examples of Restricted data include data protected by state or federal privacy regulations and data protected by 
confidentiality agreements. The highest level of security controls should be applied to Restricted data."

New-Label -DisplayName "Regulated" -Name "Regulated" -Tooltip $Tooltip -Comment $Comment -ContentType "File, Email" 

New-Label -DisplayName "Trusted People" -Name "Regulated Trusted People" -Tooltip $Tooltip -ParentId "Regulated" -AdvancedSettings @{color="#A4262C"; SMimeEncrypt="True"} `
-ApplyContentMarkingFooterText "Regulated" -ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FF0000" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FF0000" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Regulated" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $true -EncryptionProtectionType "UserDefined" -EncryptionPromptUser $True -EncryptionDoNotForward $True 

New-Label -DisplayName "Authenticated Users" -Name "Regulated Authenticated Users" -Tooltip $Tooltip -ParentId "Regulated" -AdvancedSettings @{color="#A4262C"} `
-ApplyContentMarkingFooterText "Regulated" -ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FF0000" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FF0000" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Regulated" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $true -EncryptionPromptUser $false -EncryptionContentExpiredOnDateInDaysOrNever "Never" -EncryptionOfflineAccessDays $false `
-EncryptionProtectionType "Template" -EncryptionRightsDefinitions "AuthenticatedUsers:VIEW,VIEWRIGHTSDATA,OBJMODEL"

#endregion

#region Publish the four Sensitivity Labels created above,

$DomainName = (Get-MsolDomain | Where-Object {$_.isDefault}).name

$DomainURL = $DomainName.Split(".")[0]

New-LabelPolicy -Name "IEHP Manual Labels" -Labels "Public","Internal Only","Confidential","Confidential Trusted People","Confidential Authenticated Users","Regulated","Regulated Trusted People","Regulated Authenticated Users"  `
-ExchangeLocation "All" -Comment "The IEHP Manual Label Policy will apply the four different labels: Public, Internal Only, Confidential, and Regulated available to all end-users." -Confirm:$False  `
-AdvancedSettings @{powerbimandatory="False"; requiredowngradejustification="True"; mandatory="False";customurl="https://$($DomainURL).sharepoint.com/sites/Design";disablemandatoryinoutlook="True"}
#endregion

Disconnect-ExchangeOnline