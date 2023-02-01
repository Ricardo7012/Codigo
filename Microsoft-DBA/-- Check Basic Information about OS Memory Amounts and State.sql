-- Check Basic Information about OS Memory Amounts and State

-- You want to see "Available physical memory is high"
-- This indicates that you are not under external memory pressure 

SELECT total_physical_memory_kb AS 'Total Physical Memory (kb)'
	, available_physical_memory_kb AS 'Available Physical Memory (kb)'
	, total_page_file_kb AS 'Total Page File (kb)'
	, available_page_file_kb AS 'Available Page File (kb)'
	, system_memory_state_desc AS 'System Memory State Desc'
FROM sys.dm_os_sys_memory WITH (NOLOCK)
OPTION (RECOMPILE)
