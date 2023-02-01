-- List Report Time for Reports

SELECT ReportPath
	, UserName AS 'User Name'
	, Parameters AS 'Parameters'
	, TimeStart AS 'Time Start'
	, TimeEnd AS 'Time End'
	, cast(TimeDataRetrieval / 1000 AS VARCHAR) + ' Sec' AS 'Retrieval Time'
	, cast(TimeProcessing / 1000 AS VARCHAR) + ' Sec' AS 'Processing Time'
	, cast(TimeRendering / 1000 AS VARCHAR) + ' Sec' AS 'Rendering Time'
	, STATUS AS 'Status'
	, ByteCount / 1000 AS 'Reports Size (kb)'
	, [RowCount] AS 'Row Count'
FROM executionlog2
WHERE username LIKE '%A91DB\ssrsUser%'
	AND timestart BETWEEN '1/1/17'
		AND '1/25/17'
ORDER BY 'Time Start' DESC
