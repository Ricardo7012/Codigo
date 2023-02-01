
SELECT @@servername as SERVERNAME, cpu_count, scheduler_count, max_workers_count, physical_memory_kb, virtual_machine_type_desc FROM sys.dm_os_sys_info
go

/**************************************************/
/* WORKERS PER CPU */
SELECT s.cpu_id,
       w.scheduler_address,
       COUNT(*) AS workers
FROM sys.dm_os_workers w
    INNER JOIN sys.dm_os_schedulers s
        ON w.scheduler_address = s.scheduler_address
--WHERE s.status = 'VISIBLE ONLINE'
--      AND w.state = 'RUNNING'
GROUP BY s.cpu_id,
         w.scheduler_address
ORDER BY s.cpu_id,
         w.scheduler_address;

SELECT * FROM sys.dm_os_schedulers
SELECT * FROM sys.dm_os_workers

