--LIST ALL DB DATA AND LOG FILE SIZES
SELECT [Database Name] = DB_NAME(database_id),
       [Type] = CASE WHEN Type_Desc = 'ROWS' THEN 'Data File(s)'
                     WHEN Type_Desc = 'LOG'  THEN 'Log File(s)'
					 WHEN Type_Desc IS NULL THEN 'Total Files'
					 ELSE Type_Desc END,
       [Size in MB] = CAST( ((SUM(Size)* 8.0) / 1024.0) AS DECIMAL(18,2) )
FROM   sys.master_files
-- Uncomment if you need to query for a particular database
-- WHERE      database_id = DB_ID('UCI_SOURCE_DATA')
GROUP BY      GROUPING SETS
              (
                     (DB_NAME(database_id), Type_Desc),
                     (DB_NAME(database_id))
              )
ORDER BY      DB_NAME(database_id), Type_Desc DESC, Type
GO


--FOR CURRENT DB
SELECT RTRIM(name) AS [Segment Name], groupid AS [Group Id], filename AS [File Name],
   CAST(size/128.0 AS DECIMAL(16,2)) AS [Allocated Size in MB],
   CAST(FILEPROPERTY(name, 'SpaceUsed')/128.0 AS DECIMAL(16,2)) AS [Space Used in MB],
   CAST([maxsize]/128.0 AS DECIMAL(16,2)) AS [Max in MB],
   CAST([maxsize]/128.0-(FILEPROPERTY(name, 'SpaceUsed')/128.0) AS DECIMAL(16,2)) AS [Available Space in MB],
   CAST((CAST(FILEPROPERTY(name, 'SpaceUsed')/128.0 AS DECIMAL(16,2))/CAST([maxsize]/128.0 AS DECIMAL(16,2)))*100 AS DECIMAL(16,2)) AS [Percent Used]
FROM sysfiles
ORDER BY groupid DESC


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



WITH fs
AS
(
    SELECT database_id, type, size * 8.0 / 1024 size
    FROM sys.master_files
)
SELECT 
    name,
    (SELECT SUM(size) FROM fs WHERE type = 0 and fs.database_id = db.database_id) DataFileSizeMB,
    (SELECT SUM(size) FROM fs WHERE type = 1 and fs.database_id = db.database_id) LogFileSizeMB
FROM sys.databases db
ORDER BY 1


SELECT
    DB_NAME(db.database_id) DatabaseName,
    (CAST(mfrows.RowSize AS FLOAT)*8)/1024 RowSizeMB,
    (CAST(mflog.LogSize AS FLOAT)*8)/1024 LogSizeMB,
    (CAST(mfstream.StreamSize AS FLOAT)*8)/1024 StreamSizeMB,
    (CAST(mftext.TextIndexSize AS FLOAT)*8)/1024 TextIndexSizeMB
FROM sys.databases db
    LEFT JOIN (SELECT database_id, SUM(size) RowSize FROM sys.master_files WHERE type = 0 GROUP BY database_id, type) mfrows ON mfrows.database_id = db.database_id
    LEFT JOIN (SELECT database_id, SUM(size) LogSize FROM sys.master_files WHERE type = 1 GROUP BY database_id, type) mflog ON mflog.database_id = db.database_id
    LEFT JOIN (SELECT database_id, SUM(size) StreamSize FROM sys.master_files WHERE type = 2 GROUP BY database_id, type) mfstream ON mfstream.database_id = db.database_id
    LEFT JOIN (SELECT database_id, SUM(size) TextIndexSize FROM sys.master_files WHERE type = 4 GROUP BY database_id, type) mftext ON mftext.database_id = db.database_id
ORDER BY DatabaseName


SELECT
    D.name AS DatabaseName,
    F.Name AS LogicalName,
    F.physical_name AS PhysicalFileLocation,
    F.state_desc AS OnlineStatus,
    CAST((F.size*8)/1024 AS VARCHAR(26)) + ' MB' AS FileSizeInMB,
    CAST(F.size*8 AS VARCHAR(32)) + ' Bytes' as FileSizeInBytes
FROM 
    sys.master_files F
    INNER JOIN sys.databases D ON D.database_id = F.database_id
ORDER BY
    D.name






SELECT     
DB_NAME(db.database_id) DatabaseName,     
(CAST(mfrows.RowSize AS FLOAT)*8)/1024 RowSizeMB,     
(CAST(mflog.LogSize AS FLOAT)*8)/1024 LogSizeMB, 
(CAST(mfrows.RowSize AS FLOAT)*8)/1024/1024+(CAST(mflog.LogSize AS FLOAT)*8)/1024/1024 DBSizeG,
(CAST(mfstream.StreamSize AS FLOAT)*8)/1024 StreamSizeMB,     
(CAST(mftext.TextIndexSize AS FLOAT)*8)/1024 TextIndexSizeMB
FROM sys.databases db     
	LEFT JOIN (SELECT database_id, 
					  SUM(size) RowSize 
				FROM sys.master_files 
				WHERE type = 0 
				GROUP BY database_id, type) mfrows 
		ON mfrows.database_id = db.database_id     
	LEFT JOIN (SELECT database_id, 
					  SUM(size) LogSize 
				FROM sys.master_files 
				WHERE type = 1 
				GROUP BY database_id, type) mflog 
		ON mflog.database_id = db.database_id     
	LEFT JOIN (SELECT database_id, 
					  SUM(size) StreamSize 
					  FROM sys.master_files 
					  WHERE type = 2 
					  GROUP BY database_id, type) mfstream 
		ON mfstream.database_id = db.database_id     
	LEFT JOIN (SELECT database_id, 
					  SUM(size) TextIndexSize 
					  FROM sys.master_files 
					  WHERE type = 4 
					  GROUP BY database_id, type) mftext 
		ON mftext.database_id = db.database_id 
ORDER BY DatabaseName






SELECT
    DB.name,
    SUM(CASE WHEN type = 0 THEN MF.size * 8 / 1024 ELSE 0 END) AS DataFileSizeMB,
    SUM(CASE WHEN type = 1 THEN MF.size * 8 / 1024 ELSE 0 END) AS LogFileSizeMB
FROM
    sys.master_files MF
    JOIN sys.databases DB ON DB.database_id = MF.database_id
GROUP BY DB.name
ORDER BY DataFileSizeMB DESC




SELECT
DB_NAME(db.database_id) DatabaseName,
(CAST(mfrows.RowSize AS FLOAT)*8)/1024 RowSizeMB,
(CAST(mflog.LogSize AS FLOAT)*8)/1024 LogSizeMB
FROM sys.databases db
LEFT JOIN (SELECT database_id, SUM(size) RowSize FROM sys.master_files WHERE type = 0 GROUP BY database_id, type) mfrows ON mfrows.database_id = db.database_id
LEFT JOIN (SELECT database_id, SUM(size) LogSize FROM sys.master_files WHERE type = 1 GROUP BY database_id, type) mflog ON mflog.database_id = db.database_id
where DB_NAME(db.database_id) not like 'master'
and DB_NAME(db.database_id) not like 'msdb'
and DB_NAME(db.database_id) not like 'model'
and DB_NAME(db.database_id) not like 'tempdb'
and DB_NAME(db.database_id) not like 'Northwind'
and DB_NAME(db.database_id) not like 'ReportServer'
order by DB_NAME(db.database_id)

