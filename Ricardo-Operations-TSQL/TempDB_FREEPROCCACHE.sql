USE [tempdb]
GO
-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-freeproccache-transact-sql
-- Removes all elements from the plan cache, removes a specific plan from the plan cache by specifying a plan handle 
-- or SQL handle, or removes all cache entries associated with a specified resource pool.

SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files 

SELECT name, physical_name AS CurrentLocation  
FROM sys.master_files  
WHERE database_id = DB_ID(N'tempdb');  

--https://sqlsunday.com/2013/08/11/shrinking-tempdb-without-restarting-sql-server/ 
use tempdb
go
select (size*8) as FileSizeKB from sys.database_files
go
CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS;
GO
DBCC FREEPROCCACHE;
GO
DBCC FREESYSTEMCACHE ('ALL');
GO
DBCC FREESESSIONCACHE;
GO

USE tempdb;
GO
DBCC SHRINKFILE (N'tempdev', EMPTYFILE)
DBCC SHRINKFILE('tempdev02', EMPTYFILE)
DBCC SHRINKFILE('tempdev03', EMPTYFILE)
DBCC SHRINKFILE('tempdev04', EMPTYFILE)
DBCC SHRINKFILE('tempdev05', EMPTYFILE)
DBCC SHRINKFILE('tempdev06', EMPTYFILE)
DBCC SHRINKFILE('tempdev07', EMPTYFILE)
DBCC SHRINKFILE('tempdev08', EMPTYFILE)
DBCC SHRINKFILE('tempdev09', EMPTYFILE)
DBCC SHRINKFILE('tempdev10', EMPTYFILE)

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

USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev' , 40960)
GO
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev02' , 40960)
GO
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev03' , 40960)
GO
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev04' , 40960)
GO
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev05' , 40960)
GO
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev06' , 40960)
GO
USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', MAXSIZE = UNLIMITED, FILEGROWTH = 0)
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev02', MAXSIZE = UNLIMITED, FILEGROWTH = 0)
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev03', MAXSIZE = UNLIMITED, FILEGROWTH = 0)
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev04', MAXSIZE = UNLIMITED, FILEGROWTH = 0)
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev05', MAXSIZE = UNLIMITED, FILEGROWTH = 0)
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev06', MAXSIZE = UNLIMITED, FILEGROWTH = 0)
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', MAXSIZE = 41943040KB )
GO
