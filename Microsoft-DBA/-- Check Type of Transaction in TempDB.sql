-- Check Type of Transaction in TempDB

SELECT transaction_id AS 'Trans ID'
	, [name] AS 'Trans Name'
	, transaction_begin_time AS 'Trans Start Time'
	, DATEDIFF(mi, transaction_begin_time, GETDATE()) AS 'Elapsed Time (MIN)'
	, CASE transaction_type
		WHEN 1
			THEN 'Read/write'
		WHEN 2
			THEN 'Read-only'
		WHEN 3
			THEN 'System'
		WHEN 4
			THEN 'Distributed'
		END AS 'Trans Type'
	, CASE transaction_state
		WHEN 0
			THEN 'The transaction has not been completely initialized yet.'
		WHEN 1
			THEN 'The transaction has been initialized but has not started.'
		WHEN 2
			THEN 'The transaction is active.'
		WHEN 3
			THEN 'The transaction has ended. This is used for read-only transactions.'
		WHEN 4
			THEN 'The commit process has been initiated on the distributed transaction. This is for distributed transactions only. The distributed transaction is still active but further processing cannot take place.'
		WHEN 5
			THEN 'The transaction is in a prepared state and waiting resolution.'
		WHEN 6
			THEN 'The transaction has been committed.'
		WHEN 7
			THEN 'The transaction is being rolled back.'
		WHEN 8
			THEN 'The transaction has been rolled back.'
		END AS 'Trans Desc'
FROM sys.dm_tran_active_transactions
