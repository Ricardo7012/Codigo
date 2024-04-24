
Clear-Host

$ServerName = 'PVSQLSAS01'
#ping $ServerName 

Get-WmiObject –class Win32_processor | ft NumberOfCores,NumberOfLogicalProcessors
Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
Get-WmiObject Win32_PhysicalMemory | Select-Object Devicelocator, @{Name = "Capacity, GB "; Expression = {$_.Capacity / 1073741824}};


###Get-WmiObject -Class Win32_Processor -ComputerName . | Select-Object -Property [a-z]* | Out-GridView

Get-WmiObject -Class Win32_Processor -ComputerName $ServerName | Select-Object -Property PSComputerName, DeviceID, SocketDesignation, NumberOfCores,NumberOfLogicalProcessors #| Out-GridView

###Systeminfo /FO CSV | ConvertFrom-CSV | Select 'Host Name', 'Total Physical Memory', 'System Model', 'Processor(s)'
Get-CimInstance -Class CIM_PhysicalMemory -ComputerName $ServerName -ErrorAction Stop | Select-Object Tag, Capacity, TotalWidth #| Out-GridView
#Get-CimInstance -Class CIM_PhysicalMemory -ComputerName $ServerName -ErrorAction Stop | Select-Object * | Out-GridView

##Get-CimInstance -Class CIM_PhysicalMemory -ComputerName $ServerName -ErrorAction Stop | Select-Object 'PSComputerName', 'Caption', 'Capacity', 'Tag', 'DeviceLocator'  | Out-GridView

###Get-PSDrive C | Select-Object Used,Free #KB
#Invoke-Command -ComputerName $ServerName {Get-PSDrive E} | Select-Object PSComputerName, Used, Free

$disk1 = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerName -Filter "DeviceID='C:'" |
Foreach-Object {$_.Size/1073741824}

Write-Host "C:\ : "$disk1 " GB"

$disk2 = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerName -Filter "DeviceID='I:'" |
Foreach-Object {$_.Size/1073741824}

Write-Host "I:\ : "$disk2 " GB"

$disk3 = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerName -Filter "DeviceID='L:'" |
Foreach-Object {$_.Size/1073741824}

Write-Host "L:\ : "$disk3 " GB"

$disk4 = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerName -Filter "DeviceID='T:'" |
Foreach-Object {$_.Size/1073741824}

Write-Host "T:\ : "$disk4 " GB"

$disk5 = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerName -Filter "DeviceID='E:'" |
Foreach-Object {$_.Size/1073741824}

Write-Host "E:\ : "$disk5 " GB"

$disk6 = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerName -Filter "DeviceID='F:'" |
Foreach-Object {$_.Size/1073741824}

Write-Host "F:\ : "$disk6 " GB"