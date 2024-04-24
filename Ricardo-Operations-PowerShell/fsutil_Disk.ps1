CLS
#### fsutil
### https://blog.sqlserveronline.com/2017/12/08/sql-server-64kb-allocation-unit-size/#:~:text=There%20are%20really%20good%20whitepapers%20with%20a%20recommendation,fsutil%20fsinfo%20ntfsinfo%20c%3A%20fsutil%20fsinfo%20ntfsinfo%20d%3A
### http://www.eraofdata.com/sql-server/performance-tuning/io-subsystem/misaligned-disk-partition-offsets-sql-server-performance/#:~:text=Checking%20the%20offset%20can%20be%20done%20via%20a,to%20check%3E%20partition%20get%20BlockSize%2C%20StartingOffset%2C%20Name%2C%20Index
### https://www.thomas-krenn.com/en/wiki/Partition_Alignment_detailed_explanation#:~:text=Partition%20alignment%20is%20understood%20to%20mean%20the%20proper,partition%20alignment%20ensures%20ideal%20performance%20during%20data%20access.

$env:COMPUTERNAME
Write-Host -ForegroundColor Green "###################################################"

GET-PHYSICALDISK
Write-Host -ForegroundColor Green "###################################################"

fsutil fsinfo ntfsinfo c:\
Write-Host -ForegroundColor Green "###################################################"

fsutil fsinfo ntfsinfo E:\
Write-Host -ForegroundColor Green "###################################################"

fsutil fsinfo ntfsinfo F:\
Write-Host -ForegroundColor Green "###################################################"

fsutil fsinfo ntfsinfo P:\
Write-Host -ForegroundColor Green "###################################################"

fsutil fsinfo ntfsinfo R:\
Write-Host -ForegroundColor Green "###################################################"

fsutil fsinfo ntfsinfo T:\
Write-Host -ForegroundColor Green "###################################################"

Get-PhysicalDIsk | Get-StorageReliabilityCounter |  Select-Object DeviceID, Temperature
Write-Host -ForegroundColor Green "################################################### > 0 indicates stress"

Get-PhysicalDisk –FriendlyName PhysicalDisk5 |  Get-StorageReliabilityCounter
Write-Host -ForegroundColor Green "###################################################"

## 	https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/solutions/sql-server-on-vmware-best-practices-guide.pdf
##  pg 41 pNUMA pg54 Disk Optimization
##
## OLTP LDF -64K
## OLTP MDF -8K
## Bulk Insert - 8k Any from 8k up to 256k
## Read Ahead Index Scans 8k to 512k
## Backup - 1MB
##

#1
#wmic partition gets BlockSize, StartingOffset, Name, Index
#2
#DISKPART
#LIST DISK
#SELECT DISK 1,2 ETC
#LIST PARTITION

## https://support.purestorage.com/Solutions/Microsoft_Platform_Guide/sss_Windows_Server_Features_and_Integrations/File_Systems
 
$env:COMPUTERNAME
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
