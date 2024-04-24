-- https://www.purestorage.com/resources/webinars/3-ways-to-prove-your-sql-server-storage-is-slow.html

USE master
go
---- Cumulative since startup
SELECT * FROM sys.dm_os_wait_stats ORDER BY  wait_time_ms DESC

SELECT @@ServerName AS VMName

EXEC dbakit.dbo.sp_BlitzFirst @SinceStartup =1 
-- http://www.brentozar.com/go/way1 
-- This URL will not work in IEHP domain since it goes to google docs

-- NOT WAITING ON STORAGE YET - cumulative since startup
SELECT * FROM sys.dm_io_virtual_file_stats(NULL, NULL)
--SECOND RESULTSET
-- SQL SERVER - WINDOWS - FILTER DRIVER- ENCRYPTION - VMWARE - OS - FIBER ADAPTER - STORAGE FABRIC - SAN
-- https://www.codyhosterman.com/2017/02/understanding-vmware-esxi-queuing-and-the-flasharray/
--EXEC dbakit.dbo.sp_BlitzFirst @SinceStartup =1 

SELECT TOP 100* FROM msdb.dbo.backupset ORDER BY 1 DESC

EXEC dbakit.dbo.sp_BlitzBackups
-- get the most important and put in 
-- http://www.brentozar.com/go/way3
