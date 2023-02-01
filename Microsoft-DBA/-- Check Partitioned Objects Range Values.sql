-- Check Partitioned Objects Range Values

SELECT p.[object_id]
	, OBJECT_NAME(p.[object_id]) AS TbName
	, p.index_id
	, p.partition_number
	, p.rows
	, index_name = i.[name]
	, index_type_desc = i.type_desc
	, i.data_space_id
	, ds1.NAME AS [FILEGROUP_NAME]
	, pf.function_id
	, pf.[name] AS Pf_Name
	, pf.type_desc
	, pf.boundary_value_on_right
	, destination_data_space_id = dds.destination_id
	, prv.parameter_id
	, prv.value
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
INNER JOIN sys.destination_data_spaces dds
	ON dds.partition_scheme_id = ds.data_space_id
		AND p.partition_number = dds.destination_id
INNER JOIN sys.data_spaces ds1
	ON ds1.data_space_id = dds.data_space_id
LEFT JOIN sys.partition_range_values prv
	ON prv.function_id = ps.function_id
		AND p.partition_number = prv.boundary_id
--WHERE p.[object_id] = object_id('thename')
ORDER BY TbName
	, p.index_id, p.partition_number;
GO


