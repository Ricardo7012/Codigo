SELECT @@SERVERNAME, @@version
GO
--USE TDS;  
--GO  
--EXEC sp_estimate_data_compression_savings 
--    @schema_name = 'dbo', 
--    @object_name = 'TDS', 
--    @index_id = NULL, 
--    @partition_number = NULL, 
--    @data_compression = 'ROW'
 
--EXEC sp_estimate_data_compression_savings 
--    @schema_name = 'dbo', 
--    @object_name = 'TDS', 
--    @index_id = NULL, 
--    @partition_number = NULL, 
--    @data_compression = 'PAGE'

SELECT DISTINCT
    s.name,
    t.name,
    i.name,
    i.type,
    i.index_id,
    p.partition_number,
    p.rows
FROM sys.tables t
LEFT JOIN sys.indexes i
ON t.object_id = i.object_id
JOIN sys.schemas s
ON t.schema_id = s.schema_id
LEFT JOIN sys.partitions p
ON i.index_id = p.index_id
    AND t.object_id = p.object_id
WHERE t.type = 'U' 
  AND p.data_compression_desc = 'NONE'
ORDER BY p.rows desc


USE CorepointQueuesAndLogs
SELECT 
	@@SERVERNAME as SERVERNAME, 
	name as DATABASENAME,
    s.used / 128.0                  AS SpaceUsedInMB,
    size / 128.0 - s.used / 128.0   AS AvailableSpaceInMB
FROM sys.database_files
CROSS APPLY 
    (SELECT CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)) 
s(used)
WHERE FILEPROPERTY(name, 'SpaceUsed') IS NOT NULL;

SELECT GETDATE() as DATETIME
