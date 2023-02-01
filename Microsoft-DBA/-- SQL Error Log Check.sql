-- SQL Error Log Check

DECLARE @Hours INT

SET @Hours = 72

CREATE TABLE #ErrorLog (
	LogDate DATETIME
	, ProcessInfo VARCHAR(50)
	, [Text] VARCHAR(4000)
	)

INSERT INTO #ErrorLog
EXEC sp_readerrorlog

DELETE
FROM #ErrorLog
WHERE LogDate < CAST(DATEADD(HH, - @Hours, GETDATE()) AS VARCHAR(23))

SELECT *
FROM #ErrorLog

DROP TABLE #ErrorLog
