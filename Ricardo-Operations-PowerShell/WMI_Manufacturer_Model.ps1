CLS
Clear-Host
$ArrComputers = ""
$ArrComputers = ".", "IEHP-PM160", "IEHPHEDIS"

Clear-Host
foreach ($Computer in $ArrComputers) 
{
    $computerSystem = get-wmiobject Win32_ComputerSystem -Computer $Computer
    $computerBIOS = get-wmiobject Win32_BIOS -Computer $Computer
    $computerOS = get-wmiobject Win32_OperatingSystem -Computer $Computer
    $computerCPU = get-wmiobject Win32_Processor -Computer $Computer
    $computerNumberCPU = Get-WmiObject -Class Win32_Processor -Computer $Computer | Select-Object -Property Name, Number*
    $computerHDD = Get-WmiObject Win32_LogicalDisk -ComputerName $Computer -Filter drivetype=3
        write-host "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
        "-------------------------------------------------------"
        "Manufacturer: " + $computerSystem.Manufacturer
        "Model: " + $computerSystem.Model
        "Serial Number: " + $computerBIOS.SerialNumber
        "CPU: " + $computerCPU.Name
        "NumberCPUs: " + $computerNumberCPU
        "HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
        "HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
        "RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
        "Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
        "User logged In: " + $computerSystem.UserName
        "Last Reboot: " + $computerOS.ConvertToDateTime($computerOS.LastBootUpTime)
        ""
        "-------------------------------------------------------"
}

Get-WmiObject –class Win32_processor -ComputerName "IEHP-PM160"| ft systemname,Name,DeviceID,NumberOfCores,NumberOfLogicalProcessors, Addresswidth

get-wmiobject Win32_ComputerSystem -computer hsp4s1a | select Name,NumberOfProcessors,NumberOfLogicalProcessors, @{name="TotalPhysicalMemory(MB)";expression={($_.TotalPhysicalMemory/1mb).tostring("N0")}} #| export-csv C:\ram-cpu.csv


Write-Host "************************************************************************"
$ComputerName = "TALLAN04"
get-wmiobject Win32_ComputerSystem -computer $ComputerName | select Name,NumberOfProcessors,NumberOfLogicalProcessors, @{name="TotalPhysicalMemory(MB)";expression={($_.TotalPhysicalMemory/1mb).tostring("N0")}} #| export-csv C:\ram-cpu.csv
Write-Host $ComputerName
Get-WmiObject -class Win32_volume -ComputerName $ComputerName -filter "DriveType = 3" | select name, @{Name="Capacity";Expression={$_.capacity / 1GB}}#,@{Name="freespace";Expression={$_.freespace / 1GB}}
Write-Host "************************************************************************"
