SELECT cpu_count,
       hyperthread_ratio,
       --physical_memory_kb,
	   --physical_memory_kb/1024 AS MemoryMB,
	   physical_memory_kb/1024/1024 AS MemoryGB,
       max_workers_count,
       scheduler_count,
	   SERVERPROPERTY('Edition') as Edition,
       Server_type = CASE
                         WHEN virtual_machine_type = 1 THEN
                             'Virtual'
                         ELSE
                             'Physical'
                     END
FROM sys.dm_os_sys_info;


