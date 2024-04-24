
###############################################################################
#cd \
#cd "C:\Users\sqladmin9\Downloads\Powershell"
#cls

# Install-SQL
# Unattended installation of SQL Server 
#
# Last Update: 08/22/2019 RF
# 
# REMEMBER TO ADD THE SERVER TO THE CORRECT AD GROUPS
# RUN AS ADMINISTRATOR
# Set-ExecutionPolicy unrestricted -force
# .\03-InstallSQL_OG.ps1 -DOMAIN "IEHP"
###############################################################################
[CmdletBinding(SupportsShouldProcess=$True)]
Param(
[Parameter(
Mandatory=$True,
Position=0)]
[ValidateSet("IEHP")]
[string]$Domain,
[Parameter()]
[switch]$Sharepoint
)
Begin {
###############################################################################
# Utility Functions
###############################################################################
Function Test-InstallFiles
{
$InstallFiles = $null
if ( Test-Path "$InstallPath" )
{
$InstallFiles = $True
}
else
{
$InstallFiles = $False
}
Write-Log "InstallFiles: $InstallFiles"
return $InstallFiles
}
Function Get-LocalComputerName
{
try
{
$LocalComputerName = Get-WmiObject -Class Win32_ComputerSystem
Write-Log "LocalComputerName: $($LocalComputerName.Name)"
return $LocalComputerName.Name
}
catch
{
Write-Warning "Unable to make WMI Query for Get-LocalComputerName"
Write-Debug ($_ | Out-String)
Write-Log ($_ | Out-String)
}
}
Function Write-Log 
{
[cmdletbinding()]
Param(
[Parameter(Position=0)]
[ValidateNotNullOrEmpty()]
[string]$Message,
[Parameter(Position=1)]
[string]$Path="$loggingFilePreference"
)
#Pass on the message to Write-Verbose if -Verbose was detected
Write-Verbose $Message
#only write to the log file if the $LoggingPreference variable is set to Continue
if ($LoggingPreference -eq "Continue")
{
#if a $loggingFilePreference variable is found in the scope
#hierarchy then use that value for the file, otherwise use the default
#$path
if ($loggingFilePreference)
{
$LogFile=$loggingFilePreference
}
else
{
$LogFile=$Path
}
Write-Output "$(Get-Date) $Message" | Out-File -FilePath $LogFile -Append
}
} #end function
}
Process
{
Set-ExecutionPolicy unrestricted -force
$ComputerName = "$Env:ComputerName"
Set-Variable -Name STARTTIME -Value $(Get-Date) -Scope Script
Set-Variable -Name InstallPath -Value "D:\" -Scope Script
Set-Variable -Name LoggingPreference -Value "Continue" -Scope Script
Set-Variable -Name loggingFilePreference -Value "E:\SQL_Install_Log.txt" -Scope Script 
Set-Variable -Name SQLVersion -Value "SQL Server 2016 Enterprise Edition" -Scope Script

switch ($Domain) {
"IEHP" {
Set-Variable -Name AdminAccount -Value "$Domain\" -Scope Script
Set-Variable -Name SQLSysAdminAccounts -Value "IEHP\_sqladmins" -Scope Script
Set-Variable -Name SaPwd -Value "" -Scope Script
Set-Variable -Name SQLSVCACCOUNT -Value "$Domain\" -Scope Script
Set-Variable -Name SQLSVCPASSWORD -Value "" -Scope Script
Set-Variable -Name AGTSVCACCOUNT -Value "$Domain\" -Scope Script
Set-Variable -Name AGTSVCPASSWORD -Value "" -Scope Script

}
}
if ($Sharepoint) {
# Do something because -Sharepoint was specified.
# Maybe have a $command string, and then tack on
# /SQLCOLLATION="LATIN1_General_CI_AS_KS_WS" to the end.
}
Set-Variable -Name InstallFiles -Value $(Test-InstallFiles) -Option ReadOnly -Scope Script
# VISUALLY CONFIRM ALL VARIABLES
Write-Host -ForegroundColor Green "Start: $STARTTIME"
Write-Host -ForegroundColor Green "ComputerName: $ComputerName"
Write-Host -ForegroundColor Green "InstallFiles: $InstallFiles"
Write-Host -ForegroundColor Green "LoggingPreference: $LoggingPreference"
Write-Host -ForegroundColor Green "loggingFilePreference: $loggingFilePreference"
Write-Host -ForegroundColor Green "SQLVersion: $SQLVersion"
Write-Host -ForegroundColor Green "InstallPath: $InstallPath"
Write-Host -ForegroundColor Green "AdminAcct: $AdminAccount"
Write-Host -ForegroundColor Green "SQLSysAdminAccounts: $SQLSysAdminAccounts"
Write-Host -ForegroundColor Green "SaPwd: $SaPwd"
Write-Host -ForegroundColor Green "Domain: $Domain"

Write-Host -ForegroundColor Green "SQLSVCACCOUNT: $SQLSVCACCOUNT"
Write-Host -ForegroundColor Green "SQLSVCPASSWORD: $SQLSVCPASSWORD"
Write-Host -ForegroundColor Green "AGTSVCACCOUNT: $AGTSVCACCOUNT"
Write-Host -ForegroundColor Green "AGTSVCPASSWORD: $AGTSVCPASSWORD"

Write-Log "$('#' * 80)"
Write-Log "ComputerName: $Env:ComputerName"
Write-Log "Start: $STARTTIME" 
Write-Log "InstallFiles: $InstallFiles"
If ( $InstallFiles )
{
Write-Host -ForegroundColor Green "$SQLVersion Installing: $InstallFiles"
Write-Host -ForegroundColor Black ""
Write-Log "$SQLVersion Installing: $InstallFiles"
Start-sleep 5
Push-Location 
cd\
cd $InstallPath
#http://msdn.microsoft.com/en-us/library/ms144259%28v=SQL.100%29.aspx#Feature
#https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-from-the-command-prompt?view=sql-server-2017
        ./Setup.exe /qs `
        /Action=install `
        /instanceID="MSSQLSERVER" `
        /InstanceName="MSSQLSERVER" `
        /IacceptSQLServerLicenseTerms=1 `
        /Features="SQLENGINE" `
        /SQLSysAdminAccounts="$SQLSysAdminAccounts" `
        /SecurityMode="SQL" `
        /SaPwd="$SaPwd" `
        /TCPEnabled=1 `
        /SQMREPORTING="False" `
        /ERRORREPORTING="False" `
        /INSTALLSHAREDWOWDIR="I:\Program Files (x86)" `
        /INSTANCEDIR="I:\Program Files" `
        /INSTALLSHAREDDIR="I:\Program Files" `
        /INSTALLSQLDATADIR="I:\" `
        /SQLUSERDBDIR="E:\Data" `
        /SQLUSERDBLOGDIR="L:\Log" `
        /SQLBACKUPDIR="E:\Backup" `
        /SQLTEMPDBDIR="T:\TempDB" `
        /SQLTEMPDBLOGDIR="T:\TempDB" `
        /SQLTEMPDBFILECOUNT="1" `
        /SQLSVCACCOUNT="$SQLSVCACCOUNT" `
        /SQLSVCPASSWORD="$SQLSVCPASSWORD" `
        /AGTSVCACCOUNT="$AGTSVCACCOUNT" `
        /AGTSVCPASSWORD="$AGTSVCPASSWORD" `
        /SQLSVCSTARTUPTYPE="automatic" `
        /AGTSVCSTARTUPTYPE="automatic" `
        /SQLSVCINSTANTFILEINIT="true" `
        /INDICATEPROGRESS
        Pop-Location
}
else
{
Write-Log "$SQLVersion Installed: $InstallFiles"
Write-Host -ForegroundColor Red "$SQLVersion not installed"
}
Set-Variable -Name ENDTIME -Value $(Get-Date) #-Option Constant
Set-Variable -Name ELAPSEDTIME -Value $($ENDTIME - $STARTTIME) -Option Constant
Write-Log "Completed: $EndTime"
Write-Log "Elapsed Time: $ELAPSEDTIME"
Write-Log "$('#' * 80)"
}
End {
}
