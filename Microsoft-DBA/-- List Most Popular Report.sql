-- List Most Popular Report

SELECT C.Path AS 'Path'
	, C.NAME AS 'Name'
	, Count(*) AS 'Reports Run'
	, AVG((EL.TimeDataRetrieval + EL.TimeProcessing + EL.TimeRendering)) AS 'Avg Processing Time'
	, Max((EL.TimeDataRetrieval + EL.TimeProcessing + EL.TimeRendering)) AS 'Max Processing Time'
	, Min((EL.TimeDataRetrieval + EL.TimeProcessing + EL.TimeRendering)) AS 'Min ProcessingTime'
FROM ExecutionLog EL
INNER JOIN CATALOG C
	ON EL.ReportID = C.ItemID
WHERE EL.TimeStart > Datediff(d, GetDate(), - 28)
GROUP BY C.Path
	, C.NAME
ORDER BY Count(*) DESC
