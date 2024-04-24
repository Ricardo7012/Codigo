# Requires -Modules ExchangeOnlineManagement, MSOnline
# Requires -RunAsAdministrator

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
#Import-Module MSOnline

$Credential = Get-Credential

Connect-IPPSSession -Credential $Credential

#Connect-MsolService -Credential $Credential

#region Create the "Public" Sensitivity Label in IEHP tenant with the settings below:
$Tooltip = "TOP TOP SECRET TEST TOOLTIP."

$Comment = "ADMIN: TOP TOP SECRET TEST ADMIN COMMENT"

New-Label -DisplayName "TOPSECRET" -Name "TOPSECRET" -Tooltip $Tooltip -AdvancedSettings @{color="#FF0000"} -ApplyContentMarkingFooterText "TOPSECRET" `
-ApplyContentMarkingFooterAlignment "Left" -ApplyContentMarkingFooterEnabled $true -ApplyContentMarkingFooterFontColor "#FF0000" `
-ApplyContentMarkingFooterFontSize "10" -ApplyContentMarkingFooterMargin "5" -ApplyContentMarkingHeaderAlignment "Right" `
-ApplyContentMarkingHeaderEnabled $true -ApplyContentMarkingHeaderFontColor "#FF0000" -ApplyContentMarkingHeaderFontSize "10" `
-ApplyContentMarkingHeaderMargin "5" -ApplyContentMarkingHeaderText "TOPSECRET" -Comment $Comment -Confirm:$false -ContentType "File, Email" `
-EncryptionEnabled $false 
#endregion

#region Publish the four Sensitivity Labels created above,

$DomainName = (Get-MsolDomain | Where-Object {$_.isDefault}).name

$DomainURL = $DomainName.Split(".")[0]

#endregion

Disconnect-ExchangeOnline