﻿#Requires -Modules ExchangeOnlineManagement
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

$Credential = Get-Credential

Connect-IPPSSession -Credential $Credential

Get-DlpSensitiveInformationTypeRulePackage

# Remove ALL Custom Sensitivity Information Types (SITs)
Get-DlpSensitiveInformationTypeRulePackage -Identity "Microsoft.SCCManaged.CustomRulePack" | Remove-DlpSensitiveInformationTypeRulePackage -Confirm:$False

# TEST: YOU SHOULD ONLY SEE Publisher: Microsoft Corporation
# REFRESH PAGE https://compliance.microsoft.com/dataclassificationclassifiers?viewid=sensitiveinfotypes 
# Get-DlpSensitiveInformationTypeRulePackage

#Disconnect-ExchangeOnline