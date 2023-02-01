-- Check Memory Pressure

SELECT physical_memory_in_use_kb / 1024 AS 'SQL Physical MEM in use (MB)'
	, locked_page_allocations_kb / 1024 AS 'AWE Memory (MB)'
	, total_virtual_address_space_kb / 1024 AS 'Max VAS (MB)'
	, virtual_address_space_committed_kb / 1024 AS 'SQL Committed (MB)'
	, memory_utilization_percentage AS 'Working Set %'
	, virtual_address_space_available_kb / 1024 AS 'VAS Available (MB)'
	, process_physical_memory_low AS 'External Pressure'
	, process_virtual_memory_low AS 'VAS Pressure'
FROM sys.dm_os_process_memory
