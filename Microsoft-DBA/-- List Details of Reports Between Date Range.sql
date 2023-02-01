-- List Details of Reports Between Date Range

DECLARE @TimeStart DATETIME
DECLARE @TimeEnd DATETIME

SET @TimeStart = '4/15/2017'
SET @TimeEnd = '4/17/2017'

SELECT ReportPath AS 'Report Path'
	, UserName AS 'User Name'
	, [Status] AS 'Status'
	, TimeStart AS 'Start Time'
	, TimeEnd AS 'End Time'
	, DATEDIFF(ss, TimeStart, TimeEnd) AS 'Elapsed Time (Sec)'
	, cast(TimeDataRetrieval / 1000.00 AS DECIMAL(16, 2)) AS 'Time Data Retrieval'
	, cast(TimeProcessing / 1000.00 AS DECIMAL(16, 2)) AS 'Time Processing'
	, cast(TimeRendering / 1000.00 AS DECIMAL(16, 2)) AS 'Time Rendering'
	, ByteCount AS 'Byte Count'
	, [RowCount] AS 'Row Count'
	, ISNULL(AdditionalInfo.value('(/AdditionalInfo/ScalabilityTime)[0]', 'int'), 0) AS 'Pagination Scalability Time'
	, ISNULL(AdditionalInfo.value('(/AdditionalInfo/ScalabilityTime)[1]', 'int'), 0) AS 'Processing Scalability Time'
	, ISNULL(AdditionalInfo.value('(/AdditionalInfo/ScalabilityTime)[0]', 'int'), 0) + ISNULL(AdditionalInfo.value('(/AdditionalInfo/ScalabilityTime)[1]', 'int'), 0) AS 'Total Scalability Time'
	, ISNULL(AdditionalInfo.value('(/AdditionalInfo/EstimatedMemoryUsageKB/Pagination)[1]', 'bigint'), 0) AS 'Pagination Est Mem Usage (KB)'
	, ISNULL(AdditionalInfo.value('(/AdditionalInfo/EstimatedMemoryUsageKB/Processing)[1]', 'bigint'), 0) AS 'Processing Est Mem Usage (KB)'
	, ISNULL(AdditionalInfo.value('(/AdditionalInfo/EstimatedMemoryUsageKB/Pagination)[1]', 'bigint'), 0) + ISNULL(AdditionalInfo.value('(/AdditionalInfo/EstimatedMemoryUsageKB/Processing)[1]', 'bigint'), 0) AS 'Total Est Mem Usage (KB)'
FROM ReportServer.dbo.ExecutionLog2
WHERE TimeStart BETWEEN @TimeStart
		AND @TimeEnd
ORDER BY 'Start Time'
