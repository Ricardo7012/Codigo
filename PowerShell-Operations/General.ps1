Get-PSProvider
Get-ChildItem HKCU:\Console
Get-ChildItem HKLM:
Get-Module -ListAvailable -Name *SQL* 

Import-Module SQLPS

Set-Location "C:"

Get-Command -Module SQLPS

(Get-Command -Module SQLPS).Count

Remove-Module SQLPS

explorer C:\Users\i4682\Downloads

Get-PSProvider

Get-Member -MemberType property 

