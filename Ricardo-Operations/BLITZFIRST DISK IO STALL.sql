-- BLITZFIRST DISK IO STALL
-- https://www.purestorage.com/resources/webinars/3-ways-to-prove-your-sql-server-storage-is-slow.html

USE master;
GO

-- CUMULATIVE SINCE STARTUP
-- ACROSS THE ENTIRE INSTANCE, ALL DBs ALL QUERIES
-- INCLUDES A LOT OF HARMELESS, IDLE WAIT TIME
SELECT *
FROM sys.dm_os_wait_stats
ORDER BY wait_time_ms DESC;
SELECT @@ServerName AS SN;

--
EXEC dbo.sp_BlitzFirst 
 @SinceStartup = 1
-- http://www.brentozar.com/go/way1 
-- This URL will not work in IEHP domain since it goes to google docs
-- LOOK FOR HIGH AVG IO WAITS INCL. PAGEIOLATCH, WRITELOG, HADR_SYNC_COMMIT

-- NOT WAITING ON STORAGE YET - cumulative since startup
SELECT *
FROM sys.dm_io_virtual_file_stats(NULL, NULL);
--SECOND RESULTSET
-- SQL SERVER - WINDOWS - FILTER DRIVER- ENCRYPTION - VMWARE - OS - FIBER ADAPTER - STORAGE FABRIC - SAN
-- https://www.codyhosterman.com/2017/02/understanding-vmware-esxi-queuing-and-the-flasharray/
EXEC dbo.sp_BlitzFirst 
@SinceStartup = 1;

-- THIS IS YOUR DISK IO TEST DATA! BUT DOESNT TELL US WHY BACKUPS ARE SLOW
SELECT TOP 100
       *
FROM msdb.dbo.backupset
ORDER BY 1 DESC;

EXEC dbo.sp_BlitzBackups; -- = 14 DAYS BY DEFAULT
-- get the most important and put in 
-- http://www.brentozar.com/go/way3
-- RPO WORST CASE

/*
THREE WAYS TO PROVE STORAGE IS SLOW 
1-PAGEIOLATCH % = SLOW READS FROM DATA FILES
2-WRITELOG = SLOW WRITES TO LOG FILES
3-HADR_SYNC_COMMIT = SLOW AG RELICAS
*/