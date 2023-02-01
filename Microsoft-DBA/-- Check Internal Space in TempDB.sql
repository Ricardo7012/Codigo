-- Check Internal Space in TempDB

WITH task_space_usage
AS (
	-- SUM alloc/delloc pages
	SELECT session_id AS 'SID'
		, request_id
		, SUM(internal_objects_alloc_page_count) AS 'Alloc_pages'
		, SUM(internal_objects_dealloc_page_count) AS 'dealloc_pages'
	FROM sys.dm_db_task_space_usage WITH (NOLOCK)
	WHERE session_id <> @@SPID
	GROUP BY session_id
		, request_id
	)
SELECT TSU.SID
	, TSU.alloc_pages * 1.0 / 128 AS 'Internal object (MB) space'
	, TSU.dealloc_pages * 1.0 / 128 AS 'Internal object dealloc (MB) space'
	, EST.text AS 'Text'
	,
	-- Extract statement from sql text
	ISNULL(NULLIF(SUBSTRING(EST.TEXT, ERQ.statement_start_offset / 2, CASE 
					WHEN ERQ.statement_end_offset < ERQ.statement_start_offset
						THEN 0
					ELSE (ERQ.statement_end_offset - ERQ.statement_start_offset) / 2
					END), ''), EST.TEXT) AS 'SQL Script'
	, EQP.query_plan AS 'Query Plan'
FROM task_space_usage TSU
INNER JOIN sys.dm_exec_requests ERQ WITH (NOLOCK)
	ON TSU.SID = ERQ.session_id
		AND TSU.request_id = ERQ.request_id
OUTER APPLY sys.dm_exec_sql_text(ERQ.sql_handle) EST
OUTER APPLY sys.dm_exec_query_plan(ERQ.plan_handle) EQP
WHERE EST.TEXT IS NOT NULL
	OR EQP.query_plan IS NOT NULL
ORDER BY 3 DESC;
