USE master
GO
EXECUTE sp_help_log_shipping_primary_database @database = 'HSP'
GO
EXECUTE sp_help_log_shipping_secondary_database @secondary_database = 'HSP'
GO
EXECUTE sp_refresh_log_shipping_monitor 
	@agent_id = '4C409DD8-B81F-4D2A-861E-2E5E97628D81', -- PRIMARY_ID
    @agent_type = 0,
    @database = 'HSP',
    @mode = 1
SELECT * FROM msdb.dbo.log_shipping_monitor_secondary 
GO
SELECT net_transport, auth_scheme FROM sys.dm_exec_connections WHERE session_id = @@spid ;  
GO
SELECT @@servername
GO

select * from sys.servers

SELECT 
    s.database_name,s.backup_finish_date,y.physical_device_name
FROM 
    msdb..backupset AS s INNER JOIN
    msdb..backupfile AS f ON f.backup_set_id = s.backup_set_id INNER JOIN
    msdb..backupmediaset AS m ON s.media_set_id = m.media_set_id INNER JOIN
    msdb..backupmediafamily AS y ON m.media_set_id = y.media_set_id
WHERE 
    (s.database_name = 'HSP')
ORDER BY 
    s.backup_finish_date DESC;

--EXEC sp_help_log_shipping_monitor
--GO
