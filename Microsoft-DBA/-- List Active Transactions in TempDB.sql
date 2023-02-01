-- List Active Transactions in TempDB

SELECT transaction_id AS 'Transacton ID'
	, [name] AS 'Transacton Name'
	, transaction_begin_time AS 'Transacton Begin Time'
	, DATEDIFF(mi, transaction_begin_time, GETDATE()) AS 'Elapsed Time (MIN)'
	, CASE transaction_type
		WHEN 1
			THEN 'Read / Write'
		WHEN 2
			THEN 'Read - Only'
		WHEN 3
			THEN 'System'
		WHEN 4
			THEN 'Distributed'
		END AS [TRANSACTION Type]
	, CASE transaction_state
		WHEN 0
			THEN 'The Transacton has NOT been completely initialized yet.'
		WHEN 1
			THEN 'The Transacton has been initialized but has NOT started.'
		WHEN 2
			THEN 'The Transacton IS active.'
		WHEN 3
			THEN 'The Transacton has ended.This IS used FOR READ - ONLY transactions.'
		WHEN 4
			THEN 'The COMMIT process has been initiated
				ON the DISTRIBUTED Transacton.This IS FOR DISTRIBUTED transactions ONLY.The DISTRIBUTED Transacton IS still active but further processing cannot take place.'
		WHEN 5
			THEN 'The Transacton IS IN a prepared STATE
				AND waiting resolution.'
		WHEN 6
			THEN 'The Transacton has been COMMITTED.'
		WHEN 7
			THEN 'The Transacton IS being rolled back.'
		WHEN 8
			THEN 'The Transacton has been rolled back.'
		END AS [TRANSACTION Description]
FROM sys.dm_tran_active_transactions
