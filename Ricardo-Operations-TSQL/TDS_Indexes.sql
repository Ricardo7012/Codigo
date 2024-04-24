ALTER DATABASE [TDS] SET RESTRICTED_USER WITH ROLLBACK IMMEDIATE
GO
--SELECT * FROM sys.dm_tran_database_transactions

-- First you can try the sysprocesses to get SPID and Kill Them
DECLARE @DB SYSNAME -- Put the name of database here
DECLARE @SPID VARCHAR(4), @cmdSQL VARCHAR(10)

SET @DB = 'TDS'

-- Looks for all spids that are connected in the databases
DECLARE cCursor CURSOR
FOR SELECT CAST(SPID AS VARCHAR(4)) FROM master.dbo.sysprocesses
WHERE SPID > 50 -- To not try to Kill SQL Server Process
AND SPID != @@SPID -- To not kill yourself
AND DBID = DB_ID(@DB) -- To filter only the users connected in specific database

OPEN cCursor

FETCH NEXT FROM cCursor INTO @SPID

-- For each user connected in the database
WHILE @@FETCH_STATUS = 0
BEGIN
 SET @cmdSQL = 'KILL ' + @SPID

 -- Kill the user
 EXEC (@cmdSQL)
 FETCH NEXT FROM cCursor INTO @SPID 
END

CLOSE cCURSOR

DEALLOCATE cCURSOR

--SELECT * FROM sys.dm_tran_database_transactions

DBCC OPENTRAN()

exec SP_WHO2;


PRINT 'START TIME: ' + CONVERT(varchar, SYSDATETIME(), 121)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SET STATISTICS IO, TIME ON 
SET NOCOUNT ON 

USE [master]
GO
ALTER DATABASE [TDS] SET  SINGLE_USER WITH NO_WAIT
GO
SELECT user_access_desc FROM sys.databases WHERE name = 'TDS'
GO

SELECT @@SERVERNAME AS ServerName, GETDATE() AS Date_Time, SYSTEM_USER AS DBA
GO
--
SELECT name, user_access_desc, state_desc, log_reuse_wait_desc FROM sys.databases
GO

USE TDS;
GO
SELECT COUNT(*) FROM TDS -- 27,844,796

SELECT MAX(LEN(MRN))            AS maxmrn            --16
     , MAX(LEN(memberid))       AS maxmemberid       --14
     , MAX(LEN(source))         AS maxsource         --33
     , MAX(LEN(location))       AS maxlocation       --33
     , MAX(LEN(messagetype))    AS maxmessagetype    --3 THIS WILL ALWAYS BE  3
     , MAX(LEN(messagetrigger)) AS maxmessagetrigger --3 THIS WILL ALWAYS BE  3
FROM tds (NOLOCK);

DBCC SQLPERF(LOGSPACE)

ALTER TABLE tds.dbo.tds ALTER COLUMN MRN VARCHAR(25) NULL;
go
BACKUP DATABASE TDS TO DISK = 'NUL:'

DBCC SQLPERF(LOGSPACE)
go
ALTER TABLE tds ALTER COLUMN memberid VARCHAR(20) NULL;
--ALTER TABLE tds ALTER COLUMN source VARCHAR(50) NULL;
ALTER TABLE tds ALTER COLUMN location VARCHAR(50) NULL;
ALTER TABLE tds ALTER COLUMN messagetype CHAR(3) NULL;
ALTER TABLE tds ALTER COLUMN messagetrigger CHAR(3) NULL;

USE [TDS];
GO
--***********************IX1
--THIS INDEX WAS THERE
--CREATE UNIQUE NONCLUSTERED INDEX [ix_MessageId_Source]
--ON [dbo].[tds] (
--                   [MessageId] ASC
--                 , [Source] ASC
--               )
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF
--    , ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
--     );
--GO

--***********************IX2
--CREATE UNIQUE NONCLUSTERED INDEX [ix_MessageDate]
--ON [dbo].[tds] ([MessageDate] ASC)
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF
--    , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
--     );
--GO

----***********************IX3
--CREATE UNIQUE NONCLUSTERED INDEX [ix_InsertDate]
--ON [dbo].[tds] ([InsertDate] ASC)
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF
--    , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
--     );
--GO

USE [master]
GO
ALTER DATABASE [TDS] SET  MULTI_USER WITH NO_WAIT
GO


SET STATISTICS IO, TIME OFF
PRINT 'END TIME: ' + CONVERT(varchar, SYSDATETIME(), 121)
