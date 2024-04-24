select
        DBName,
        name,
        [filename],
        size as 'Size(MB)',
        usedspace as 'UsedSpace(MB)',
        CAST((usedspace / size) AS DECIMAL(8,3))*100 as 'PercentUsedSpace',
		(size - usedspace) as 'AvailableFreeSpace(MB)',
		CAST(((size - usedspace) / size) AS DECIMAL(8,3))*100 as 'PercentFreeSpace'
from       
(   
SELECT
db_name(s.database_id) as DBName,
s.name AS [Name],
s.physical_name AS [FileName],
(s.size * CONVERT(float,8))/1024 AS [Size],
(CAST(CASE s.type WHEN 2 THEN 0 ELSE CAST(FILEPROPERTY(s.name, 'SpaceUsed') AS float)* CONVERT(float,8) END AS float))/1024 AS [UsedSpace],
s.file_id AS [ID]
FROM
--sys.filegroups AS g
--INNER JOIN sys.master_files AS s ON ((s.type = 2 or s.type = 0) and s.database_id = db_id() and (s.drop_lsn IS NULL)) AND (s.data_space_id=g.data_space_id)
	sys.master_files AS s 
WHERE s.database_id = db_id()
) DBFileSizeInfo
