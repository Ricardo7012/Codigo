-- Check data pages for a Table

DECLARE @TableName varchar(50)

SET @TableName = 'TripDoNotModify'

SELECT o.NAME AS 'Table Name'
	, partition_number AS 'Partition Number'
	, p.index_id AS 'Index ID'
	, i.NAME AS 'Index Name'
	, au.type_desc AS 'Allocation Type'
	, au.data_pages AS 'Data Pages' -- Stored in 8KB
FROM sys.allocation_units AS au
INNER JOIN sys.partitions AS p
	ON au.container_id = p.partition_id
INNER JOIN sys.objects AS o
	ON p.object_id = o.object_id
INNER JOIN sys.indexes AS i
	ON p.index_id = i.index_id
		AND i.object_id = p.object_id
WHERE o.NAME = @TableName
ORDER BY o.NAME
	, p.index_id
	
DBCC IND('PlayerManagement' -- DB
		, 'dbo.PlayerSession0' -- Table
		, 3)

DBCC TRACEON(3604)
DBCC PAGE ('PlayerManagement', 7, 6697923, 2)