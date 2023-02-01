-- Check Ring Buffer for Errors

USE master
GO

SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
GO

PRINT 'Start Time: ' + CONVERT(VARCHAR(30), GETDATE(), 121)
GO

PRINT ''
PRINT '==== SELECT GETDATE()'

SELECT GETDATE() AS 'Start Time'

PRINT ''
PRINT ''
PRINT '==== SELECT @@version'

SELECT @@VERSION AS 'SQL Version'
GO

PRINT ''
PRINT '==== SQL Server name'

SELECT @@SERVERNAME AS 'Server Name'
GO

PRINT ''
PRINT ''
PRINT '==== RING_BUFFER_CONNECTIVITY - LOGIN TIMERS'

SELECT a.*
FROM (
	SELECT x.value('(//Record/ConnectivityTraceRecord/RecordType)[1]', 'varchar(30)') AS 'Record Type'
		, x.value('(//Record/ConnectivityTraceRecord/RecordSource)[1]', 'varchar(30)') AS 'Record Source'
		, x.value('(//Record/ConnectivityTraceRecord/Spid)[1]', 'int') AS 'Spid'
		, x.value('(//Record/ConnectivityTraceRecord/OSError)[1]', 'int') AS 'OS Error'
		, x.value('(//Record/ConnectivityTraceRecord/SniConsumerError)[1]', 'int') AS 'Sni Consumer Error'
		, x.value('(//Record/ConnectivityTraceRecord/State)[1]', 'int') AS 'State'
		, x.value('(//Record/ConnectivityTraceRecord/RecordTime)[1]', 'nvarchar(30)') AS 'Record Time'
		, x.value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsInputBufferError)[1]', 'int') AS 'Tds Input Buffer Error'
		, x.value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsOutputBufferError)[1]', 'int') AS 'Tds Output Buffer Error'
		, x.value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsInputBufferBytes)[1]', 'int') AS 'Tds Input Buffer Bytes'
		, x.value('(//Record/ConnectivityTraceRecord/LoginTimers/TotalLoginTimeInMilliseconds)[1]', 'int') AS 'Total Login Time In (ms)'
		, x.value('(//Record/ConnectivityTraceRecord/LoginTimers/LoginTaskEnqueuedInMilliseconds)[1]', 'int') AS 'Login Task Enqueued In (ms)'
		, x.value('(//Record/ConnectivityTraceRecord/LoginTimers/NetworkWritesInMilliseconds)[1]', 'int') AS 'Network Writes In (ms)'
		, x.value('(//Record/ConnectivityTraceRecord/LoginTimers/NetworkReadsInMilliseconds)[1]', 'int') AS [NetworkReadsInMilliseconds]
		, x.value('(//Record/ConnectivityTraceRecord/LoginTimers/SslProcessingInMilliseconds)[1]', 'int') AS [SslProcessingInMilliseconds]
		, x.value('(//Record/ConnectivityTraceRecord/LoginTimers/SspiProcessingInMilliseconds)[1]', 'int') AS [SspiProcessingInMilliseconds]
		, x.value('(//Record/ConnectivityTraceRecord/LoginTimers/LoginTriggerAndResourceGovernorProcessingInMilliseconds)[1]', 'int') AS [LoginTriggerAndResourceGovernorProcessingInMilliseconds]
	FROM (
		SELECT CAST(record AS XML)
		FROM sys.dm_os_ring_buffers
		WHERE ring_buffer_type = 'RING_BUFFER_CONNECTIVITY'
		) AS R(x)
	) a
WHERE a.RecordType = 'LoginTimers'
ORDER BY a.recordtime

PRINT ''
PRINT ''
PRINT '==== RING_BUFFER_CONNECTIVITY - TDS Data'

SELECT a.*
FROM (
	SELECT x.value('(//Record/ConnectivityTraceRecord/RecordType)[1]', 'varchar(30)') AS [RecordType]
		, x.value('(//Record/ConnectivityTraceRecord/RecordSource)[1]', 'varchar(30)') AS [RecordSource]
		, x.value('(//Record/ConnectivityTraceRecord/Spid)[1]', 'int') AS [Spid]
		, x.value('(//Record/ConnectivityTraceRecord/OSError)[1]', 'int') AS [OSError]
		, x.value('(//Record/ConnectivityTraceRecord/SniConsumerError)[1]', 'int') AS [SniConsumerError]
		, x.value('(//Record/ConnectivityTraceRecord/State)[1]', 'int') AS [State]
		, x.value('(//Record/ConnectivityTraceRecord/RecordTime)[1]', 'nvarchar(30)') AS [RecordTime]
		, x.value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsInputBufferError)[1]', 'int') AS [TdsInputBufferError]
		, x.value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsOutputBufferError)[1]', 'int') AS [TdsOutputBufferError]
		, x.value('(//Record/ConnectivityTraceRecord/TdsBuffersInformation/TdsInputBufferBytes)[1]', 'int') AS [TdsInputBufferBytes]
		, x.value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/PhysicalConnectionIsKilled)[1]', 'int') AS [PhysicalConnectionIsKilled]
		, x.value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/DisconnectDueToReadError)[1]', 'int') AS [DisconnectDueToReadError]
		, x.value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/NetworkErrorFoundInInputStream)[1]', 'int') AS [NetworkErrorFoundInInputStream]
		, x.value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/ErrorFoundBeforeLogin)[1]', 'int') AS [ErrorFoundBeforeLogin]
		, x.value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/SessionIsKilled)[1]', 'int') AS [SessionIsKilled]
		, x.value('(//Record/ConnectivityTraceRecord/TdsDisconnectFlags/NormalDisconnect)[1]', 'int') AS [NormalDisconnect]
	FROM (
		SELECT CAST(record AS XML)
		FROM sys.dm_os_ring_buffers
		WHERE ring_buffer_type = 'RING_BUFFER_CONNECTIVITY'
		) AS R(x)
	) a
