Set-ExecutionPolicy bypass -Force 
Get-ExecutionPolicy

#Name of your SQL Server Alias
# http://www.sharepointdiary.com/2014/09/create-sql-server-alias-using-powershell.html

$AliasName1 = "HALOSQL1\SQL1"
 
# Actual SQL Server Name
$SQLServerName = "EDW.iehp.local\SQL1"
 
#These are the two Registry locations for the SQL Alias
$x86 = "HKLM:\Software\Microsoft\MSSQLServer\Client\ConnectTo"
$x64 = "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo"
 
#if the ConnectTo key doesn't exists, create it.
if ((test-path -path $x86) -ne $True)
{
    New-Item $x86
}
 
if ((test-path -path $x64) -ne $True)
{
    New-Item $x64
}
 
#Define SQL Alias
$TCPAliasName = ("DBMSSOCN," + $SQLServerName)
 
#Create TCP/IP Aliases
New-ItemProperty -Path $x86 -Name $AliasName1 -PropertyType String -Value $TCPAliasName
New-ItemProperty -Path $x64 -Name $AliasName1 -PropertyType String -Value $TCPAliasName


# C:\Windows\System32\cliconfg.exe
# C:\Windows\SysWOW64\cliconfg.exe

Get-ExecutionPolicy
