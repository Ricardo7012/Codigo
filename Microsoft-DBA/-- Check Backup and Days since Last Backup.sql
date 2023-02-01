-- Check Backup and Days since Last Backup

SELECT Database_Name AS 'DB Name'
	, CONVERT(SMALLDATETIME, MAX(Backup_Finish_Date)) AS 'Last Backup'
	, DATEDIFF(d, MAX(Backup_Finish_Date), Getdate()) AS 'Days Since last Backup'
FROM MSDB.dbo.BackupSet
WHERE Type = 'D'
GROUP BY Database_Name
ORDER BY Database_Name ASC
GO