--Target Server Memory (KB), Total Server Memory (KB)
--Assign Lock Pages in Memory privilege to the SQL Server Service account if the server is dedicated for SQL Server. And if SQL Server Enterprise Edition.


SELECT 
	 object_name
	,counter_name
	,instance_name
	,(cntr_value/1024) as Memory_in_MB
	,cntr_type 
FROM 
	sys.dm_os_performance_counters 
WHERE 
	counter_name IN ('Target Server Memory (KB)','Total Server Memory (KB)')
