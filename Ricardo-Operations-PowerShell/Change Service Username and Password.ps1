Write-Host -ForegroundColor Green "###################################################"
 
$serviceCred = Get-Credential "IEHP\PREDSVC01"
Set-ServiceCredential `
  "SQL Backup Agent" `
  -ServiceCredential $serviceCred `
  -Confirm:$false
 
Write-Host -ForegroundColor Green "###################################################"
 
cls
Get-Service -DisplayName 'SQL Backup Agent' 
Get-WMIObject -Class Win32_Service -Filter  "Name='SQLBackupAgent'" | Select-Object Name, DisplayName, StartMode, Status, StartName 
 
# Change service user name and password 
# www.morgantechce.com
#
$UserName = "iehp\PREDSVC01" 
$Password = ""
$Service = "SQLBackupAgent" #Change your own service name
$svc_Obj= Get-WmiObject Win32_Service -filter "name='$service'"
$StopStatus = $svc_Obj.StopService() 
If ($StopStatus.ReturnValue -eq "0") 
    {Write-host "The service '$Service' Stopped successfully"} 
$ChangeStatus = $svc_Obj.change($null,$null,$null,$null,$null,
                      $null, $UserName,$Password,$null,$null,$null)
If ($ChangeStatus.ReturnValue -eq "0")  
    {Write-host "User Name sucessfully for the service '$Service'"} 
$StartStatus = $svc_Obj.StartService() 
If ($ChangeStatus.ReturnValue -eq "0")  
    {Write-host "The service '$Service' Started successfully"} 
 
 
 
Write-Host -ForegroundColor Green "###################################################"
 
# Change service username and password in Remote Computer
# www.morgantechspace.com
#
 
 
$UserName = "iehp\PREDSVC01" 
$Password = ""
$Service = "SQLBackupAgent" #Change your own service name
$computer = "HSP2X1A" #Change your own server/computer name
Write-Host -ForegroundColor Green $computer
Get-WMIObject -Class Win32_Service -Filter  "Name='SQLBackupAgent'" | Select-Object Name, DisplayName, StartMode, Status, StartName 
 
Get-Service -DisplayName 'SQL Backup Agent' -ComputerName $computer
 
#Prompt you for user name and password to access remote computer 
$Cred = Get-Credential "IEHP\PREDSVC01"
$svc_Obj= Get-WmiObject Win32_Service -ComputerName $computer -filter "name='$service'" -Credential $cred
$StopStatus = $svc_Obj.StopService() 
If ($StopStatus.ReturnValue -eq "0") 
    {Write-host "The service '$Service' Stopped successfully in $computer"} 
$ChangeStatus = $svc_Obj.change($null,$null,$null,$null,$null,
                    $null,$UserName,$Password,$null,$null,$null)
If ($ChangeStatus.ReturnValue -eq "0")  
    {Write-host "User Name sucessfully for the service '$Service' in $computer"} 
$StartStatus = $svc_Obj.StartService() 
If ($ChangeStatus.ReturnValue -eq "0")  
    {Write-host "The service '$Service' Started successfully in $computer"} 
 
Get-WMIObject -Class Win32_Service -Filter  "Name='SQLBackupAgent'" | Select-Object Name, DisplayName, StartMode, Status, StartName 
