-- List Backup Counts

SELECT sdb.NAME AS 'DB Name'
	, COALESCE(CONVERT(VARCHAR(12), MAX(bus.backup_finish_date), 101), '-') AS 'Last Back Up Time'
	, COUNT(*) AS 'DB Backup Count'
FROM sys.sysdatabases sdb
LEFT JOIN msdb.dbo.backupset bus
	ON bus.database_name = sdb.NAME
GROUP BY sdb.NAME
