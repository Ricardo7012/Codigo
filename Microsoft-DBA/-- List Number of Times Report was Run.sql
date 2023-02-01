-- List Number of Times Report was Run 

SELECT c.NAME AS 'Report Name'
	, COUNT(1) AS 'Total_Runs'
FROM ReportServer..Executionlog e
INNER JOIN ReportServer..CATALOG c
	ON (e.ReportID = c.ItemID)
GROUP BY c.NAME
ORDER BY 2 DESC
