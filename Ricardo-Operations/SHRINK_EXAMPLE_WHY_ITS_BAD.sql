 -- find your default trace file
    SELECT * FROM fn_trace_getinfo(default);

--NOW INPUT YOUR FILEPATH AND NAME FROM THE ABOVE QUERY INTO THE FROM IN THIS STATEMENT:
-- QUERY IT FOR ANY SHRINKFILES
    SELECT
      TextData,
      HostName,
      ApplicationName,
      LoginName,
      StartTime 
   FROM
      [fn_trace_gettable]('E:\Program Files\Microsoft ...\log_175.trc', DEFAULT)
   WHERE 
      TextData LIKE 'DBCC SHRINKFILE%'

--Shrinking SQL Server's database files is something you'll do only in worst case scenarios.  ie., Your log is blowing up and you are going to run out of space in the middle of the production day.  Ok.  Shrink it.  But you should really try not to make this a repeat activity.  For more evidence of why, take a look at the Hamster Wheel of Death explanation from Brent Ozar.
--Of course, as a reminder, if your default trace isn't enabled/running, it really should be.  Run this to confirm default trace status:

SELECT * FROM sys.configurations WHERE configuration_id = 1568

/******************************************************************************
--Create a database
--Create a ~1GB table with 5M rows in it
--Put a clustered index on it, and check its fragmentation
--Look at my database’s empty space
--Shrink the database to get rid of the empty space
--And then see what happens next.
--Here’s steps 1-3:
-- https://www.brentozar.com/archive/2017/12/whats-bad-shrinking-databases-dbcc-shrinkdatabase/
******************************************************************************/

CREATE DATABASE WorldOfHurt;
GO
USE WorldOfHurt;
GO
ALTER DATABASE [WorldOfHurt] SET RECOVERY SIMPLE WITH NO_WAIT
GO

/* Create a ~1GB table with 5 million rows */
SELECT TOP 5000000 o.object_id, m.*
  INTO dbo.Messages
  FROM sys.messages m
  CROSS JOIN sys.all_objects o;
GO
CREATE UNIQUE CLUSTERED INDEX IX ON dbo.Messages(object_id, message_id, language_id);
GO
SELECT * FROM sys.dm_db_index_physical_stats  
    (DB_ID(N'WorldOfHurt'), OBJECT_ID(N'dbo.Messages'), NULL, NULL , 'DETAILED');  
GO
/******************************************************************************
-- We have 0.01% fragmentation, and 99.7% of each 8KB page is packed in solid with data. 
-- That’s great! When we scan this table, the pages will be in order, and full of tasty data, making for a quick scan.
******************************************************************************/


/******************************************************************************
--Now, how much empty space do we have?
******************************************************************************/

USE WorldOfHurt
GO
SELECT 
    [TYPE] = A.TYPE_DESC
    ,[FILE_Name] = A.name
    ,[FILEGROUP_NAME] = fg.name
    ,[File_Location] = A.PHYSICAL_NAME
    ,[FILESIZE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0)
    ,[USEDSPACE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0 - ((SIZE/128.0) - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0))
    ,[FREESPACE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0 - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0)
    ,[FREESPACE_%] = CONVERT(DECIMAL(10,2),((A.SIZE/128.0 - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0)/(A.SIZE/128.0))*100)
    ,[AutoGrow] = 'By ' + CASE is_percent_growth WHEN 0 THEN CAST(growth/128 AS VARCHAR(10)) + ' MB -' 
        WHEN 1 THEN CAST(growth AS VARCHAR(10)) + '% -' ELSE '' END 
        + CASE max_size WHEN 0 THEN 'DISABLED' WHEN -1 THEN ' Unrestricted' 
            ELSE ' Restricted to ' + CAST(max_size/(128*1024) AS VARCHAR(10)) + ' GB' END 
        + CASE is_percent_growth WHEN 1 THEN ' [autogrowth by percent, BAD setting!]' ELSE '' END
FROM sys.database_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
ORDER BY A.TYPE desc, A.NAME;

