#Requires -Modules ExchangeOnlineManagement
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

# Create a new Auto Sensitivity Label Policy for the Confidential Label
New-AutoSensitivityLabelPolicy -Name "IEHP Confidential" -ApplySensitivityLabel "Confidential Authenticated Users" `
 -ExchangeLocation "All" -OneDriveLocation "All" -SharePointLocation "All" -Mode TestWithoutNotifications -OverwriteLabel $True -Confirm:$False `
 -Comment "The IEHP Confidential Policy will apply the confidential label automaticaly to all end-users documents based on the Sentisitivy Information Types provided inside this policy."

#region Create rules for Exchange Online based on triggers (Sensitive Information Types) and the action will be to apply the Confidential Label
New-AutoSensitivityLabelRule -Name "Confidential-Exchange" -Policy "IEHP Confidential"   `
-Comment "The IEHP Confidential Label Policy will apply automaticaly to all end-users documents based on the Sensitivity Information Types provided inside this policy." `
-ContentContainsSensitiveInformation @(
@{Name="Date of Birth (DOB)"; minCount="1"; minConfidence="65"}
@{Name="IP Address"; minCount="1"; minConfidence="85"}
@{Name="IP Address v4"; minCount="1"; minConfidence="75"}
@{Name="IP Address v6"; minCount="1"; minConfidence="75"}
@{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; minCount="1"; minConfidence="75"}
@{Name="U.S. Bank Account Number"; minCount="1"; minConfidence="75"}
@{Name="ABA Routing Number"; minCount="1"; minConfidence="75"}
) -Workload "Exchange" -Confirm:$false
#endregion

#region Create rules for Sharepoint Online based on triggers (Sensitive Information Types) and the action will be to apply the Confidential Label
New-AutoSensitivityLabelRule -Name "Confidential-Sharepoint" -Policy "IEHP Confidential" `
-Comment "The IEHP Confidential Label Policy will apply automaticaly to all end-users documents based on the Sentisitivy Information Types provided inside this policy." `
-ContentContainsSensitiveInformation @(
@{Name="Date of Birth (DOB)"; minCount="1"; minConfidence="65"}
@{Name="IP Address"; minCount="1"; minConfidence="85"}
@{Name="IP Address v4"; minCount="1"; minConfidence="75"}
@{Name="IP Address v6"; minCount="1"; minConfidence="75"}
@{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; minCount="1"; minConfidence="75"}
@{Name="U.S. Bank Account Number"; minCount="1"; minConfidence="75"}
@{Name="ABA Routing Number"; minCount="1"; minConfidence="75"}
) -Workload "SharePoint" -Confirm:$false
#endregion

#region Create rules for OneDriveForBusiness based on triggers (Sensitive Information Types) and the action will be to apply the Confidential Label
New-AutoSensitivityLabelRule -Name "Confidential-OneDriveForBusiness" -Policy "IEHP Confidential" `
-Comment "The IEHP Confidential Label Policy will apply automaticaly to all end-users documents based on the Sentisitivy Information Types provided inside this policy." `
-ContentContainsSensitiveInformation @(
@{Name="Date of Birth (DOB)"; minCount="1"; minConfidence="65"}
@{Name="IP Address"; minCount="1"; minConfidence="85"}
@{Name="IP Address v4"; minCount="1"; minConfidence="75"}
@{Name="IP Address v6"; minCount="1"; minConfidence="75"}
@{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; minCount="1"; minConfidence="75"}
@{Name="U.S. Bank Account Number"; minCount="1"; minConfidence="75"}
@{Name="ABA Routing Number"; minCount="1"; minConfidence="75"}
) -Workload "OneDriveForBusiness" -Confirm:$false
#endregion

# Create a new Auto Sensitivity Label Policy for the Highly Confidential Label
New-AutoSensitivityLabelPolicy -Name "IEHP Highly Confidential" -ApplySensitivityLabel "Highly Confidential Authenticated Users" `
 -ExchangeLocation "All" -OneDriveLocation "All" -SharePointLocation "All" -Mode TestWithoutNotifications -OverwriteLabel $True -Confirm:$False `
 -Comment "The IEHP Confidential Policy will apply the confidential label automaticaly to all end-users documents based on the Sentisitivy Information Types provided inside this policy."

#region Create rules for Exchange Online based on triggers (Sensitive Information Types) and the action will be to apply the Highly Confidential Label
New-AutoSensitivityLabelRule -Name "Highly Confidential-Exchange" -Policy "IEHP Highly Confidential"   `
-Comment "The IEHP Confidential Label Policy will apply automaticaly to all end-users documents based on the Sentisitivy Information Types provided inside this policy." `
-ContentContainsSensitiveInformation @(
@{Name="IEHP Member Number"; minCount="1"; minConfidence="65"}
@{Name="U.S. Social Security Number (SSN)"; minCount="1"; minConfidence="75"}
@{Name="U.S. Driver's License Number"; minCount="1"; minConfidence="75"}
@{Name="Ethnicity"; minCount="1"; minConfidence="85"}
) -Workload "Exchange" -Confirm:$false
#endregion

#region Create rules for Sharepoint Online based on triggers (Sensitive Information Types) and the action will be to apply the Highly Confidential Label
New-AutoSensitivityLabelRule -Name "Highly Confidential-Sharepoint" -Policy "IEHP Highly Confidential" `
-Comment "The IEHP Confidential Label Policy will apply automaticaly to all end-users documents based on the Sentisitivy Information Types provided inside this policy." `
-ContentContainsSensitiveInformation @(
@{Name="IEHP Member Number"; minCount="1"; minConfidence="65"}
@{Name="U.S. Social Security Number (SSN)"; minCount="1"; minConfidence="75"}
@{Name="U.S. Driver's License Number"; minCount="1"; minConfidence="75"}
@{Name="Ethnicity"; minCount="1"; minConfidence="85"}
) -Workload "SharePoint" -Confirm:$false
#endregion

#region Create rules for OneDriveForBusiness based on triggers (Sensitive Information Types) and the action will be to apply the Highly Confidential Label
New-AutoSensitivityLabelRule -Name "Highly Confidential-OneDriveForBusiness" -Policy "IEHP Highly Confidential" `
-Comment "The IEHP Confidential Label Policy will apply automaticaly to all end-users documents based on the Sentisitivy Information Types provided inside this policy." `
-ContentContainsSensitiveInformation @(
@{Name="IEHP Member Number"; minCount="1"; minConfidence="65"}
@{Name="U.S. Social Security Number (SSN)"; minCount="1"; minConfidence="75"}
@{Name="U.S. Driver's License Number"; minCount="1"; minConfidence="75"}
@{Name="Ethnicity"; minCount="1"; minConfidence="85"}
) -Workload "OneDriveForBusiness" -Confirm:$false
#endregion

Disconnect-ExchangeOnline