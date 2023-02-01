--List Basic Information about OS

SELECT total_physical_memory_kb AS 'Total Physical Memory KB'
	, total_page_file_kb AS 'Total Page File KB'
	, available_page_file_kb AS 'Available Page File KB'
	, '- - -' AS '- - -'
	, available_physical_memory_kb AS 'Available Physical Memory KB'
	, system_memory_state_desc AS 'SQL Memory State'
	
FROM sys.dm_os_sys_memory WITH (NOLOCK)
OPTION (RECOMPILE);
	-- You want to see "Available physical memory is high"
	-- This indicates that you are not under external memory pressure
