-- Current file size, in 8-KB pages. For a database snapshot, size reflects the maximum space that the snapshot can ever use for the file.
USE master;
GO
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-master-files-transact-sql?view=sql-server-ver15
SELECT b.[name]                                                        AS [DB_NAME]
     , a.[name]                                                        AS [LOGICAL_NAME]
     , a.[type_desc]                                                   AS [TYPE_DESC]
     , a.[size]                                                        AS [Size 8-KB pages]
     , CONVERT(DECIMAL(12, 2), (SUM(a.[size] * 8.00)))                 AS [KB]
     , CONVERT(DECIMAL(12, 2), (SUM(a.[size] * 8.00) / 1024.00))       AS [MB]
     , CONVERT(DECIMAL(12, 2), (SUM(a.[size] * 8.00) / 1048576.00))    AS [GB]
     , CONVERT(DECIMAL(12, 2), (SUM(a.[size] * 8.00) / 1073741824.00)) AS [TB]
     , a.physical_name                                                 AS [PHYSICAL_NAME]
FROM sys.master_files a
   , sys.databases b
WHERE a.database_id = b.database_id
--AND a.name LIKE '%mas%';
GROUP BY a.[name]
       , b.[name]
       , a.[size]
       , a.[type_desc]
       , a.[physical_name]
ORDER BY b.[name];
