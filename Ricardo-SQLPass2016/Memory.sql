-- exec sp_help
-- GO
-- DBCC MemoryStatus
-- GO
SELECT * FROM sys.dm_os_performance_counters
WHERE counter_name IN ('Target Server Memory (KB)','Total Server Memory (KB)')
GO

