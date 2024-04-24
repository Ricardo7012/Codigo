-- https://www.sqlshack.com/use-sql-server-data-compression-save-space/
-- https://docs.microsoft.com/en-us/sql/relational-databases/data-compression/enable-compression-on-a-table-or-index?view=sql-server-2017
-- https://www.mssqltips.com/sqlservertip/3187/demonstrating-the-effects-of-using-data-compression-in-sql-server/

select @@SERVERNAME, @@version
GO
USE [];  
GO  
EXEC sp_estimate_data_compression_savings 
    @schema_name = 'dbo', 
    @object_name = 'table', 
    @index_id = NULL, 
    @partition_number = NULL, 
    @data_compression = 'ROW'
 
EXEC sp_estimate_data_compression_savings 
    @schema_name = 'dbo', 
    @object_name = 'Table', 
    @index_id = NULL, 
    @partition_number = NULL, 
    @data_compression = 'PAGE'

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


select name
     , s.used / 128.0                as SpaceUsedInMB
     , size / 128.0 - s.used / 128.0 as AvailableSpaceInMB
from sys.database_files
    cross apply
(select cast(fileproperty(name, 'SpaceUsed') as int)) s(used)
where fileproperty(name, 'SpaceUsed') is not null;

/*****************************************************************
COMPRESS

ALTER INDEX PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID 
        ON Sales.SalesOrderDetail 
        REBUILD PARTITION = ALL 
        WITH (DATA_COMPRESSION = PAGE);
 
ALTER INDEX IX_SalesOrderDetail_ProductID
        ON Sales.SalesOrderDetail 
        REBUILD PARTITION = ALL 
        WITH (DATA_COMPRESSION = PAGE);

******************************************************************/