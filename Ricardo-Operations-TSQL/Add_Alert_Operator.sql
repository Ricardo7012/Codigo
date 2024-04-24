/******************************************************************
sp_add_operator
*******************************************************************/
--USE [msdb]
--GO
--/****** Object:  Operator [DatabaseDeveloper]    Script Date: 4/20/2018 9:55:09 PM ******/
--EXEC msdb.dbo.sp_add_operator @name=N'DatabaseDeveloper', 
--		@enabled=1, 
--		@weekday_pager_start_time=70000, 
--		@weekday_pager_end_time=180000, 
--		@saturday_pager_start_time=70000, 
--		@saturday_pager_end_time=180000, 
--		@sunday_pager_start_time=70000, 
--		@sunday_pager_end_time=180000, 
--		@pager_days=127, 
--		@email_address=N'fernandez-r@iehp.org;nakhoul-s@iehp.org;dgdatamanagement@iehp.opsgenie.net', 
--		@category_name=N'[Uncategorized]'
--GO
/******************************************************************
sp_add_operator
*******************************************************************/
USE [msdb]
GO

/****** Object:  Operator [DBA Notification]    Script Date: 4/20/2018 10:05:52 PM ******/
EXEC msdb.dbo.sp_add_operator @name=N'DBA Notification', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'DbaNotification@iehp.org;fernandez-r@iehp.org;nakhoul-s@iehp.org;dgdatamanagement@iehp.opsgenie.net', 
		@category_name=N'[Uncategorized]'
GO

/******************************************************************
sp_add_alert
*******************************************************************/
USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'ShutDownAlert_QVSQLHSP01', 
		@message_id=6005, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'SHUTDOWN IN PROGRESS QVSQLHSP01', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'ShutDownAlert_QVSQLHSP01', @operator_name=N'DBA Notification', @notification_method = 1
GO

--YOU CAN ADD MORE ALERTS BY CHOSING THE APPROPRIATE @MESSAGE_ID FROM THE BELOW QUERY.
SELECT * FROM sys.messages WHERE text like '%shutdown%' and language_id=1033 AND message_id = 6005


SELECT @@SERVERNAME
