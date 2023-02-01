-- DMV - Identify Virtual Processors in for SQL Server 2005, 2008, 2008R2, 2012

SELECT cpu_count AS 'CPU Count'
FROM sys.dm_os_sys_info