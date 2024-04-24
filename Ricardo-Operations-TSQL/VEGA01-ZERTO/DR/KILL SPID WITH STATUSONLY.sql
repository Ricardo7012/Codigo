--sys.sp_who2 @loginame = NULL -- sysname
sys.sp_who2 115
GO
WAITFOR DELAY '00:00:10'
GO
sys.sp_who2 115
GO


DECLARE @schema VARCHAR(MAX);
EXEC dbo.sp_IEHP_WhoIsActive

SELECT *
FROM sys.sysprocesses
WHERE cmd = 'KILLED/ROLLBACK';
--WHERE status = 'ROLLBACK'

DBCC INPUTBUFFER (115)
DBCC OPENTRAN(12)
--KILL <>
GO 
KILL 115 WITH STATUSONLY
--GO

-- Locking Information
SELECT * FROM sys.dm_tran_locks
GO
-- Cache Status
SELECT * FROM sys.dm_os_memory_cache_counters 
GO
-- Active Sessions
SELECT * FROM sys.dm_exec_sessions 
GO
-- Requests Status
SELECT * FROM sys.dm_exec_requests
GO

