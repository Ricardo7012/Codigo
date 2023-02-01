-- List What Tables are Partitioned

SELECT object_schema_name(i.object_id) AS 'Schema'
	, object_name(i.object_id) AS 'Object Name'
	, t.NAME AS 'Table Name'
	, i.NAME AS 'Index Name'
	, s.NAME AS 'Partition Scheme'
FROM sys.indexes i
INNER JOIN sys.partition_schemes s
	ON i.data_space_id = s.data_space_id
INNER JOIN sys.tables t
	ON i.object_id = t.object_id
