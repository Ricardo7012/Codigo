-- http://iehpwiki.iehp.local/wiki/SQL_Server_Convert_to_KB-MB-GB
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-2017
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-master-files-transact-sql?view=sql-server-2017
-- http://www.onlineconversion.com/computer_base2.htm
SELECT d.name
	 --, mf.size AS [Size 8-KB pages] -- CURRENT FILE SIZE, IN 8-KB PAGES.
	 --, CONVERT(INT, SUM(mf.size) * 8) AS [Total disk space KB]
     , CONVERT(INT, SUM(mf.size) * 8 / 1024) AS [Total disk space MB]
	 --, CONVERT(INT, SUM(mf.size) * 8 / 1048576) AS [Total disk space GB]
	 --, CONVERT(INT, SUM(mf.size) * 8 / 1073741824) AS [Total disk space TB]  
FROM sys.databases        AS d
    JOIN sys.master_files AS mf
        ON d.database_id = mf.database_id
GROUP BY d.name
ORDER BY d.name;

