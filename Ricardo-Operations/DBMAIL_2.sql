-- https://technet.microsoft.com/en-us/library/ms190630(v=sql.105).aspx
-- CONFIRM .NET 3.0 AND 2.0 ARE INSTALLED 

USE msdb;
GO
SELECT profile_id,
       [name],
       [description],
       last_mod_datetime,
       last_mod_user
FROM msdb.dbo.sysmail_profile;
GO
EXECUTE msdb.dbo.sysmail_help_status_sp
GO
EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'Mail';
GO
EXEC msdb.dbo.sysmail_help_account_sp; 
GO
SELECT * FROM msdb.dbo.sysmail_allitems ORDER BY mailitem_id DESC
GO
SELECT * FROM msdb.dbo.sysmail_sentitems;
GO
SELECT * FROM msdb.dbo.sysmail_unsentitems
GO
SELECT * FROM msdb.dbo.sysmail_event_log ORDER BY log_id DESC
GO
SELECT * FROM msdb.dbo.sysmail_faileditems ORDER BY mailitem_id DESC
GO


--exec msdb.dbo.sp_send_dbmail
--	@profile_name = 'HSP_DBMAIL'
--	,@recipients = 'FERNANDEZ-R@IEHP.ORG'
--	,@subject='test 6'
--,@body='test 6'
--GO

