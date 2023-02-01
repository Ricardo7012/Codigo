-- Check Days, Hours, Minutes and Seconds on Dates

DECLARE @StartTime DATETIME
DECLARE @EndTime DATETIME

SET @StartTime = '2015-11-09 10:52:35.000'
SET @EndTime = '2015-11-10 10:52:35.000'

SELECT CAST((DATEDIFF(HOUR, @StartTime, @EndTime) / 24) AS VARCHAR) + ' : ' + CAST((DATEDIFF(HOUR, @StartTime, @EndTime) % 24) AS VARCHAR) + ' : ' + CASE 
		WHEN DATEPART(SECOND, @EndTime) >= DATEPART(SECOND, @StartTime)
			THEN CAST((DATEDIFF(MINUTE, @StartTime, @EndTime) % 60) AS VARCHAR)
		ELSE CAST((DATEDIFF(MINUTE, DATEADD(MINUTE, - 1, @EndTime), @EndTime) % 60) AS VARCHAR)
		END + ' : ' + CAST((DATEDIFF(SECOND, @StartTime, @EndTime) % 60) AS VARCHAR) AS '[DD : HH : MM : SS]'
	, CAST((DATEDIFF(HOUR, @StartTime, @EndTime) / 24) AS VARCHAR) + ' Days ' + CAST((DATEDIFF(HOUR, @StartTime, @EndTime) % 24) AS VARCHAR) + ' Hours ' + CASE 
		WHEN DATEPART(SECOND, @EndTime) >= DATEPART(SECOND, @StartTime)
			THEN CAST((DATEDIFF(MINUTE, @StartTime, @EndTime) % 60) AS VARCHAR)
		ELSE CAST((DATEDIFF(MINUTE, DATEADD(MINUTE, - 1, @EndTime), @EndTime) % 60) AS VARCHAR)
		END + ' Minutes ' + CAST((DATEDIFF(SECOND, @StartTime, @EndTime) % 60) AS VARCHAR) + ' Seconds ' AS 'String Format'
