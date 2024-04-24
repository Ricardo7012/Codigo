-- https://msdn.microsoft.com/en-us/library/ms345408.aspx 
-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-file-system-permissions-for-database-engine-access?view=sql-server-ver15
-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-windows-service-accounts-and-permissions?view=sql-server-ver15
-- ENSURE SQL SERVICE ACCOUNT USER HAS ACCESS TO DRIVES [NT SERVICE\MSSQLSERVER]
GO
USE master;  
GO  
SELECT d.name          DatabaseName
     , f.name          LogicalName
     , f.physical_name AS PhysicalName
     , f.type_desc     TypeofFile
FROM sys.master_files        f
    INNER JOIN sys.databases d
        ON d.database_id = f.database_id;
GO

SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files 

SELECT name, physical_name AS CurrentLocation  
FROM sys.master_files  
WHERE database_id = DB_ID(N'tempdb');  

--MOVING MASTER
--The parameter value for the data file must follow the -d parameter and the value for the log file must follow the -l parameter. The following example shows the parameter values for the default location of the master data file.
-- MAKE SURE TO CREATE THE FOLDERS
--  -dI:\MSSQL\DATA\master.mdf
--  -eI:\MSSQL\Log\ERRORLOG
--  -lI:\DATA\mastlog.ldf

--TEMPDB	
ALTER DATABASE tempdb   
MODIFY FILE (NAME = tempdev, 
FILENAME = 'T:\MSSQL\Data\tempdb.mdf');  
GO  
ALTER DATABASE tempdb   
MODIFY FILE (NAME = templog, 
FILENAME = 'T:\MSSQL\Data\templog.ldf');  
GO 
--5.Delete the tempdb.mdf and templog.ldf files from the original location.

--MODEL
ALTER DATABASE model 
MODIFY FILE ( NAME = modeldev, 
FILENAME = 'I:\MSSQL\Data\model.mdf' )  
GO
ALTER DATABASE model 
MODIFY FILE ( NAME = modellog, 
FILENAME = 'I:\MSSQL\Data\modellog.ldf' )  
GO
--MSDB
ALTER DATABASE msdb 
MODIFY FILE ( NAME = MSDBData, 
FILENAME = 'I:\MSSQL\Data\MSDBData.mdf' )  
GO
ALTER DATABASE msdb 
MODIFY FILE ( NAME = MSDBLog, 
FILENAME = 'I:\MSSQL\Data\MSDBLog.ldf' )  
GO

SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files 

--IF THE MSDB DATABASE IS MOVED AND THE INSTANCE OF SQL SERVER IS CONFIGURED FOR DATABASE MAIL, COMPLETE THESE ADDITIONAL STEPS.
--1.VERIFY THAT SERVICE BROKER IS ENABLED FOR THE MSDB DATABASE BY RUNNING THE FOLLOWING QUERY.

SELECT is_broker_enabled   
FROM sys.databases  
WHERE name = N'msdb';  


--use [tempdb]
--GO
--DBCC FREEPROCCACHE

--USE tempdb;
--GO
--DBCC SHRINKFILE('temp2', EMPTYFILE)
--DBCC SHRINKFILE('temp3', EMPTYFILE)
--DBCC SHRINKFILE('temp4', EMPTYFILE)
--DBCC SHRINKFILE('temp5', EMPTYFILE)
--DBCC SHRINKFILE('temp6', EMPTYFILE)
--DBCC SHRINKFILE('temp7', EMPTYFILE)
--DBCC SHRINKFILE('temp8', EMPTYFILE)
--GO
--USE master;
--GO
--ALTER DATABASE tempdb
--REMOVE FILE temp2;
--ALTER DATABASE tempdb
--REMOVE FILE temp3;
--ALTER DATABASE tempdb
--REMOVE FILE temp4;
--ALTER DATABASE tempdb
--REMOVE FILE temp5;
--ALTER DATABASE tempdb
--REMOVE FILE temp6;
--ALTER DATABASE tempdb
--REMOVE FILE temp7;
--ALTER DATABASE tempdb
--REMOVE FILE temp8;

