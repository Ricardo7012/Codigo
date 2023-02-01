-- List Report Time

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SELECT @StartDate = '1/1/2017'
SELECT @EndDate = '1/25/2017'

SELECT c.NAME AS 'Name'
	, c.Path AS 'Path'
	, COUNT(*) AS 'Executions'
	, CAST(AVG(DATEDIFF(ms, TimeStart, TimeEnd) * 1.) AS DECIMAL(12, 2)) AS 'Average Execution Time'
	, CAST(SUM(el.TimeDataRetrieval) / (COUNT(*) * 1.) AS DECIMAL(12, 2)) AS 'Average Time Data Retrieval'
	, CAST(SUM(el.TimeProcessing) / (COUNT(*) * 1.) AS DECIMAL(12, 2)) AS 'Average Time Processing'
	, CAST(SUM(el.TimeRendering) / (COUNT(*) * 1.) AS DECIMAL(12, 2)) AS 'Average Time Rendering'
	, CAST((
			SELECT ' Count = "' + CAST(COUNT(*) AS VARCHAR) + '"' + ' Value = "' + COALESCE(CAST(iel.Parameters AS VARCHAR(max)), '-NONE-') + '"' AS Parameters
			FROM dbo.ExecutionLog iel
			WHERE iel.TimeStart BETWEEN MIN(el.TimeStart)
					AND MAX(el.TimeStart)
				AND iel.ReportID = el.ReportID
			GROUP BY COALESCE(CAST(iel.Parameters AS VARCHAR(max)), '-NONE-')
			ORDER BY COUNT(*) DESC
			FOR XML PATH('')
			) AS XML) AS 'Parameters'
FROM dbo.ExecutionLog el
INNER JOIN dbo.Catalog c
	ON el.ReportID = c.ItemID
WHERE el.TimeStart BETWEEN @StartDate
		AND @EndDate
GROUP BY c.NAME
	, c.Path
	, el.ReportID
ORDER BY SUM(el.TimeDataRetrieval) DESC
