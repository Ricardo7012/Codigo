-- Check TPS over a Given Time

SELECT cntr_value
	, Counter_Name
	, Object_Name
FROM sys.dm_os_performance_counters
WHERE counter_name = 'transactions/sec'

DECLARE @cntr_value BIGINT;
DECLARE @loopcount BIGINT

SET @loopcount = 10

SELECT @cntr_value = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'transactions/sec'
	AND object_name = 'SQLServer:Databases                                                                                                             '
	AND instance_name = 'tpcc';

PRINT @cntr_value;

WAITFOR DELAY '00:00:01'

--
-- Start loop to collect TPM every minute
--

WHILE @loopcount <> 0
BEGIN
	SELECT @cntr_value = cntr_value
	FROM sys.dm_os_performance_counters
	WHERE counter_name = 'transactions/sec'
		AND object_name = 'MSSQL$DBIO:Databases'
		AND instance_name = 'tpcc';

	PRINT @cntr_value;

	WAITFOR DELAY '00:01:00'

	SET @loopcount = @loopcount - 1
END

--
-- All done with loop, write out the last value
--
SELECT @cntr_value = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'transactions/sec'
	AND object_name = 'SQLServer:Databases'
	AND instance_name = 'tpcc';

PRINT @cntr_value;
	--
	-- End of script
	-- 
