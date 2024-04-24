
/***********************************************************************
CHECK STATUS OF ALL DATABASES
************************************************************************/
SELECT name,
       user_access_desc,
       state_desc,
       log_reuse_wait_desc
FROM sys.databases
ORDER BY state_desc DESC

/***********************************************************************
DROP HAG
************************************************************************/
--If a database is in SUSPECT or RECOVERY_PENDING mode than we can “DROP AVAILABILTY GROUP” 
--DROP AVAILABILTY GROUP [AGVEGA01]

/***********************************************************************
OPTIONAL
************************************************************************/
--ALTER DATABASE [DBName] SET EMERGENCY;
--ALTER DATABASE [DBName] SET SINGLE_USER
--DBCC CHECKDB([DBName], repair_allow_data_loss) WITH ALL_ERRORMSGS
--ALTER DATABASE [DBName] SET MULTI_USER

--EXEC sp_detach_db '[DBName]'
--EXEC sp_attach_single_file_db @DBName = '[DBName]', @physname = N'[mdf path]'