WHERE a.RecordType = 'Error'
ORDER BY a.recordtime

PRINT ''
PRINT ''
PRINT '==== RING_BUFFER_SECURITY_EORROR'

SELECT CONVERT(VARCHAR(30), GETDATE(), 121) AS [RunTime]
	, dateadd(ms, rbf.[timestamp] - tme.ms_ticks, GETDATE()) AS [Notification_Time]
	, cast(record AS XML).value('(//SPID)[1]', 'bigint') AS SPID
	, cast(record AS XML).value('(//ErrorCode)[1]', 'varchar(255)') AS Error_Code
	, cast(record AS XML).value('(//CallingAPIName)[1]', 'varchar(255)') AS [CallingAPIName]
	, cast(record AS XML).value('(//APIName)[1]', 'varchar(255)') AS [APIName]
	, cast(record AS XML).value('(//Record/@id)[1]', 'bigint') AS [Record Id]
	, cast(record AS XML).value('(//Record/@type)[1]', 'varchar(30)') AS [Type]
	, cast(record AS XML).value('(//Record/@time)[1]', 'bigint') AS [Record Time]
	, tme.ms_ticks AS [Current Time]
FROM sys.dm_os_ring_buffers rbf
CROSS JOIN sys.dm_os_sys_info tme
WHERE rbf.ring_buffer_type = 'RING_BUFFER_SECURITY_ERROR'
ORDER BY rbf.TIMESTAMP ASC

PRINT ''
PRINT ''
PRINT '==== RING_BUFFER_EXCEPTION'

SELECT CONVERT(VARCHAR(30), GETDATE(), 121) AS [RunTime]
	, dateadd(ms, (rbf.[timestamp] - tme.ms_ticks), GETDATE()) AS Time_Stamp
	, cast(record AS XML).value('(//Exception//Error)[1]', 'varchar(255)') AS [Error]
	, cast(record AS XML).value('(//Exception/Severity)[1]', 'varchar(255)') AS [Severity]
	, cast(record AS XML).value('(//Exception/State)[1]', 'varchar(255)') AS [State]
	, msg.description
	, cast(record AS XML).value('(//Exception/UserDefined)[1]', 'int') AS [isUserDefinedError]
	, cast(record AS XML).value('(//Record/@id)[1]', 'bigint') AS [Record Id]
	, cast(record AS XML).value('(//Record/@type)[1]', 'varchar(30)') AS [Type]
	, cast(record AS XML).value('(//Record/@time)[1]', 'int') AS [Record Time]
	, tme.ms_ticks AS [Current Time]
FROM sys.dm_os_ring_buffers rbf
CROSS JOIN sys.dm_os_sys_info tme
CROSS JOIN sys.sysmessages msg
WHERE rbf.ring_buffer_type = 'RING_BUFFER_EXCEPTION'
	AND msg.error = cast(record AS XML).value('(//Exception//Error)[1]', 'varchar(500)')
	AND msg.msglangid = 1033
ORDER BY rbf.TIMESTAMP ASC

PRINT ''
PRINT ''
PRINT '==== RING_BUFFER_RESOURCE_MONITOR to capture external and internal memory pressure'

