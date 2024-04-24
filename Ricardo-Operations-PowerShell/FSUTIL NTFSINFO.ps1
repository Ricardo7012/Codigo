CLS
#### fsutil

HOSTNAME
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
