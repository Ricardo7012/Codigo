----'LOG remaining FOR undo'
--SELECT DB_NAME(database_id) AS DatabaseName
--     , synchronization_state_desc
--     , database_state_desc
--FROM sys.dm_hadr_database_replica_states
--WHERE is_local = 1
--      AND is_primary_replica = 0;
 
--SELECT [object_name]
--     , [counter_name]
--     , [cntr_value] AS [KB]
--FROM sys.dm_os_performance_counters
--WHERE [object_name] LIKE '%DATABASE REPLICA%'
--      AND [counter_name] = 'LOG remaining FOR undo'
 
--SELECT DB_NAME(database_id) AS DatabaseName
--     , synchronization_state_desc
--     , database_state_desc
--FROM sys.dm_hadr_database_replica_states
--WHERE is_local = 1
--      AND is_primary_replica = 0;

-- Recovery of database
USE master
GO

DECLARE @DBName VARCHAR(64) = 'MEMBER'

DECLARE @ErrorLog AS TABLE([LogDate] CHAR(24), [ProcessInfo] VARCHAR(64), [TEXT] VARCHAR(MAX))

INSERT INTO @ErrorLog
EXEC master..sp_readerrorlog 0, 1, 'Recovery of database', @DBName

INSERT INTO @ErrorLog
EXEC master..sp_readerrorlog 0, 1, 'Recovery completed', @DBName

SELECT TOP 1
    @DBName AS [DBName]
   ,[LogDate]
   ,CASE
      WHEN SUBSTRING([TEXT],10,1) = 'c'
      THEN '100%'
      ELSE SUBSTRING([TEXT], CHARINDEX(') is ', [TEXT]) + 4,CHARINDEX(' complete (', [TEXT]) - CHARINDEX(') is ', [TEXT]) - 4)
      END AS PercentComplete
   ,CASE
      WHEN SUBSTRING([TEXT],10,1) = 'c'
      THEN 0
      ELSE CAST(SUBSTRING([TEXT], CHARINDEX('approximately', [TEXT]) + 13,CHARINDEX(' seconds remain', [TEXT]) - CHARINDEX('approximately', [TEXT]) - 13) AS FLOAT)/60.0
      END AS MinutesRemaining
   ,CASE
      WHEN SUBSTRING([TEXT],10,1) = 'c'
      THEN 0
      ELSE CAST(SUBSTRING([TEXT], CHARINDEX('approximately', [TEXT]) + 13,CHARINDEX(' seconds remain', [TEXT]) - CHARINDEX('approximately', [TEXT]) - 13) AS FLOAT)/60.0/60.0
      END AS HoursRemaining
   ,[TEXT]
FROM @ErrorLog ORDER BY CAST([LogDate] as datetime) DESC, [MinutesRemaining]
go
DBCC SQLPERF('logspace')
GO 