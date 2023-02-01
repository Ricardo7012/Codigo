-- Check Ring Buffer Memory Alerts

SELECT Record AS 'Record'
	, dateadd(ms, x.TIMESTAMP - dosi.ms_ticks, getdate()) AS 'Event Time'
FROM (
	SELECT max(TIMESTAMP) AS 'TimeStamp'
		, convert(XML, record) AS 'Record'
	FROM sys.dm_os_ring_buffers dorb
	WHERE dorb.ring_buffer_type = N'Ring_Buffer_Resource_Monitor'
	GROUP BY dorb.record
	) AS X
CROSS APPLY sys.dm_os_sys_info dosi
ORDER BY 'Event Time'
