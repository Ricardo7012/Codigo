-- IO Latch Type per SQL Server

SELECT *
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'PAGEIOLATCH%'
ORDER BY wait_type ASC

SELECT database_id
	, file_id
	, io_stall
	, io_pending_ms_ticks
	, scheduler_address
FROM sys.dm_io_virtual_file_stats(NULL, NULL) iovfs
	, sys.dm_io_pending_io_requests AS iopior
WHERE iovfs.file_handle = iopior.io_handle
