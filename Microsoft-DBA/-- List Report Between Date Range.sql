-- List Report Between Date Range

DECLARE @TimeStart DATETIME
DECLARE @TimeEnd DATETIME

SET @TimeStart = '4/15/2017'
SET @TimeEnd = '4/17/2017'

SELECT c.NAME AS 'Report Name'
	, e.UserName AS 'User Name'
	, e.STATUS AS 'Status'
	, e.Format AS 'Format'
	, e.Parameters AS 'Parameters'
	, e.Timestart AS 'Start Time'
	, e.TimeEnd AS 'End time'
	, datediff(mi, e.Timestart, e.TimeEnd) 'Execution Time'
	, cast(e.TimeDataRetrieval / 1000.00 AS DECIMAL(16, 2)) AS 'Time Data Retrieval'
	, cast(e.TimeProcessing / 1000.00 AS DECIMAL(16, 2)) AS 'Time Processing'
	, cast(e.TimeRendering / 1000.00 AS DECIMAL(16, 2)) AS 'Time Rendering'
FROM ReportServer..Executionlog e
INNER JOIN ReportServer..CATALOG c
	ON (e.ReportID = c.ItemID)
WHERE convert(VARCHAR, e.TimeStart, 101) BETWEEN @TimeStart
		AND @TimeEnd
ORDER BY e.TimeStart DESC
