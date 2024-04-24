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

######################################################################
# ALL OF IT
######################################################################
Get-Label -Identity "e0ff125a-b62b-4b99-8386-c6f3ac22ba12" | Format-List

######################################################################
# GUIDS
######################################################################
Write-Host -ForegroundColor Green "## GUIDS ######################################################################"
Get-Label | Format-Table -Property DisplayName, Name, Guid, ContentType

######################################################################
# PUBLIC
######################################################################
Write-Host -ForegroundColor Green "## PUBLIC ######################################################################"
$guid01 = "e0ff125a-b62b-4b99-8386-c6f3ac22ba12"
#(Get-Label -Identity $guid01).settings
Get-Label -Identity  $guid01 | Format-List GUID,Tooltip,Comment,DisplayName,Name,Settings,LabelActions

######################################################################
# INTERNAL ONLY
######################################################################
Write-Host -ForegroundColor Green "## INTERNAL ONLY ######################################################################"
$guid02 = "6eedf76a-3542-4db6-be0f-1ad84e7b3a41"
#(Get-Label -Identity $guid02).settings
Get-Label -Identity  $guid02| Format-List GUID,Tooltip,Comment,DisplayName,Name,Settings,LabelActions

######################################################################
# CONFIDENTIAL
######################################################################
Write-Host -ForegroundColor Green "## CONFIDENTIAL ######################################################################"
$guid03 = "5dda25ec-7d84-4b48-9e7b-dbd11a368622"
#(Get-Label -Identity $guid03).settings
Get-Label -Identity $guid03 | Format-List GUID,Tooltip,Comment,DisplayName,Name,Settings,LabelActions

######################################################################
# CONFIDENTIAL-ALL EMPLOYEES
######################################################################
Write-Host -ForegroundColor Green "## CONFIDENTIAL-ALL EMPLOYEES ######################################################################"
$guid04 = "2d58fa60-bdbf-4121-9be2-a535e5d5758a"
#(Get-Label -Identity $guid04).settings
Get-Label -Identity $guid04 | Format-List GUID,Tooltip,Comment,DisplayName,Name,Settings,LabelActions

######################################################################
# Confidential-Information Technology
######################################################################
Write-Host -ForegroundColor Green "## Confidential-Information Technology ######################################################################"
$guid05 = "f2192f36-9190-4e01-a8c9-774eb9fd68f6"
#(Get-Label -Identity $guid05).settings
Get-Label -Identity $guid05 | Format-List GUID,Tooltip,Comment,DisplayName,Name,Settings,LabelActions

######################################################################
# Highly Confidential
######################################################################
Write-Host -ForegroundColor Green "## Highly Confidential ######################################################################"
$guid06 = "b7811a0b-511a-495a-95fd-3ce5ae2638d9"
#(Get-Label -Identity $guid06).settings
Get-Label -Identity $guid06 | Format-List GUID,Tooltip,Comment,DisplayName,Name,Settings,LabelActions

######################################################################
# Highly Confidential-All Employees
######################################################################
Write-Host -ForegroundColor Green "## Highly Confidential-All Employees ######################################################################"
$guid07 = "51e5078d-dfb2-40d3-82d2-4b91fa1aaf60"
#(Get-Label -Identity $guid07).settings
Get-Label -Identity $guid07 | Format-List GUID,Tooltip,Comment,DisplayName,Name,Settings,LabelActions

######################################################################
# Highly Confidential-Information Technology
######################################################################
Write-Host -ForegroundColor Green "## Highly Confidential-Information Technology ######################################################################"
$guid08 = "ef3844ad-c263-4a3f-b719-bff6e282915e"
#(Get-Label -Identity $guid08).settings
Get-Label -Identity $guid08 | Format-List GUID,Tooltip,Comment,DisplayName,Name,Settings,LabelActions

Disconnect-ExchangeOnline
