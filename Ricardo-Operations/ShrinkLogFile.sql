SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files 
-- https://mitchellpearson.com/2015/01/26/the-transaction-log-for-database-is-full-due-to-replication-replication-not-enabled-cdc/ 

DBCC SQLPERF(LOGSPACE)
DBCC LOG(HSP)

SELECT name, log_reuse_wait_desc FROM master.sys.databases WHERE name = 'hsp'
USE HSP
go
EXEC sys.sp_cdc_disable_db;  
GO  

USE [master]
GO
--ALTER DATABASE HSP_MO SET EMERGENCY
GO
USE EBM
GO
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-repldone-transact-sql?view=sql-server-ver15
EXEC sp_repldone @xactid = NULL, @xact_segno = NULL, @numtrans = 0, @time= 0, @reset = 1

ALTER DATABASE EBM SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKFILE(EBM_log, 1024)

USE EBM;
GO
CHECKPOINT;
GO
CHECKPOINT; -- run twice to ensure file wrap-around
GO
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-removedbreplication-transact-sql?view=sql-server-ver15
EXEC sys.sp_removedbreplication @dbname = 'EBM', @type = N'both' -- nvarchar(5)

exec sp_replicationdboption @dbname = N'EBM', @optname = N'publish', @value = N'false'
exec sp_replicationdboption @dbname = N'EBM', @optname = N'publish', @value = N'true'

ALTER DATABASE [WPC_837P] SET RECOVERY FULL WITH NO_WAIT
GO

BACKUP DATABASE HSP_MO TO DISK='NUL:'
GO
BACKUP LOG HSP_MO TO DISK='NUL:' WITH STATS=1
GO
SELECT * FROM sys.databases
GO
SELECT COUNT(*) FROM fn_dblog(NULL, NULL)
GO

USE []
GO
select [Current LSN],
       [Operation],
       [Transaction Name],
       [Transaction ID],
       [Transaction SID],
       [SPID],
       [Begin Time]
FROM   fn_dblog(null,null)


USE []
go
SELECT
 [Current LSN],
 [Transaction ID],
 [Operation],
  [Transaction Name],
 [CONTEXT],
 [AllocUnitName],
 [Page ID],
 [Slot ID],
 [Begin Time],
 [End Time],
 [Number of Locks],
 [Lock Information]
FROM sys.fn_dblog(NULL,NULL)
WHERE Operation IN 
   ('LOP_INSERT_ROWS','LOP_MODIFY_ROW',
    'LOP_DELETE_ROWS','LOP_BEGIN_XACT','LOP_COMMIT_XACT')  


--BACKUP LOG MyDb TO DISK='NUL:'


USE [master]
GO
ALTER DATABASE [HSP_MO] ADD LOG FILE ( NAME = N'HSP_MO_LOG2', FILENAME = N'L:\LOG\HSP_MO_LOG2.ldf' , SIZE = 1024KB , FILEGROWTH = 128MB)
GO


