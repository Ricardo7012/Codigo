--https://technet.microsoft.com/en-us/library/ms187540(v=sql.105).aspx

EXEC msdb.dbo.sysmail_help_status_sp;

SELECT is_broker_enabled FROM sys.databases WHERE name = 'msdb';

USE msdb;
GO
EXEC sysmail_help_queue_sp @queue_type = 'Mail';

SELECT profile_id,
       [name],
       [description],
       last_mod_datetime,
       last_mod_user
FROM msdb.dbo.sysmail_profile;

SELECT *
FROM msdb.dbo.sysmail_allitems
--WHERE mailitem_id = 116513
ORDER BY mailitem_id DESC

SELECT *
FROM msdb.dbo.sysmail_event_log
--WHERE mailitem_id = 8
WHERE event_type = 'error'
ORDER BY log_id DESC

SELECT *
FROM msdb.dbo.sysmail_faileditems
WHERE send_request_date > dateadd(day,-2, getdate())
ORDER BY mailitem_id DESC

SELECT *
FROM msdb.dbo.sysmail_sentitems
ORDER BY sent_date DESC

--EXEC msdb.dbo.sp_send_dbmail @profile_name = ''HSP_DBMAIL_MO'',
--                             @recipients = ''fernandez-r@iehp.org;Cosmos-J@iehp.org'',
--                             @subject = ''HSP_DBMAIL_MO TEST'',
--                             @body = ''***HSP_DBMAIL-MO TEST PLEASE REPLY***'';
 
--exec uu_SendEMailRequests @profile_name=''HSP_DBMAIL''
--exec uu_SendBillingWizardEmailRequests @Profile_Name=''HSP_DBMAIL''
--exec uu_SendMemberEmailRequests @profile_name = ''HSP_DBMAIL''
--exec uu_SendVendorEmailRequests @profile_name = ''HSP_DBMAIL''
--exec uu_SendCheckRunEmailRequests @profile_name = ''HSP_DBMAIL''