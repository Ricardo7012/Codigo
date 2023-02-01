SET QUOTED_IDENTIFIER ON

EXEC sp_msforeachdb "
IF '?' not in ('tempdb')
begin
    use [?] 
	EXEC ('sys.sp_databases;')
    print '?'
end
"
SET QUOTED_IDENTIFIER OFF

-- https://docs.microsoft.com/en-us/sql/t-sql/functions/fileproperty-transact-sql
-- SPACEUSED = PAGES
SELECT *, FILEPROPERTY(name, 'SpaceUsed') AS used FROM dbo.sysfiles

SELECT * FROM sys.database_files
EXEC sys.sp_spaceused @updateusage = N'true'
DBCC SQLPERF(logspace)
EXEC sys.sp_databases

--SELECT * FROM sys.dm_db_file_space_usage

SELECT DB_NAME() AS DbName, 
name AS FileName, 
size/128.0 AS CurrentSizeMB, 
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB 
FROM sys.database_files; 


;WITH t(s) AS
(
  SELECT CONVERT(DECIMAL(18,2), SUM(size)*8/1024.0)
   FROM sys.database_files
   WHERE [type] % 2 = 0
), 
d(s) AS
(
  SELECT CONVERT(DECIMAL(18,2), SUM(total_pages)*8/1024.0)
   FROM sys.partitions AS p
   INNER JOIN sys.allocation_units AS a 
   ON p.[partition_id] = a.container_id
)
SELECT 
  Allocated_Space = t.s, 
  Available_Space = t.s - d.s,
  [Available_%] = CONVERT(DECIMAL(5,2), (t.s - d.s)*100.0/t.s)
FROM t CROSS APPLY d;


-- Individual File Sizes and space available for current database
-- (Query 36) (File Sizes and Space)
SELECT f.name AS [File Name] , f.physical_name AS [Physical Name], 
CAST((f.size/128.0) AS DECIMAL(15,2)) AS [Total Size in MB],
CAST(f.size/128.0 - CAST(FILEPROPERTY(f.name, 'SpaceUsed') AS int)/128.0 AS DECIMAL(15,2)) 
AS [Available Space In MB], [file_id], fg.name AS [Filegroup Name]
FROM sys.database_files AS f WITH (NOLOCK) 
LEFT OUTER JOIN sys.data_spaces AS fg WITH (NOLOCK) 
ON f.data_space_id = fg.data_space_id OPTION (RECOMPILE);


SELECT fg.data_space_id AS FGID,
   (f.file_id) AS File_Id,
   -- As provided by OP, size on disk in bytes.
   REPLACE(CONVERT(VARCHAR,CONVERT(MONEY, CAST(f.size AS FLOAT) * 8.00 * 1024), 1), '.00','') AS Size_On_Disk_Bytes,
   ROUND((CAST(f.size AS FLOAT) * 8.00/1024)/1024,3) AS Actual_File_Size,
   ROUND(CAST((f.size) AS FLOAT)/128,2) AS Reserved_MB,
   ROUND(CAST((FILEPROPERTY(f.name,'SpaceUsed')) AS FLOAT)/128,2) AS Used_MB,
   ROUND((CAST((f.size) AS FLOAT)/128)-(CAST((FILEPROPERTY(f.name,'SpaceUsed'))AS FLOAT)/128),2) AS Free_MB,
   f.name,
   f.physical_name
FROM sys.database_files f 
    LEFT JOIN sys.filegroups fg
    ON f.data_space_id = fg.data_space_id