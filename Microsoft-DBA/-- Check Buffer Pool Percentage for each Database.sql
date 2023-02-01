-- Check Buffer Pool Percentage for each Database

DECLARE @total_buffer INT;

SELECT @total_buffer = cntr_value
FROM sys.dm_os_performance_counters
WHERE RTRIM([object_name]) LIKE '%Buffer Manager'
	AND counter_name = 'Total Pages';;

WITH src
AS (
	SELECT database_id
		, db_buffer_pages = COUNT_BIG(*)
	FROM sys.dm_os_buffer_descriptors --WHERE database_id BETWEEN 5 AND 32766       
	GROUP BY database_id
	)
SELECT CASE [database_id]
		WHEN 32767
			THEN 'Resource DB'
		ELSE DB_NAME([database_id])
		END AS 'DB Name'
	, db_buffer_pages AS 'Buffer Pages'
	, db_buffer_pages / 128 AS 'DB Buffer (MB)'
	, CONVERT(DECIMAL(6, 3), db_buffer_pages * 100.0 / @total_buffer) AS 'DB Buffer %'
FROM src
ORDER BY 'DB Buffer (MB)' DESC;

--then drill down into memory used by objects in database of your choice
USE PlayerManagement;

WITH src
AS (
	SELECT [Object] = o.NAME
		, [Type] = o.type_desc
		, [Index] = COALESCE(i.NAME, '')
		, [Index_Type] = i.type_desc
		, p.[object_id]
		, p.index_id
		, au.allocation_unit_id
	FROM sys.partitions AS p
	INNER JOIN sys.allocation_units AS au
		ON p.hobt_id = au.container_id
	INNER JOIN sys.objects AS o
		ON p.[object_id] = o.[object_id]
	INNER JOIN sys.indexes AS i
		ON o.[object_id] = i.[object_id]
			AND p.index_id = i.index_id
	WHERE au.[type] IN (
			1
			, 2
			, 3
			)
		AND o.is_ms_shipped = 0
	)
SELECT src.[Object] AS 'Object'
	, src.[Type] AS 'Object Type'
	, src.[Index] AS 'Index Name'
	, src.Index_Type AS 'Index Type'
	, COUNT_BIG(b.page_id) AS 'Buffer Page'
	, COUNT_BIG(b.page_id) / 128 AS 'Object Buffer (MB)'
FROM src
INNER JOIN sys.dm_os_buffer_descriptors AS b
	ON src.allocation_unit_id = b.allocation_unit_id
WHERE b.database_id = DB_ID()
GROUP BY src.[Object]
	, src.[Type]
	, src.[Index]
	, src.Index_Type
ORDER BY 'Buffer Page' DESC;
