
SELECT SUM(user_object_reserved_page_count) * 8 AS user_obj_kb,
	SUM(internal_object_reserved_page_count) * 8 AS internal_obj_kb,
	SUM(version_store_reserved_page_count) * 8 AS version_store_kb,
	SUM(unallocated_extent_page_count) * 8 AS freespace_kb,
	SUM(mixed_extent_page_count) * 8 AS mixedextent_kb
FROM sys.dm_db_file_space_usage


--SQL Server 2012 +
SELECT file_id,
	filegroup_id,
	total_page_count,
	allocated_extent_page_count,
	unallocated_extent_page_count,
	mixed_extent_page_count,
	version_store_reserved_page_count,
	user_object_reserved_page_count,
	internal_object_reserved_page_count
FROM sys.dm_db_file_space_usage

--SQL Server 2008 R2 and lower versions till 2005
SELECT file_id,
	unallocated_extent_page_count,
	mixed_extent_page_count,
	version_store_reserved_page_count,
	user_object_reserved_page_count,
	internal_object_reserved_page_count
FROM sys.dm_db_file_space_usage


SELECT session_id,
	user_objects_alloc_page_count/128 AS user_objs_total_sizeMB,
	(user_objects_alloc_page_count - user_objects_dealloc_page_count)/128.0 AS user_objs_active_sizeMB,
	internal_objects_alloc_page_count/128 AS internal_objs_total_sizeMB,
	(internal_objects_alloc_page_count - internal_objects_dealloc_page_count)/128.0 AS internal_objs_active_sizeMB
FROM sys.dm_db_session_space_usage
ORDER BY user_objects_alloc_page_count DESC
go
sp_who2 2979
go



SELECT t.task_address, 
	t.parent_task_address,
	tsu.session_id,
	tsu.request_id,
	t.exec_context_id,
	tsu.user_objects_alloc_page_count/128 AS Total_UserMB,
	(tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)/128.0 AS Acive_UserMB,
	tsu.internal_objects_alloc_page_count/128 AS Total_IntMB,
	(tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count)/128.0 AS Active_IntMB,
	t.task_state,
	t.scheduler_id,
	t.worker_address
FROM sys.dm_db_task_space_usage tsu
INNER JOIN sys.dm_os_tasks t
ON tsu.session_id = t.session_id
AND tsu.exec_context_id = t.exec_context_id
WHERE tsu.session_id > 50
ORDER BY tsu.session_id


SELECT task_address,
	task_state,
	context_switches_count AS switches,
	pending_io_count AS ioPending,
	pending_io_byte_count AS ioBytes,
	pending_io_byte_average AS ioBytesAvg,
	scheduler_id,
	session_id,
	exec_context_id,
	request_id,
	worker_address,
	parent_task_address
FROM sys.dm_os_tasks
WHERE session_id > 50
ORDER BY switches DESC
GO
sp_Who2 93
GO



SELECT ot.session_id,
	 ow.pending_io_count,
	 CASE ow.wait_started_ms_ticks
		  WHEN 0 THEN 0
		  ELSE (osi.ms_ticks - ow.wait_started_ms_ticks)/1000 END AS Suspended_wait,
	 CASE ow.wait_resumed_ms_ticks
		  WHEN 0 THEN 0
		  ELSE (osi.ms_ticks - ow.wait_resumed_ms_ticks)/1000 END AS Runnable_wait,
	 (osi.ms_ticks - ow.task_bound_ms_ticks)/1000 AS task_time,
	 (osi.ms_ticks - ow.worker_created_ms_ticks)/1000 AS worker_time,
	 ow.end_quantum - ow.start_quantum AS last_worker_quantum,
	 ow.state,
	 ow.last_wait_type,
	 ow.affinity,
	 ow.quantum_used,
	 ow.tasks_processed_count
FROM sys.dm_os_workers ow
INNER JOIN sys.dm_os_tasks ot
ON ow.task_address = ot.task_address
CROSS JOIN sys.dm_os_sys_info osi
WHERE ot.session_id > 50
AND is_preemptive = 0

