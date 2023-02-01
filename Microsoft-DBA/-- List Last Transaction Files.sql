-- List Last Transaction Files

SELECT Database_Name
	, CONVERT(SMALLDATETIME, MAX(Backup_Finish_Date)) AS 'Last Tran Backup'
	, DATEDIFF(d, MAX(Backup_Finish_Date), Getdate()) AS 'Days Since Last'
FROM MSDB.dbo.BackupSet
WHERE Type = 'l'
GROUP BY Database_Name
ORDER BY 3 DESC
GO


