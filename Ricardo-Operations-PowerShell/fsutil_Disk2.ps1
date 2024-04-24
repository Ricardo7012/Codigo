## https://support.purestorage.com/Solutions/Microsoft_Platform_Guide/sss_Windows_Server_Features_and_Integrations/File_Systems
 
$env:COMPUTERNAME
Get-Date

Write-Host -ForegroundColor Green "###################################################"

#The Blocksize output BELOW represents the physical block size at which the Pure Storage FlashArray is writing data. 
Get-WmiObject -Class Win32_DiskPartition -ComputerName $env:COMPUTERNAME | select Name, NumberOfBlocks, Size, StartingOffset, Blocksize | Format-Table -AutoSize
Write-Host -ForegroundColor Green "###################################################"

# The BlockSize (cluster size or allocation unit size) output BELOW represents the logical block size that is used for the formatting of the file system, ReFS or NTFS
Get-WmiObject -Class Win32_Volume -ComputerName $env:COMPUTERNAME | Select BlockSize, Name, FileSystem | Format-Table -AutoSize
Write-Host -ForegroundColor Green "###################################################"

## https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/fsutil
fsutil fsinfo ntfsinfo E:\
Write-Host -ForegroundColor Green "###################################################"
fsutil fsinfo sectorinfo E:

## https://docs.microsoft.com/en-us/powershell/module/storage/get-physicaldisk?view=windowsserver2019-ps
Get-PhysicalDIsk | Get-StorageReliabilityCounter |  Select-Object DeviceID, Temperature
Write-Host -ForegroundColor Green "################################################### > 0 indicates stress"

##
Get-PhysicalDisk –FriendlyName PhysicalDisk1 |  Get-StorageReliabilityCounter
Write-Host -ForegroundColor Green "###################################################"

## https://www.sqlskills.com/blogs/paul/using-diskpart-and-wmic-to-check-disk-partition-alignment/
## 

## https://docs.microsoft.com/en-us/powershell/module/storage/get-partition?view=windowsserver2019-ps 
## Offset
## Specifies the starting offset, in bytes
Get-Partition

## https://houseofbrick.com/improve-performance-as-part-of-a-sql-server-install/ 