SELECT CONVERT(VARCHAR(30), GETDATE(), 121) AS [RunTime]
	, dateadd(ms, (rbf.[timestamp] - tme.ms_ticks), GETDATE()) AS [Notification_Time]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Notification)[1]', 'varchar(30)') AS [Notification_type]
	, cast(record AS XML).value('(//Record/MemoryRecord/MemoryUtilization)[1]', 'bigint') AS [MemoryUtilization %]
	, cast(record AS XML).value('(//Record/MemoryNode/@id)[1]', 'bigint') AS [Node Id]
	, cast(record AS XML).value('(//Record/ResourceMonitor/IndicatorsProcess)[1]', 'int') AS [Process_Indicator]
	, cast(record AS XML).value('(//Record/ResourceMonitor/IndicatorsSystem)[1]', 'int') AS [System_Indicator]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect/@type)[1]', 'varchar(30)') AS [type]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect/@state)[1]', 'varchar(30)') AS [state]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect/@reversed)[1]', 'int') AS [reserved]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect)[1]', 'bigint') AS [Effect]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect[2]/@type)[1]', 'varchar(30)') AS [type]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect[2]/@state)[1]', 'varchar(30)') AS [state]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect[2]/@reversed)[1]', 'int') AS [reserved]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect)[2]', 'bigint') AS [Effect]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect[3]/@type)[1]', 'varchar(30)') AS [type]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect[3]/@state)[1]', 'varchar(30)') AS [state]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect[3]/@reversed)[1]', 'int') AS [reserved]
	, cast(record AS XML).value('(//Record/ResourceMonitor/Effect)[3]', 'bigint') AS [Effect]
	, cast(record AS XML).value('(//Record/MemoryNode/ReservedMemory)[1]', 'bigint') AS [SQL_ReservedMemory_KB]
	, cast(record AS XML).value('(//Record/MemoryNode/CommittedMemory)[1]', 'bigint') AS [SQL_CommittedMemory_KB]
	, cast(record AS XML).value('(//Record/MemoryNode/AWEMemory)[1]', 'bigint') AS [SQL_AWEMemory]
	, cast(record AS XML).value('(//Record/MemoryNode/SinglePagesMemory)[1]', 'bigint') AS [SinglePagesMemory]
	, cast(record AS XML).value('(//Record/MemoryNode/MultiplePagesMemory)[1]', 'bigint') AS [MultiplePagesMemory]
	, cast(record AS XML).value('(//Record/MemoryRecord/TotalPhysicalMemory)[1]', 'bigint') AS [TotalPhysicalMemory_KB]
	, cast(record AS XML).value('(//Record/MemoryRecord/AvailablePhysicalMemory)[1]', 'bigint') AS [AvailablePhysicalMemory_KB]
	, cast(record AS XML).value('(//Record/MemoryRecord/TotalPageFile)[1]', 'bigint') AS [TotalPageFile_KB]
	, cast(record AS XML).value('(//Record/MemoryRecord/AvailablePageFile)[1]', 'bigint') AS [AvailablePageFile_KB]
	, cast(record AS XML).value('(//Record/MemoryRecord/TotalVirtualAddressSpace)[1]', 'bigint') AS [TotalVirtualAddressSpace_KB]
	, cast(record AS XML).value('(//Record/MemoryRecord/AvailableVirtualAddressSpace)[1]', 'bigint') AS [AvailableVirtualAddressSpace_KB]
	, cast(record AS XML).value('(//Record/@id)[1]', 'bigint') AS [Record Id]
	, cast(record AS XML).value('(//Record/@type)[1]', 'varchar(30)') AS [Type]
	, cast(record AS XML).value('(//Record/@time)[1]', 'bigint') AS [Record Time]
	, tme.ms_ticks AS [Current Time]
FROM sys.dm_os_ring_buffers rbf
CROSS JOIN sys.dm_os_sys_info tme
WHERE rbf.ring_buffer_type = 'RING_BUFFER_RESOURCE_MONITOR' --and cast(record as xml).value('(//Record/ResourceMonitor/Notification)[1]', 'varchar(30)') = 'RESOURCE_MEMPHYSICAL_LOW' 
ORDER BY rbf.TIMESTAMP ASC

PRINT ''
PRINT ''
PRINT '==== RING_BUFFER_SCHEDULER_MONITOR to Monitor system health'

SELECT CONVERT(VARCHAR(30), GETDATE(), 121) AS runtime
	, DATEADD(ms, a.[Record Time] - sys.ms_ticks, GETDATE()) AS Notification_time
	, a.*
	, sys.ms_ticks AS [Current Time]
FROM (
	SELECT x.value('(//Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS [ProcessUtilization]
		, x.value('(//Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS [SystemIdle %]
		, x.value('(//Record/SchedulerMonitorEvent/SystemHealth/UserModeTime) [1]', 'bigint') AS [UserModeTime]
		, x.value('(//Record/SchedulerMonitorEvent/SystemHealth/KernelModeTime) [1]', 'bigint') AS [KernelModeTime]
		, x.value('(//Record/SchedulerMonitorEvent/SystemHealth/PageFaults) [1]', 'bigint') AS [PageFaults]
		, x.value('(//Record/SchedulerMonitorEvent/SystemHealth/WorkingSetDelta) [1]', 'bigint') / 1024 AS [WorkingSetDelta]
		, x.value('(//Record/SchedulerMonitorEvent/SystemHealth/MemoryUtilization) [1]', 'bigint') AS [MemoryUtilization (%workingset)]
		, x.value('(//Record/@time)[1]', 'bigint') AS [Record Time]
	FROM (
		SELECT CAST(record AS XML)
		FROM sys.dm_os_ring_buffers
		WHERE ring_buffer_type = 'RING_BUFFER_SCHEDULER_MONITOR'
		) AS R(x)
	) a
CROSS JOIN sys.dm_os_sys_info sys
ORDER BY DATEADD(ms, a.[Record Time] - sys.ms_ticks, GETDATE())
