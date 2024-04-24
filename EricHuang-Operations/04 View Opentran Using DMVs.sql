DECLARE @spid INT
DECLARE @db VARCHAR(32)

SET NOCOUNT ON

SET @db = ''  -- Leave blank if you want to see all opentran on all DBs

SELECT dd.database_id AS [DBID], DB_NAME(dd.database_id) AS [DBNAME],
	   dd.transaction_id,
       ds.session_id,
       database_transaction_begin_time,
       CASE database_transaction_type
         WHEN 1 THEN 'Read/write transaction'
         WHEN 2 THEN 'Read-only transaction'
         WHEN 3 THEN 'System transaction'
       END database_transaction_type,
       CASE database_transaction_state
         WHEN 1 THEN 'The transaction has not been initialized.'
         WHEN 3 THEN 'The transaction has been initialized but has not generated any log records.'
         WHEN 4 THEN 'The transaction has generated log records.'
         WHEN 5 THEN 'The transaction has been prepared.'
         WHEN 10 THEN 'The transaction has been committed.'
         WHEN 11 THEN 'The transaction has been rolled back.'
         WHEN 12 THEN 'The transaction is being committed. In this state the log record is being generated, but it has not been materialized or persisted'
       END database_transaction_state,
       database_transaction_log_bytes_used,
       database_transaction_log_bytes_reserved,
       database_transaction_begin_lsn,
       database_transaction_last_lsn
FROM   sys.dm_tran_database_transactions dd
       INNER JOIN sys.dm_tran_session_transactions ds
           ON ds.transaction_id = dd.transaction_id
WHERE
	dd.database_id = ISNULL(DB_ID(@db), dd.database_id)
	AND database_transaction_begin_time IS NOT NULL
ORDER BY database_transaction_begin_time ASC

SELECT TOP 1 @spid = ds.session_id
	FROM   sys.dm_tran_database_transactions dd
		   INNER JOIN sys.dm_tran_session_transactions ds
			   ON ds.transaction_id = dd.transaction_id
	WHERE
		dd.database_id = ISNULL(DB_ID(@db), dd.database_id)
		AND database_transaction_begin_time IS NOT NULL
	ORDER BY database_transaction_begin_time ASC

DBCC INPUTBUFFER(@spid)

EXEC SP_WHO2 @spid
