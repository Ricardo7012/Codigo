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
    DVSQLCDR01, `
    DVSQLCP01, `
    DVSQLDMI01, `
    DVSQLEDI03, `
    DVSQLEDI04, `
    DVSQLEM, `
    DVSQLFIN01, `
    DVSQLNUANCE01, `
    DVSQLPOL01, `
    DVSQLSIS01, `
    DVSQLSRS01, `
    DVSQLSTRAD, `
    DVSQLSYMED01, `
    HSP2S1A, `
    HSP2S1B, `
    HSP2S1C, `
    HSP3S1A, `
    HSP4S1A, `
    HSP5S1A, `
    IEHPDWDEV, `
    JIVESQLDEV, `
    #JOBSCHEDAPPDEV, `
    MDSDQSDEV, `
    MOHSP1S1A, `
    MOHSP1S1B, `
    MOHSP1S1C, `
    QVDMEM01, `
    QVEDWSQL01, `
    QVMEDIHSP01, `
    QVSQLDMI01, `
    QVSQLEDI01, `
    QVSQLEDI04, `
    QVSQLEM01, `
    QVSQLLIT01, `
    QVSQLSTRAD, `
    #SPDBQA1, `
    VEGADEV, `
    VEGATST, `
    WEBSTRATPPSTST `
{Get-ComputerInfo | Format-Table CsCaption, OsHardwareAbstractionLayer -HideTableHeaders} #| Out-GridView

Write-Host -ForegroundColor green "*************************************************************************************************************************"