/******************************************************************************
-- Our data file is 51% empty!
-- Well, that’s not good! Our 2,504MB data file has 1,853MB of free space in it, so it’s 60.17% empty! 
-- So let’s say we want to reclaim that space by shrinking the data file back down:
******************************************************************************/

--Let’s use DBCC SHRINKDATABASE to reclaim the empty space.
DBCC SHRINKDATABASE(WorldOfHurt, 1);

/******************************************************************************
--Now, how much empty space do we have? AFTER SHRINK
******************************************************************************/
SELECT 
    [TYPE] = A.TYPE_DESC
    ,[FILE_Name] = A.name
    ,[FILEGROUP_NAME] = fg.name
    ,[File_Location] = A.PHYSICAL_NAME
    ,[FILESIZE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0)
    ,[USEDSPACE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0 - ((SIZE/128.0) - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0))
    ,[FREESPACE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0 - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0)
    ,[FREESPACE_%] = CONVERT(DECIMAL(10,2),((A.SIZE/128.0 - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0)/(A.SIZE/128.0))*100)
    ,[AutoGrow] = 'By ' + CASE is_percent_growth WHEN 0 THEN CAST(growth/128 AS VARCHAR(10)) + ' MB -' 
        WHEN 1 THEN CAST(growth AS VARCHAR(10)) + '% -' ELSE '' END 
        + CASE max_size WHEN 0 THEN 'DISABLED' WHEN -1 THEN ' Unrestricted' 
            ELSE ' Restricted to ' + CAST(max_size/(128*1024) AS VARCHAR(10)) + ' GB' END 
        + CASE is_percent_growth WHEN 1 THEN ' [autogrowth by percent, BAD setting!]' ELSE '' END
FROM sys.database_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
ORDER BY A.TYPE desc, A.NAME;

--TYPE	FILE_Name	FILEGROUP_NAME	File_Location	FILESIZE_MB	USEDSPACE_MB	FREESPACE_MB	FREESPACE_%	AutoGrow
--LOG	WorldOfHurt_log	NULL	L:\MSSQL\Data\WorldOfHurt_log.ldf	136.00	0.40	135.60	99.71	By 1024 MB - Restricted to 2048 GB
--ROWS	WorldOfHurt	PRIMARY	E:\MSSQL\Data\WorldOfHurt.mdf	1239.13	1226.69	12.44	1.00	By 1024 MB - Unrestricted

/******************************************************************************
--But now check fragmentation.
******************************************************************************/
SELECT * FROM sys.dm_db_index_physical_stats  
    (DB_ID(N'WorldOfHurt'), OBJECT_ID(N'dbo.Messages'), NULL, NULL , 'DETAILED');


--Guess what happens when you rebuild the index?
--SQL Server needs enough empty space in the database to build an entirely new copy of the index, so it’s going to:

--Grow the data file out
--Use that space to build the new copy of our index
--Drop the old copy of our index, leaving a bunch of unused space in the file
--Let’s prove it – rebuild the index and check fragmentation:


ALTER INDEX IX ON dbo.Messages REBUILD;
GO
SELECT * FROM sys.dm_db_index_physical_stats  
    (DB_ID(N'WorldOfHurt'), OBJECT_ID(N'dbo.Messages'), NULL, NULL , 'DETAILED');  
GO

/******************************************************************************
CONCLUSION 

Shrinking databases and rebuilding indexes is a vicious cycle.
You have high fragmentation, so you rebuild your indexes.

Which leaves a lot of empty space around, so you shrink your database.

Which causes high fragmentation, so you rebuild your indexes, which grows the 
databases right back out and leaves empty space again, and the cycle keeps perpetuating itself.

Break the cycle. Stop doing things that cause performance problems rather than 
fixing ’em. If your databases have some empty space in ’em, that’s fine – 
SQL Server will probably need that space again for regular operations like index rebuilds.
******************************************************************************/

--If you still think you want to shrink a database, check out how to shrink a database in 4 easy steps.
-- https://am2.co/2016/04/shrink-database-4-easy-steps/ 