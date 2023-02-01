SELECT name, physical_name from sys.master_files
GO
SET NOCOUNT ON

/*2005*/
USE [ePO4_HBSS_FOC]
GO
DBCC SHRINKFILE(N'ePO4_HBSS-FOC_log' , 1024)
BACKUP LOG [ePO4_HBSS_FOC] WITH TRUNCATE_ONLY
DBCC SHRINKFILE (N'ePO4_HBSS-FOC_log' , 1024)
GO 

/*2008*/
USE [master]
GO
ALTER DATABASE [ePO4_HBSS_FOC] SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKFILE(N'ePO4_HBSS-FOC_log', 1024)
ALTER DATABASE [ePO4_HBSS_FOC] SET RECOVERY FULL WITH NO_WAIT
GO
/*Take A Full Backup when changing from simple to full; it will initiate the log chain*/


/**/
SELECT name, physical_name from sys.master_files
GO

BACKUP Log [ePO4_HBSS_FOC] TO DISK = 'D:\MSSQL\Backup\ePO4_HBSS-FOC_log.TRN'
--2.Check if there is enough free space on perform the shrink operation
SELECT 
	name 
	,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
FROM 
	sys.database_files;
DBCC SQLPERF(LOGSPACE);

--If there is no sufficient free space then the shrink operation cannot reduce file size.
--3.Check if all the transactions are written into the disk
DBCC LOGINFO('ePO4_HBSS_FOC')

--The status of the last transaction should be 0. If not, then backup the transaction log once again.
--4.Shrink the log file
DBCC SHRINKFILE([ePO4_HBSS-FOC_log] , 1024)

/*
If the transaction lof file does not shrink after performing the above steps then 
backup the log file again to make more of the virtual log files inactive.
Also check the column LOG_REUSE_WAIT_DESC in the sys.databases catalog view to 
check if the reuse of the transaction log space is waiting on anything.
*/
USE [ePO4_HBSS_FOC]
GO

SELECT 
	name
	, LOG_REUSE_WAIT_DESC
FROM 
	sys.databases;
	

/*
http://www.techrepublic.com/blog/datacenter/help-my-sql-server-log-file-is-too-big/448
http://msdn.microsoft.com/en-us/library/ms191433.aspx	Adding and Deleting Data and Transaction Log Files
http://msdn.microsoft.com/en-us/library/ms189493.aspx	DBCC SHRINKFILE (Transact-SQL)
http://msdn.microsoft.com/en-us/library/ms189768.aspx	DBCC SQLPERF (Transact-SQL)
*/
SELECT name, recovery_model_desc FROM sys.databases

SELECT name, log_reuse_wait_desc FROM sys.databases
DBCC OPENTRAN
EXECUTE sp_who2 547
SELECT * FROM sys.dm_exec_sessions WHERE session_id = 547  --from DBCC OPENTRAN
DBCC INPUTBUFFER(547)  --from DBCC OPENTRAN

-- Empty the data file.
DBCC SHRINKFILE ([ePO4_HBSS-FOC_log], EMPTYFILE);
GO
-- Remove the data file from the database.
ALTER DATABASE ePO4_HBSS_FOC
REMOVE FILE [ePO4_HBSS-FOC_log];
GO
