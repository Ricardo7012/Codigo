-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sysmail-help-status-sp-transact-sql
--DISPLAYS THE STATUS OF DATABASE MAIL QUEUES. USE SYSMAIL_START_SP TO START THE DATABASE MAIL QUEUES AND SYSMAIL_STOP_SP TO STOP THE DATABASE MAIL QUEUES.
EXECUTE msdb.dbo.sysmail_help_status_sp ;
--EXECUTE msdb.dbo.sysmail_start_sp ;
--EXECUTE msdb.dbo.sysmail_stop_sp ;

USE msdb ;  
GO  
SELECT sent_date, * FROM sysmail_allitems ORDER BY mailitem_id DESC

-- Show the subject, the time that the mail item row was last  
-- modified, and the log information.  
-- Join sysmail_faileditems to sysmail_event_log   
-- on the mailitem_id column.  
-- In the WHERE clause list items where danw was in the recipients,  
-- copy_recipients, or blind_copy_recipients.  
-- These are the items that would have been sent  
-- to danw.  

SELECT items.subject,  
    items.last_mod_date  
    ,l.description FROM dbo.sysmail_faileditems as items  
INNER JOIN dbo.sysmail_event_log AS l  
    ON items.mailitem_id = l.mailitem_id  
WHERE items.recipients LIKE '%danw%'    
    OR items.copy_recipients LIKE '%danw%'   
    OR items.blind_copy_recipients LIKE '%danw%'  
GO  
