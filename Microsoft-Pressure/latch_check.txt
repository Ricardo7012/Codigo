--Please note that after using the below scripts, further investigation may be needed to determine why there is a hotspot on the system and if modifying the current structure with your developer is an option or if there is a runaway query on the application, I/O issue, or larger memory buffer needed.



--Review system wait times for latch and determine which type is increasing 
SELECT      wait_type,      wait_time_ms,      waiting_tasks_count,      wait_time_ms / NULLIF(waiting_tasks_count,0) AS avg_wait_time 
FROM  sys.dm_os_wait_stats 
WHERE wait_type LIKE 'LATCH_%'OR    wait_type LIKE 'PAGELATCH_%'OR    wait_type LIKE 'PAGEIOLATCH_%';


--Review highest  latch contention that is increasing 
select * from  sys.dm_os_latch_stats order by  waiting_requests_count desc ; 	


--Performance Monitor Counters To Monitor Latch Contention 
SELECT *
FROM sys.dm_os_performance_counters
WHERE object_name LIKE '%Latches%';									   										

--Query Buffer Descriptors to Determine Objects Causing Latch Contention
--You can drop the table if you are not going to log off after a while. 
IF EXISTS (SELECT * FROM tempdb.sys.objects WHERE [name] like '#WaitResources%') DROP
TABLE #WaitResources;
CREATE TABLE #WaitResources (session_id INT, wait_type NVARCHAR(1000), wait_duration_ms
INT,
 resource_description sysname NULL, db_name NVARCHAR(1000),
schema_name NVARCHAR(1000),
 object_name NVARCHAR(1000), index_name NVARCHAR(1000));
GO
declare @WaitDelay varchar(16), @Counter INT, @MaxCount INT, @Counter2 INT
SELECT @Counter = 0, @MaxCount = 600, @WaitDelay = '00:00:00.100'-- 600x.1=60 seconds
SET NOCOUNT ON;
WHILE @Counter < @MaxCount
BEGIN
 INSERT INTO #WaitResources(session_id, wait_type, wait_duration_ms,
resource_description)--, db_name, schema_name, object_name, index_name)
 SELECT wt.session_id,
 wt.wait_type,
 wt.wait_duration_ms,
 wt.resource_description
 FROM sys.dm_os_waiting_tasks wt
 WHERE wt.wait_type LIKE 'PAGELATCH%' AND wt.session_id <> @@SPID
--select * from sys.dm_os_buffer_descriptors
 SET @Counter = @Counter + 1;    
  WAITFOR DELAY @WaitDelay;
END;
--select * from #WaitResources
 update #WaitResources
 set db_name = DB_NAME(bd.database_id),
 schema_name = s.name,
 object_name = o.name,
 index_name = i.name
 FROM #WaitResources wt
 JOIN sys.dm_os_buffer_descriptors bd
 ON bd.database_id = SUBSTRING(wt.resource_description, 0, CHARINDEX(':',
wt.resource_description))
 AND bd.file_id = SUBSTRING(wt.resource_description, CHARINDEX(':',
wt.resource_description) + 1, CHARINDEX(':', wt.resource_description, CHARINDEX(':',
wt.resource_description) +1 ) - CHARINDEX(':', wt.resource_description) - 1)
 AND bd.page_id = SUBSTRING(wt.resource_description, CHARINDEX(':',
wt.resource_description, CHARINDEX(':', wt.resource_description) +1 ) + 1,
LEN(wt.resource_description) + 1)
 --AND wt.file_index > 0 AND wt.page_index > 0
 JOIN sys.allocation_units au ON bd.allocation_unit_id = AU.allocation_unit_id
 JOIN sys.partitions p ON au.container_id = p.partition_id
 JOIN sys.indexes i ON p.index_id = i.index_id AND p.object_id = i.object_id
 JOIN sys.objects o ON i.object_id = o.object_id
 JOIN sys.schemas s ON o.schema_id = s.schema_id
select * from #WaitResources order by wait_duration_ms desc
GO
/*
--Other views of the same information
SELECT wait_type, db_name, schema_name, object_name, index_name, SUM(wait_duration_ms)
[total_wait_duration_ms] FROM #WaitResources
GROUP BY wait_type, db_name, schema_name, object_name, index_name;
SELECT session_id, wait_type, db_name, schema_name, object_name, index_name,
SUM(wait_duration_ms) [total_wait_duration_ms] FROM #WaitResources
52
GROUP BY session_id, wait_type, db_name,   
GROUP BY session_id, wait_type, db_name, schema_name, object_name, index_name;
*/
--SELECT * FROM #WaitResources
--DROP TABLE #WaitResources;