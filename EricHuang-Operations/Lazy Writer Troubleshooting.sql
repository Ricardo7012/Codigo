--obtain the Lazy Writes value by querying the sys.dm_os_performance_counters view, like for other Buffer Manager counters	
SELECT object_name, counter_name, cntr_value, cntr_type
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Buffer Manager%'
AND [counter_name] = 'Lazy writes/sec'

--But, the value returned is higher by several orders of magnitude from the recommended minimum

/*
The reason for this is that the value shown for the cntr_type 272696576 in the view is incremental 
and represents the total number of lazy writes from the last server restart. To find the number of 
Lazy Writes in a second, find the difference in the Lazy Writes counter values in two specific 
moments and divide by the time 
*/

DECLARE @LazyWrites1 bigint;

SELECT @LazyWrites1 = cntr_value
  FROM sys.dm_os_performance_counters
  WHERE counter_name = 'Lazy writes/sec';
 
WAITFOR DELAY '00:00:10';
 
SELECT(cntr_value - @LazyWrites1) / 10 AS 'LazyWrites/sec'
  FROM sys.dm_os_performance_counters
  WHERE counter_name = 'Lazy writes/sec';