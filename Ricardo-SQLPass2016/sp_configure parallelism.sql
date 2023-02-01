/*
The max degree of parallelism option is an advanced option. If you are using the sp_configure system stored procedure to change the setting, you can change max degree of parallelism only when show advanced options is set to 1. The setting takes effect immediately (without restarting the MSSQLSERVER service).
The following example sets the max degree of parallelism option to 8. 
http://msdn.microsoft.com/en-us/library/ms181007.aspx
http://blogs.msdn.com/b/jimmymay/archive/2008/12/02/case-study-part-2-cxpacket-wait-stats-max-degree-of-parallelism-option-suppressing-query-parallelism-eliminated-cxpacket-waits-liberated-30-of-cpu.aspx
*/
USE 

GO

sp_configure 'show advanced options', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
sp_configure 'max degree of parallelism', 8;
GO
RECONFIGURE WITH OVERRIDE;
GO

/*REVERT IT BACK*/
sp_configure 'show advanced options', 0;
GO
RECONFIGURE WITH OVERRIDE;
GO
sp_configure 'max degree of parallelism', 0;
GO
RECONFIGURE WITH OVERRIDE;
GO

