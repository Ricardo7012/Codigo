Set-ExecutionPolicy bypass -Force 

#Name of your SQL Server Alias
# http://www.sharepointdiary.com/2014/09/create-sql-server-alias-using-powershell.html

$AliasName1 = "IEHPSQLA1\SQL1"
$AliasName2 = "IEHPSQLB1\SQL2"
$AliasName3 = "IEHPSQLC2\SQL3"
$AliasName4 = "IEHPSQLD2\SQL4"
 
# Actual SQL Server Name
$SQLServerName = "VEGA"
 
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
#Create TCP/IP Aliases2
New-ItemProperty -Path $x86 -Name $AliasName2 -PropertyType String -Value $TCPAliasName
New-ItemProperty -Path $x64 -Name $AliasName2 -PropertyType String -Value $TCPAliasName
#Create TCP/IP Aliases3
New-ItemProperty -Path $x86 -Name $AliasName3 -PropertyType String -Value $TCPAliasName
New-ItemProperty -Path $x64 -Name $AliasName3 -PropertyType String -Value $TCPAliasName
#Create TCP/IP Aliases4
New-ItemProperty -Path $x86 -Name $AliasName4 -PropertyType String -Value $TCPAliasName
New-ItemProperty -Path $x64 -Name $AliasName4 -PropertyType String -Value $TCPAliasName

# C:\Windows\System32\cliconfg.exe
# C:\Windows\SysWOW64\cliconfg.exe

