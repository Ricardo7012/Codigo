
-- http://technet.microsoft.com/en-us/library/ms190326.aspx
SELECT 
  database_id
, [file_id]
, sample_ms
, num_of_reads
, num_of_bytes_read
, io_stall_read_ms
, num_of_writes
, num_of_bytes_written
, io_stall_write_ms
, io_stall
, size_on_disk_bytes
, file_handle
FROM sys.dm_io_virtual_file_stats(DB_ID(N'ReportServer'), 2);

-- http://technet.microsoft.com/en-us/library/ms188762.aspx
SELECT 
 io_completion_request_address
, io_type
, io_pending_ms_ticks
, io_pending
, io_completion_routine_address
, io_user_data_address
, scheduler_address
, io_handle
, io_offset
FROM sys.dm_io_pending_io_requests
GO
