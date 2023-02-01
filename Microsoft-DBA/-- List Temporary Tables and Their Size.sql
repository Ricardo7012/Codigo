-- List Temporary Tables and Their Size 

SELECT TBL.NAME AS ObjName
	, STAT.row_count AS StatRowCount
	, STAT.used_page_count * 8 AS UsedSizeKB
	, STAT.reserved_page_count * 8 AS RevervedSizeKB
	, TBL.Create_Date
	, TBL.Modify_Date
FROM tempdb.sys.partitions AS PART
INNER JOIN tempdb.sys.dm_db_partition_stats AS STAT
	ON PART.partition_id = STAT.partition_id
		AND PART.partition_number = STAT.partition_number
INNER JOIN tempdb.sys.tables AS TBL
	ON STAT.object_id = TBL.object_id
ORDER BY TBL.NAME;
