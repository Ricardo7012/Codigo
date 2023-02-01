-- Check File for IO Stall

SELECT database_id AS 'DB ID'
	, file_id AS 'File ID'
	, io_stall AS 'I/O Stall'
	, io_pending_ms_ticks AS 'I/O Pending (MS) Ticks'
	, scheduler_address AS 'Scheduler Address'
FROM sys.dm_io_virtual_file_stats(NULL, NULL) iovfs
	, sys.dm_io_pending_io_requests AS iopior
WHERE iovfs.file_handle = iopior.io_handle
