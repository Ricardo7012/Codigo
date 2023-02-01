-- List Single & Double Query Plans

SELECT deqp.dbid AS 'DB ID'
	, deqp.objectid AS 'Object ID'
	, CAST(detqp.query_plan AS XML) AS 'Single Statement Plan'
	, deqp.query_plan AS 'Batch Query Plan'
	, ROW_NUMBER() OVER (
		ORDER BY Statement_Start_offset
		) AS query_position
	, CASE 
		WHEN deqs.statement_start_offset = 0
			AND deqs.statement_end_offset = - 1
			THEN '-- see objectText column--'
		ELSE '-- query --' + CHAR(13) + CHAR(10) + SUBSTRING(execText.TEXT, deqs.statement_start_offset / 2, (
					(
						CASE 
							WHEN deqs.statement_end_offset = - 1
								THEN DATALENGTH(execText.TEXT)
							ELSE deqs.statement_end_offset
							END
						) - deqs.statement_start_offset
					) / 2)
		END AS queryText
FROM sys.dm_exec_query_stats deqs
CROSS APPLY sys.dm_exec_text_query_plan(deqs.plan_handle, deqs.statement_start_offset, deqs.statement_end_offset) AS detqp
CROSS APPLY sys.dm_exec_query_plan(deqs.plan_handle) AS deqp
CROSS APPLY sys.dm_exec_sql_text(deqs.plan_handle) AS execText
WHERE deqp.objectid = OBJECT_ID('Proc_ReconstructPlayer', 'p');
