/*
If most of the session waits type are( PAGEIOLATCH_ * , IO_COMPLETION, WRITELOG, ASYNC_IO_COMPLETION)
waits or similar, review below.
*/

--The below will provide the top SQL Statements by average I/O

select (total_logical_reads + total_logical_writes) /execution_count AS [AVERAGE_IO],  * 
from sys.dm_exec_query_stats CROSS APPLY sys.dm_exec_sql_text(sql_handle) order by  [AVERAGE_IO] desc;



-- Look at Pending I/O Requests by File

SELECT DB_NAME(mf.database_id) AS 'Database'
	, mf.physical_name AS 'Physical Name'
	, r.io_pending AS 'IO Pending'
	, r.io_pending_ms_ticks AS 'IO Pending MS ticks'
	, r.io_type AS 'IO Type'
	, fs.num_of_reads AS '# of Reads'
	, fs.num_of_writes AS '# of Writes'
FROM sys.dm_io_pending_io_requests AS r
INNER JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
	ON r.io_handle = fs.file_handle
INNER JOIN sys.master_files AS mf
	ON fs.database_id = mf.database_id
		AND fs.file_id = mf.file_id
ORDER BY r.io_pending
	, r.io_pending_ms_ticks DESC;
