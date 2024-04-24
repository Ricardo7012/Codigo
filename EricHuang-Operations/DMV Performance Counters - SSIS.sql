SELECT counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name like 'SQLServer:SSIS Pipeline 12.0'
ORDER BY cntr_value DESC


SELECT counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name like 'SQLServer:SSIS Pipeline 13.0'
	AND counter_name IN ('Buffer Memory', 
						'Buffers in use')
ORDER BY cntr_value DESC
