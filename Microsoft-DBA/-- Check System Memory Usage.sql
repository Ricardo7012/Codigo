-- Check System Memory Usage

SELECT EventTime
	, record.value('(/Record/ResourceMonitor/Notification)[1]', 'varchar(max)') AS [Type]
	, record.value('(/Record/MemoryRecord/AvailablePhysicalMemory)[1]', 'bigint') AS [Avail Phys Mem, Kb]
	, record.value('(/Record/MemoryRecord/AvailableVirtualAddressSpace)[1]', 'bigint') AS [Avail VAS, Kb]
FROM (
	SELECT DATEADD(ss, (- 1 * ((cpu_ticks / CONVERT(FLOAT, (cpu_ticks / ms_ticks))) - [timestamp]) / 1000), GETDATE()) AS EventTime
		, CONVERT(XML, record) AS record
	FROM sys.dm_os_ring_buffers
	CROSS JOIN sys.dm_os_sys_info
	WHERE ring_buffer_type = 'RING_BUFFER_RESOURCE_MONITOR'
	) AS tab
ORDER BY EventTime DESC
