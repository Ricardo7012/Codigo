/*
IMPORTANT terms TO SEARCH errorlog

severity:
crash
dump
deadlock
victim
fatal
*/

exec sp_readerrorlog; --show the full most recent error log
exec sp_readerrorlog 1; --choose the next youngest log (default is 0 meaning current)
exec sp_readerrorlog 0, 1 --show current error log with log file type (same as the first command)
exec sp_readerrorlog 0, 1, 'error'; --grep current error log for keyword
exec sp_readerrorlog 0, 1, 'error', 'logging'; --an additional search parameter to refine


/*

DROP TABLE IF EXISTS #errorLog;  -- this is new syntax in SQL 2016 and later

CREATE TABLE #errorLog (LogDate DATETIME, ProcessInfo VARCHAR(64), [Text] VARCHAR(MAX));

INSERT INTO #errorLog
EXEC sp_readerrorlog 0 -- specify the log number or use nothing for active error log

SELECT * 
FROM #errorLog a
WHERE EXISTS (SELECT * 
              FROM #errorLog b
              WHERE [Text] like '%error%'
                AND a.LogDate = b.LogDate
                AND a.ProcessInfo = b.ProcessInfo)


*/