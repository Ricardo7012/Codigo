#Requires -Modules ExchangeOnlineManagement, MSOnline
#Requires -RunAsAdministrator
## https://learn.microsoft.com/en-us/powershell/module/exchange/set-label?view=exchange-ps
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

#####################################################################################
#region Create the "Public" Sensitivity Label in IEHP tenant with the settings below:
#####################################################################################
$Tooltip = "Public information is information that has been approved for release to the general public and is freely shareable both internally and externally. NO DAMAGE would occur if Public information were to become available to parties either internal or external to IEHP. Impact would not be damaging or a risk to business operations."
$Comment = "ADMIN: Public information is information that has been approved for release to the general public and is freely shareable both internally and externally. NO DAMAGE would occur if Public information were to become available to parties either internal or external to IEHP. Impact would not be damaging or a risk to business operations."

New-Label -DisplayName "Public" -Name "Public" -Tooltip $Tooltip -AdvancedSettings @{color="#3A96DD"} -ApplyContentMarkingFooterText "Public" `
-ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#0000FF" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#0000FF" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Public" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $false 
#endregion
#####################################################################################

#####################################################################################
#region Create the "Internal Only" Sensitivity Label in IEHP tenant with the settings below:
#####################################################################################
$Tooltip = "Internal Use information is information originated or owned by IEHP or entrusted to it by others. Internal Use information may be shared with authorized employees, contractors and business partners who have a business need, but may not be released to the general public, due to the negative impact it might have on the company’s business interests. MINIMAL or NO DAMAGE would occur if Internal Use information were to become available to unauthorized parties either internal or external to IEHP. Impact could include damaging the company’s reputation and violating contractual requirements."
$Comment = "ADMIN: Internal Use information is information originated or owned by IEHP or entrusted to it by others. Internal Use information may be shared with authorized employees, contractors and business partners who have a business need, but may not be released to the general public, due to the negative impact it might have on the company’s business interests. MINIMAL or NO DAMAGE would occur if Internal Use information were to become available to unauthorized parties either internal or external to IEHP. Impact could include damaging the company’s reputation and violating contractual requirements."

New-Label -DisplayName "Internal Only" -Name "Internal Only" -Tooltip $Tooltip -AdvancedSettings @{color="#3A96DD"} -ApplyContentMarkingFooterText "Internal Only" `
-ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#008000" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#008000" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Internal Only" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $false 
#endregion
#####################################################################################

#####################################################################################
##region Create the "" Sensitivity Label in IEHP tenant with the settings below:
#####################################################################################
#$Tooltip = "Confidential information is highly-valuable, sensitive business information and the level of protection is dictated internally by IEHP. MODERATE DAMAGE would occur if Confidential information were to become available to unauthorized parties either internal or external to IEHP. Impact could include negatively affecting IEHP’s competitive position, damaging the company’s reputation, violating contractual requirements and exposing the geographic location of individuals."
#$Comment = "ADMIN: Confidential information is highly-valuable, sensitive business information and the level of protection is dictated internally by IEHP. MODERATE DAMAGE would occur if Confidential information were to become available to unauthorized parties either internal or external to IEHP. Impact could include negatively affecting IEHP’s competitive position, damaging the company’s reputation, violating contractual requirements and exposing the geographic location of individuals."
#
#$DomainName = (Get-MsolDomain | Where-Object {$_.isDefault}).name
#
#New-Label -DisplayName "Internal Only" -Name "Internal Only" -Tooltip $Tooltip -AdvancedSettings @{color="#13A10E"} -ApplyContentMarkingFooterText "Internal Only" `
#-ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#008000" `
#-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
#-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#008000" -ApplyContentMarkingHeaderFontSize "10" `
#-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Internal Only" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
#-EncryptionEnabled $true -EncryptionPromptUser $false -EncryptionContentExpiredOnDateInDaysOrNever "Never" -EncryptionOfflineAccessDays $false `
#-EncryptionProtectionType "Template" -EncryptionRightsDefinitions "$($DomainName):VIEW,VIEWRIGHTSDATA,DOCEDIT,EDIT,PRINT,EXTRACT,REPLY,REPLYALL,FORWARD,OBJMODEL"
##endregion
#####################################################################################

#####################################################################################
#region Create the "Confidential" Sensitivity Label in IEHP tenant with the settings below:
#####################################################################################
$Tooltip = "Confidential information is highly-valuable, sensitive business information and the level of protection is dictated internally by IEHP. MODERATE DAMAGE would occur if Confidential information were to become available to unauthorized parties either internal or external to IEHP. Impact could include negatively affecting IEHP’s competitive position, damaging the company’s reputation, violating contractual requirements and exposing the geographic location of individuals."
$Comment = "ADMIN: Confidential information is highly-valuable, sensitive business information and the level of protection is dictated internally by IEHP. MODERATE DAMAGE would occur if Confidential information were to become available to unauthorized parties either internal or external to IEHP. Impact could include negatively affecting IEHP’s competitive position, damaging the company’s reputation, violating contractual requirements and exposing the geographic location of individuals."

