DBCC SQLPERF(LOGSPACE);
GO
BACKUP DATABASE HSP_MO TO  DISK = 'NUL:';
GO
BACKUP LOG HSP_MO TO  DISK = 'NUL:';
GO
DBCC SQLPERF(LOGSPACE);
GO