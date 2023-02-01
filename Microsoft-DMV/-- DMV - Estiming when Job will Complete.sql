SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT r.Percent_Complete
	, DATEDIFF(MINUTE, start_time, GETDATE()) AS Age
	, DATEADD(MINUTE, DATEDIFF(MINUTE, Start_Time, GETDATE()) /
		percent_complete * 100, Start_Time) AS EstimatedEndTime
	, t.Text AS ParentQuery
	, SUBSTRING (t.text,(r.statement_start_offset/2) + 1,
	((CASE WHEN r.statement_end_offset = -1
		THEN LEN(CONVERT(NVARCHAR(MAX), t.text)) * 2
		ELSE r.statement_end_offset
	END - r.statement_start_offset)/2) + 1) AS IndividualQuery
	, Start_Time
	, DB_NAME(Database_Id) AS DatabaseName
	, Status
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(sql_handle) t
WHERE session_id > 50
	AND percent_complete > 0
ORDER BY percent_complete DESC