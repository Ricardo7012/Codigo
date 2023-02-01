--https://sqlsunday.com/2013/08/11/shrinking-tempdb-without-restarting-sql-server/ 
USE tempdb;
GO
SELECT 
	Physical_name
     , (size * 8) AS FileSizeKB
	 , (size * 8 / 1024) AS FileSizeMB
	 , (size * 8 / 1048576 ) AS FileSizeGB
FROM sys.database_files
GO
-- DO ALL THIS IN SECTIONS ONLY DONT RUN ALL AT ONCE DO CHECKPOINT IN EACH SECTION
CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS;  -- FLUSHES CACHE 
GO
DBCC FREEPROCCACHE;		
GO
DBCC FREESESSIONCACHE;		--DISTRIBUTED QUERIES 
GO
DBCC FREESYSTEMCACHE('ALL');	--
GO

DBCC SHRINKFILE('tempdev07', EMPTYFILE)



/*METHOD 1*/
USE [tempdb];
GO
DBCC SHRINKFILE(N'tempdev', 5120);
GO
DBCC SHRINKFILE(N'tempdev02', 5120);
GO
DBCC SHRINKFILE(N'tempdev03', 5120);
GO
DBCC SHRINKFILE(N'tempdev04', 5120);
GO
DBCC SHRINKFILE(N'tempdev05', 5120);
GO
DBCC SHRINKFILE(N'tempdev06', 5120);
GO
/*METHOD 2*/
--ALTER DATABASE tempdb MODIFY FILE
--   (NAME = 'tempdev', SIZE = 5120) 
--ALTER DATABASE tempdb MODIFY FILE
--   (NAME = 'tempdev02', SIZE = 5120) 
--ALTER DATABASE tempdb MODIFY FILE
--   (NAME = 'tempdev03', SIZE = 5120) 
--ALTER DATABASE tempdb MODIFY FILE
--   (NAME = 'tempdev04', SIZE = 5120) 
--ALTER DATABASE tempdb MODIFY FILE
--   (NAME = 'tempdev05', SIZE = 5120) 
--ALTER DATABASE tempdb MODIFY FILE
--   (NAME = 'tempdev06', SIZE = 5120) 

--ALTER DATABASE tempdb MODIFY FILE
--(NAME = 'templog', SIZE = target_size_in_MB)
USE tempdb;
GO
SELECT 
	Physical_name
     , (size * 8) AS FileSizeKB
	 , (size * 8 / 1024) AS FileSizeMB
	 , (size * 8 / 1048576 ) AS FileSizeGB
FROM sys.database_files

