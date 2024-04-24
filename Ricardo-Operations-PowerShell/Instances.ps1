## GET SQL INSTANCES

##
Write-Host -ForegroundColor Green "## 1 ######################################################################"
Get-Service | ?{ $_.Name -like "MSSQL*" }


## 
Write-Host -ForegroundColor Green "## 2 ######################################################################"
$srvr = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $computerName
    $instances = $srvr | ForEach-Object {$_.ServerInstances} | Select @{Name="INSTANCE:";Expression={$computerName +"\"+ $_.Name}}   
    return $instances

##
Write-Host -ForegroundColor Green "## 3 ######################################################################"
$MachineName = $env:COMPUTERNAME # Default local computer Replace with server name for a remote computer
$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey(‘LocalMachine’, $MachineName)
$regKey= $reg.OpenSubKey("SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\SQL" )
$values = $regkey.GetValueNames()
$values | ForEach-Object {$value = $_ ; $inst = $regKey.GetValue($value); 
    $path = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\"+$inst+"\\MSSQLServer\\"+"CurrentVersion";
    $version = $reg.OpenSubKey($path).GetValue("CurrentVersion");
    write-host "Instance:" $value;
    write-host  "Version:" $version;}

Write-Host -ForegroundColor Green "## THESE QUERY THE NETWORK FOR DISCOVERABLE SQL SERVERS - TURN OFF BROWSER SERVICE! ##"
## https://www.stigviewer.com/stig/ms_sql_server_2016_instance/2020-09-23/finding/V-214042
## The SQL Server Browser service must be disabled unless specifically required and approved.
Write-Host -ForegroundColor Green "## 4 ######################################################################"
[System.Data.Sql.SqlDataSourceEnumerator]::Instance.GetDataSources()

## 
Write-Host -ForegroundColor Green "## 5 ######################################################################"
OSQL -L

## 
Write-Host -ForegroundColor Green "## 6 ######################################################################"
SQLCMD -L

######################################################################################

## GET SQL INSTANCES VIA SQL SSMS
DECLARE @GetInstances TABLE
( Value nvarchar(100),
 InstanceNames nvarchar(100),
 Data nvarchar(100))

Insert into @GetInstances
EXECUTE xp_regread
  @rootkey = 'HKEY_LOCAL_MACHINE',
  @key = 'SOFTWARE\Microsoft\Microsoft SQL Server',
  @value_name = 'InstalledInstances'

Select InstanceNames from @GetInstances 

SELECT @@SERVERNAME, @@SERVICENAME
