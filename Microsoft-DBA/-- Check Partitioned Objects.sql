-- Check Partitioned Objects

SELECT DISTINCT p.[object_id]
	, TbName = OBJECT_NAME(p.[object_id])
	, index_name = i.[name]
	, index_type_desc = i.type_desc
	, partition_scheme = ps.[name]
	, data_space_id = ps.data_space_id
	, function_name = pf.[name]
	, function_id = ps.function_id
FROM sys.partitions p
INNER JOIN sys.indexes i
	ON p.[object_id] = i.[object_id]
		AND p.index_id = i.index_id
INNER JOIN sys.data_spaces ds
	ON i.data_space_id = ds.data_space_id
INNER JOIN sys.partition_schemes ps
	ON ds.data_space_id = ps.data_space_id
INNER JOIN sys.partition_functions pf
	ON ps.function_id = pf.function_id
-- WHERE p.[object_id] = object_id('JBMTest')
ORDER BY TbName, index_name;
GO