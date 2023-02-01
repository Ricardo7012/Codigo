--AlwaysON Extended Events
--CHECK FOR LAST FAILOVER
--TIMESTAMP IS SERVERTIME 
-- https://johnsterrett.com/2014/03/18/where-is-my-availability-group/

;WITH cte_HADR
AS (SELECT object_name,
           CONVERT(XML, event_data) AS data
    FROM sys.fn_xe_file_target_read_file('E:\system\MSSQL13.MSSQLSERVER\MSSQL\Log\AlwaysOn*.xel', NULL, NULL, NULL)
    WHERE object_name = 'error_reported')
SELECT data.value('(/event/@timestamp)[1]', 'datetime') AS [timestamp],
       data.value('(/event/data[@name=''error_number''])[1]', 'int') AS [error_number],
	   data.value('(/event/data[@name=''availability_replica_name''])[1]', 'varchar(max)') AS [availability_replica_name],
       data.value('(/event/data[@name=''message''])[1]', 'varchar(max)') AS [message]
FROM cte_HADR
WHERE data.value('(/event/data[@name=''error_number''])[1]', 'int') = 1480;

--SELECT * FROM sys.dm_xe_objects WHERE name LIKE '%hadr%'  

SELECT  *
FROM sys.fn_xe_file_target_read_file('E:\system\MSSQL13.MSSQLSERVER\MSSQL\Log\AlwaysOn*.xel', null, null, null) AS E;

--E:\System\MSSQL13.MSSQLSERVER\MSSQL\Log