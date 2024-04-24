--TABLES WITH NO INDEX
USE dbatools;
GO
;
WITH cte
AS (SELECT table_name = o.name,
           o.[object_id],
           i.index_id,
           i.type,
           i.type_desc
    FROM sys.indexes i
        INNER JOIN sys.objects o
            ON i.[object_id] = o.[object_id]
    WHERE o.type IN ( 'U' )
          AND o.is_ms_shipped = 0
          AND i.is_disabled = 0
          AND i.is_hypothetical = 0
          AND i.type <= 2),
     cte2
AS (SELECT *
    FROM cte c
        PIVOT
        (
            COUNT(type)
            FOR type_desc IN ([HEAP], [CLUSTERED], [NONCLUSTERED])
        ) pv)
SELECT c2.table_name,
       [rows] = MAX(p.rows),
       is_heap = SUM([HEAP]),
       is_clustered = SUM([CLUSTERED]),
       num_of_nonclustered = SUM([NONCLUSTERED])
FROM cte2 c2
    INNER JOIN sys.partitions p
        ON c2.[object_id] = p.[object_id]
           AND c2.index_id = p.index_id
GROUP BY table_name;
