Clear-Host

Write-Host -ForegroundColor green "*************************************************************************************************************************"
Write-Host -ForegroundColor green "***  PowerShell Version ****"
(Get-Host).Version

### https://docs.microsoft.com/en-us/windows/release-health/release-information
### https://docs.microsoft.com/en-US/troubleshoot/windows-server/identity/apps-forcibly-closed-tls-connection-errors#resolution
### https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.2

Write-Host -ForegroundColor green "*************************************************************************************************************************"
Write-Host -ForegroundColor green "*** CsCaption, OsHardwareAbstractionLayer ***"

Invoke-Command -ComputerName `
    QVEDWSQL01, `
    EDWETL01 `
    -ScriptBlock `
{Get-ComputerInfo | `
    Select-Object CsCaption, OsHardwareAbstractionLayer} | `
    Sort-Object CsCaption | Format-Table

#{Get-ComputerInfo | `
#    Sort-Object CsCaption | `
#    Format-Table CsCaption, OsHardwareAbstractionLayer} 

Write-Host -ForegroundColor green "*************************************************************************************************************************"
