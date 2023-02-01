-- Setup for EMails in SQL

DECLARE @p_body AS NVARCHAR(max)
DECLARE @p_subject AS NVARCHAR(max)
DECLARE @p_recipients AS NVARCHAR(max)
DECLARE @p_profile_name AS NVARCHAR(max)

SET @p_profile_name = N'IGT Alert Profile'
SET @p_recipients = N'test@test.com'
SET @p_subject = N'This is a test mail using sp_send_dbmail'
SET @p_body = 'This is an HTML test email send using <b>sp_send_dbmail</b>.'

EXEC msdb.dbo.sp_send_dbmail @profile_name = @p_profile_name
	, @recipients = @p_recipients
	, @body = @p_body
	, @body_format = 'HTML'
	, @subject = @p_subject
