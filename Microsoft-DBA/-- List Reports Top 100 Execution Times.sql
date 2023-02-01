-- List Reports Top 100 Execution Times

SELECT TOP 100 ExecutionLog.TimeStart AS 'Start Time'
	, ExecutionLog.STATUS AS 'Status'
	, RSCatalog.Path AS 'Path'
	, RSCatalog.NAME AS 'Report'
	, ExecutionLog.UserName AS 'User Name'
	, ExecutionLog.Format AS 'Format'
	, ExecutionLog.Parameters AS 'Parameters'
FROM [ReportServer].[dbo].[ExecutionLog] ExecutionLog
INNER JOIN [ReportServer].[dbo].[Catalog] RSCatalog
	ON ExecutionLog.ReportID = RSCatalog.ItemID
ORDER BY ExecutionLog.TimeStart DESC
