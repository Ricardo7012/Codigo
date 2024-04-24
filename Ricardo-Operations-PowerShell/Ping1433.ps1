## PING 1433

$PSVersionTable.PSVersion

nslookup 172.20.250.140

Test-NetConnection -ComputerName 'vegadev' -Port 1433 -InformationLevel "Detailed" 

#Test-NetConnection -ComputerName 'vegadev' -Port 1433 -Count 5 # Powershell 6.0 or greater

do {
  Test-NetConnection -ComputerName '172.20.250.140' -Port 1433 -InformationLevel "Detailed" 
  Start-Sleep -Seconds 1
  $input = [Console]::ReadLine()
} while ($input -ne "Q")

[Console]::CancelKeyPress += {
  param($sender, $e)
  $e.Cancel = $true # prevent the script from terminating
  Write-Host "You pressed Ctrl+C. Exiting the loop."
  $global:exitLoop = $true # set a global variable to control the loop
}

do {
  Test-NetConnection -ComputerName '172.20.250.140' -Port 1433 -InformationLevel "Detailed" 
  Start-Sleep -Seconds 1
} until ($global:exitLoop)
