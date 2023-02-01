-- List Failed Reports

SELECT C.Path AS 'Path'
	, C.NAME AS 'Name'
	, EL.UserName AS 'User Name'
	, EL.STATUS AS 'Status'
	, EL.TimeStart AS 'Start Time'
	, EL.[RowCount] AS 'Row Cnt'
	, EL.ByteCount AS 'Byte Cnt'
	, (EL.TimeDataRetrieval + EL.TimeProcessing + EL.TimeRendering) / 1000 AS 'Total Seconds'
	, EL.TimeDataRetrieval AS 'Time Data Retrieval'
	, EL.TimeProcessing AS 'Time Processing'
	, EL.TimeRendering AS 'Time Rendering'
FROM ExecutionLog EL
INNER JOIN CATALOG C
	ON EL.ReportID = C.ItemID
WHERE EL.STATUS <> 'rsSuccess'
ORDER BY TimeStart DESC
