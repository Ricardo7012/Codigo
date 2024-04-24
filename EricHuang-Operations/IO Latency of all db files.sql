/*
Microsoft’s recommendation is that data file latency should not exceed 20ms, 
and log file latency should not exceed 10ms. But in practice, a latency that 
is twice as high as the recommendations is often acceptable to most users.
*/

SELECT physical_name AS drive,
  CAST(SUM(io_stall_read_ms) / (1.0 + SUM(num_of_reads))
AS NUMERIC(10, 1)) AS 'Avg Read Latency/ms',
  CAST(SUM(io_stall_write_ms) / (1.0 +
SUM(num_of_writes)) AS NUMERIC(10, 1)) AS 'Avg Write
Latency/ms',
  CAST((SUM(io_stall)) / (1.0 + SUM(num_of_reads +
num_of_writes)) AS NUMERIC(10, 1)) AS 'Avg Disk
Latency/ms'
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS d
  JOIN sys.master_files AS m
       ON m.database_id = d.database_id
       AND m.file_id = d.file_id
GROUP BY physical_name
ORDER BY physical_name DESC;