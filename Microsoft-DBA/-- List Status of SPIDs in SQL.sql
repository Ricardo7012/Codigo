-- List Status of SPIDs in SQL

SELECT spid AS 'SPID'
	, status AS 'Status'
	, loginame AS 'Login Name'
	, hostname AS 'Host Name'
	, DB_NAME(dbid) AS 'DBName'
	, cmd AS 'CMD'
	, cpu AS 'CPU'
	, physical_io AS 'I/O'
	, last_batch AS 'Last Batch'
	, program_name AS 'Program Name'
FROM SYS.SYSPROCESSES
WHERE 1 = CASE 
		WHEN STATUS IN (
				'RUNNABLE'
				, 'SUSPENDED'
				)
			THEN 1
				--Transactions that are open not yet committed or rolledback
		WHEN STATUS = 'SLEEPING'
			AND open_tran > 0
			THEN 1
		ELSE 0
		END
	AND cmd NOT LIKE 'BACKUP%'