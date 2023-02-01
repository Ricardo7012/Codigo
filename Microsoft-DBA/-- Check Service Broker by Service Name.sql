-- Check Service Broker by Service Name

SELECT t1.NAME AS 'Service Name'
	, t3.NAME AS 'Schema Name'
	, t2.NAME AS 'Queue Name'
	, CASE 
		WHEN t4.STATE IS NULL
			THEN 'Not available'
		ELSE t4.STATE
		END AS 'Queue State'
	, CASE 
		WHEN t4.tasks_waiting IS NULL
			THEN '--'
		ELSE CONVERT(VARCHAR, t4.tasks_waiting)
		END AS 'Tasks Waiting'
	, CASE 
		WHEN t4.last_activated_time IS NULL
			THEN '--'
		ELSE CONVERT(VARCHAR, t4.last_activated_time)
		END AS 'Last Activated Time'
	, CASE 
		WHEN t4.last_empty_rowset_time IS NULL
			THEN '--'
		ELSE CONVERT(VARCHAR, t4.last_empty_rowset_time)
		END AS 'Last Empty Rowset Time'
	, (
		SELECT COUNT(*)
		FROM sys.transmission_queue t6
		WHERE (t6.from_service_name = t1.NAME)
		) AS 'Tran Message Count'
FROM sys.services t1
INNER JOIN sys.service_queues t2
	ON (t1.service_queue_id = t2.object_id)
INNER JOIN sys.schemas t3
	ON (t2.schema_id = t3.schema_id)
LEFT JOIN sys.dm_broker_queue_monitors t4
	ON (
			t2.object_id = t4.queue_id
			AND t4.database_id = DB_ID()
			)
INNER JOIN sys.databases t5
	ON (t5.database_id = DB_ID())
