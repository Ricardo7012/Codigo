select 
(select count(*)
from sys.tables
where type = 'u') as tables_countt,
(select count(*)
from sys.indexes
where type_desc in ('NONCLUSTERED','CLUSTERED')) as index_count,
(select count(*)
from sys.procedures
where type = 'p') as proc_count



select sum(x.indexcount)
from
(	SELECT SCH.name + '.' + TBL.name AS TableName, count(1) AS IndexCount
	FROM sys.tables AS TBL 
	INNER JOIN sys.schemas AS SCH ON TBL.schema_id = SCH.schema_id 
	INNER JOIN sys.indexes AS IDX ON TBL.object_id = IDX.object_id
	GROUP BY SCH.name + '.' + TBL.name
) x


select x.TableName, z.ColumnCount, x.IndexCount, ((x.IndexCount + 0.00)/z.ColumnCount) as Pcnt
from 
	(
		SELECT SCH.name + '.' + TBL.name AS TableName, count(1) AS IndexCount
		FROM sys.tables AS TBL 
		INNER JOIN sys.schemas AS SCH ON TBL.schema_id = SCH.schema_id 
		INNER JOIN sys.indexes AS IDX ON TBL.object_id = IDX.object_id
		GROUP BY SCH.name + '.' + TBL.name
	) x
	join
	(
		select TABLE_SCHEMA + '.' + TABLE_NAME as TableName, count(1) as ColumnCount
		from INFORMATION_SCHEMA.COLUMNS
		group by TABLE_SCHEMA  + '.' + TABLE_NAME
	) z
	on x.TableName = z.TableName



SELECT TOP 50
    creation_date = CAST(creation_time AS date),
    creation_hour = CASE
                        WHEN CAST(creation_time AS date) <> CAST(GETDATE() AS date) THEN 0
                        ELSE DATEPART(hh, creation_time)
                    END,
    SUM(1) AS plans
FROM sys.dm_exec_query_stats
GROUP BY CAST(creation_time AS date),
         CASE
             WHEN CAST(creation_time AS date) <> CAST(GETDATE() AS date) THEN 0
             ELSE DATEPART(hh, creation_time)
         END
ORDER BY 1 DESC, 2 DESC
