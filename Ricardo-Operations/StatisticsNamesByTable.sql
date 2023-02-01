USE [HSP];
GO
SELECT s.name AS statistics_name
     , c.name AS column_name
     , sc.stats_column_id
	 , t.name as [TABLENAME]
	 , s.object_id
FROM sys.stats                   AS s
    INNER JOIN sys.stats_columns AS sc
        ON s.object_id = sc.object_id
           AND s.stats_id = sc.stats_id
    INNER JOIN sys.columns       AS c
        ON sc.object_id = c.object_id
           AND c.column_id = sc.column_id
	 LEFT JOIN sys.tables AS t
        ON s.object_id = t.object_id
           
