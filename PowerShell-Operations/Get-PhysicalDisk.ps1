cls
Get-Disk
Get-PhysicalDisk
Get-Disk 3 | Get-StorageReliabilityCounter
Get-Disk 4 | Get-StorageReliabilityCounter
Get-PhysicalDisk -FriendlyName PhysicalDisk5 |  Get-StorageReliabilityCounter
Get-PhysicalDIsk | Get-StorageReliabilityCounter |  Select-Object DeviceID, Temperature