New-Label -DisplayName "Confidential" -Name "Confidential" -Tooltip $Tooltip -Comment $Comment -ContentType "File, Email" 

New-Label -DisplayName "All Employees" -Name "Confidential-All Employees" -Tooltip $Tooltip -ParentId "Confidential" -AdvancedSettings @{Color="#EAA300"; SMimeEncrypt="False"}`
-ApplyContentMarkingFooterText "Confidential" -ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FFFF00" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FFFF00" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Confidential" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $false -EncryptionProtectionType "UserDefined" -EncryptionPromptUser $True -EncryptionDoNotForward $False -EncryptionEncryptOnly $true 

New-Label -DisplayName "Information Technology" -Name "Confidential-Information Technology" -Tooltip $Tooltip -ParentId "Confidential" -AdvancedSettings @{Color="#EAA300"} `
-ApplyContentMarkingFooterText "Confidential" -ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FFFF00" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FFFF00" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Confidential" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $false -EncryptionPromptUser $false -EncryptionContentExpiredOnDateInDaysOrNever "Never" -EncryptionOfflineAccessDays 0 `
-EncryptionProtectionType "Template" -EncryptionRightsDefinitions "AuthenticatedUsers:VIEW,VIEWRIGHTSDATA,DOCEDIT,EDIT,REPLY,REPLYALL,FORWARD,OBJMODEL"

#endregion
#####################################################################################

#####################################################################################
#region Create the "Highly Confidential" Sensitivity Label in IEHP tenant with the settings below:
#####################################################################################
$Tooltip = "Highly Confidential information is highly-valuable, highly-sensitive business information and the level of protection is dictated externally by legal and / or contractual requirements. Highly confidential information must be limited to only authorized employees, contractors and business partners with a specific business need. SIGNIFICANT DAMAGE would occur if Highly confidential information were to become available to unauthorized parties either internal or external to IEHP. Impact could include negatively affecting IEHP’s competitive position, violating regulatory requirements, damaging the company’s reputation, violating contractual requirements and posing an identity theft risk."
$Comment = "ADMIN: Highly Confidential information is highly-valuable, highly-sensitive business information and the level of protection is dictated externally by legal and / or contractual requirements. Highly confidential information must be limited to only authorized employees, contractors and business partners with a specific business need. SIGNIFICANT DAMAGE would occur if Highly confidential information were to become available to unauthorized parties either internal or external to IEHP. Impact could include negatively affecting IEHP’s competitive position, violating regulatory requirements, damaging the company’s reputation, violating contractual requirements and posing an identity theft risk."

New-Label -DisplayName "Highly Confidential" -Name "Highly Confidential" -Tooltip $Tooltip -Comment $Comment -ContentType "File, Email" 

New-Label -DisplayName "All Employees" -Name "Highly Confidential-All Employees" -Tooltip $Tooltip -ParentId "Highly Confidential" -AdvancedSettings @{color="#A4262C"; SMimeEncrypt="False"} `
-ApplyContentMarkingFooterText "Highly Confidential" -ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FF0000" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FF0000" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Highly Confidential" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $false -EncryptionProtectionType "UserDefined" -EncryptionPromptUser $True -EncryptionDoNotForward $True 

New-Label -DisplayName "Information Technology" -Name "Highly Confidential-Information Technology" -Tooltip $Tooltip -ParentId "Highly Confidential" -AdvancedSettings @{color="#A4262C"} `
-ApplyContentMarkingFooterText "Highly Confidential" -ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FF0000" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FF0000" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "Highly Confidential" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $false -EncryptionPromptUser $false -EncryptionContentExpiredOnDateInDaysOrNever "Never" -EncryptionOfflineAccessDays 0 `
-EncryptionProtectionType "Template" -EncryptionRightsDefinitions "AuthenticatedUsers:VIEW,VIEWRIGHTSDATA,OBJMODEL"

#endregion
#####################################################################################

#####################################################################################
#region Publish the four Sensitivity Labels created above,
#####################################################################################

$DomainName = (Get-MsolDomain | Where-Object {$_.isDefault}).name

$DomainURL = $DomainName.Split(".")[0]

New-LabelPolicy -Name "IEHP Manual Labels" -Labels "Public","Internal Only","Confidential","Confidential-All Employees","Confidential-Information Technology","Highly Confidential","Highly Confidential-All Employees","Highly Confidential-Information Technology"  `
-ExchangeLocation "All" -Comment "The IEHP Manual Label Policy will apply the four different labels: Public, Internal Only, Confidential, and Highly Confidential available to all end-users." -Confirm:$False  `
-AdvancedSettings @{powerbimandatory="False"; requiredowngradejustification="True"; mandatory="False";customurl="https://$($DomainURL).sharepoint.com/sites/Design";disablemandatoryinoutlook="True"}
#endregion
#####################################################################################

Disconnect-ExchangeOnline

## VALIDATE
## Get-AutoSensitivityLabelPolicy | FL *
## Enabled                             : True
## DistributionStatus                  : Pending