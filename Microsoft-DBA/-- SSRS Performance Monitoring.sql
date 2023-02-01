-- SSRS Performance Monitoring

SELECT REVERSE(LEFT(REVERSE(ReportPath), CHARINDEX('/', REVERSE(ReportPath), 1) - 1)) AS 'Report'
	, Username AS 'User Name'
	, Parameters AS 'Parameters'
	, TimeStart AS 'Time Start'
	, DATEDIFF(ms, TimeStart, TimeEnd) AS 'Total Duration (MS)'
	, TimedataRetrieval AS 'Duration Data Retrieval (MS)'
	, TimeProcessing AS 'Duration Processing (MS)'
	, TimeRendering AS 'Duration Rendering'
	, [RowCount] AS 'Row Cnt'
	, CAST(ByteCount / 1024.0 AS DECIMAL(18, 2)) as 'Report Size (KB)'
	, CAST(AdditionalInfo.query('data(/AdditionalInfo/ProcessingEngine)') AS VARCHAR(200)) AS 'Processing Engine'
	, CAST(AdditionalInfo.query('data(/AdditionalInfo/ScalabilityTime/Pagination)') AS VARCHAR(200)) AS 'Scalability Pagination'
	, CAST(AdditionalInfo.query('data(/AdditionalInfo/ScalabilityTime/Processing)') AS VARCHAR(200)) AS 'Scalability Processing'
	, CAST(AdditionalInfo.query('data(/AdditionalInfo/EstimatedMemoryUsageKB/Pagination)') AS VARCHAR(200)) AS 'Est Mem Pagination (KB)'
	, CAST(AdditionalInfo.query('data(/AdditionalInfo/EstimatedMemoryUsageKB/Processing)') AS VARCHAR(200)) AS 'Est Mem Processing (KB)'
	, CAST(AdditionalInfo.query('data(/AdditionalInfo/DataExtension/SQL)') AS VARCHAR(200)) AS 'DB Query Times'
FROM ExecutionLog2 WITH (NOLOCK)
WHERE ReportPath <> 'Unknown'
ORDER BY 'Time Start' DESC
