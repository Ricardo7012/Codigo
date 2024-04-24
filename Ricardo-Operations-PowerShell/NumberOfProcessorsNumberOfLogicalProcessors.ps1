
Write-Host "************************************************************************"
$ComputerName = "PVLICHSP01"
get-wmiobject Win32_ComputerSystem -computer $ComputerName | select Name,NumberOfProcessors,NumberOfLogicalProcessors, @{name="TotalPhysicalMemory(MB)";expression={($_.TotalPhysicalMemory/1mb).tostring("N0")}} #| export-csv C:\ram-cpu.csv
Write-Host $ComputerName
Get-WmiObject -class Win32_volume -ComputerName $ComputerName -filter "DriveType = 3" | select name, @{Name="Capacity";Expression={$_.capacity / 1GB}}#,@{Name="freespace";Expression={$_.freespace / 1GB}}
Write-Host "************************************************************************"
