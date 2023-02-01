-- DMV - List Transactions per Second for Database

DECLARE @ctr BIGINT
DECLARE @DatabaseName nvarchar(25)

SET @DatabaseName = 'PlayerManagement'

SELECT @ctr = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'transactions/sec'
	AND object_name = 'SQLServer:Databases'
	AND instance_name = @DatabaseName

WAITFOR DELAY '00:00:01'

SELECT cntr_value - @ctr
FROM sys.dm_os_performance_counters
WHERE counter_name = 'transactions/sec'
	AND object_name = 'SQLServer:Databases'
	AND instance_name = @DatabaseName
