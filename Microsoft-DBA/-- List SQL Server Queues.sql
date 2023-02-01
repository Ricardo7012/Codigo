-- List SQL Server Queues

SELECT parent_node_id AS 'Node Id'
	, COUNT(*) AS '# of CPU In the NUMA'
	, SUM(COUNT(*)) OVER () AS '# of CPU'
	, SUM(runnable_tasks_count) AS 'Runnable Task Count'
	, SUM(pending_disk_io_count) AS 'Pending Disk I/O Count'
	, SUM(work_queue_count) AS 'Work queue count'
FROM sys.dm_os_schedulers
WHERE STATUS = 'VISIBLE ONLINE'
GROUP BY parent_node_id