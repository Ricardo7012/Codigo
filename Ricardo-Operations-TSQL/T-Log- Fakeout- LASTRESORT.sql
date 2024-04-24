DBCC SQLPERF(logspace)
GO
BACKUP DATABASE [CorepointQueuesAndLogs] TO DISK='NUL:'
GO
BACKUP LOG [CorepointQueuesAndLogs] TO DISK='NUL:'
GO
DBCC SQLPERF(logspace)
GO
