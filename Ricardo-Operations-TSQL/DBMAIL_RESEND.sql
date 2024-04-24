
--UPDATE msdb.dbo.sysmail_faileditems set sent_account_id =1 WHERE sent_account_id IS NULL

/*
    Author: Ludvig Derning 
    Description: Resend failed mail from the latest @Daysback unless it a mail to the same recipients with the same subject and body has already been sent successfully.
    
    Use as you like and at your own risk.
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE PROCEDURE dbo.ResendFailedMail (@DaysBack AS INT) AS
--BEGIN
DECLARE
@mailitem_id AS INT ,
@recipients AS varchar(MAX) ,
@subject AS nvarchar(255) ,
@body AS nvarchar(MAX) ,
@body_format AS varchar(20) ,
@query AS nvarchar(MAX) ,
@execute_query_database AS NVARCHAR(128),
@query_result_width AS int ,
@query_result_separator AS CHAR(1),
@send_request_date AS datetime 

IF OBJECT_ID('tempdb..#FailedMail') IS NOT NULL
BEGIN
	DROP TABLE #FailedMail
END

SELECT * INTO #FailedMail FROM  msdb.dbo.sysmail_mailitems WHERE sent_status = 2 --AND send_request_date > GETDATE() - @DaysBack  ORDER BY send_request_date DESC
SELECT * FROM #FailedMail
WHILE EXISTS(SELECT * FROM #FailedMail)
BEGIN
	SELECT @mailitem_id = mailitem_id, @recipients = recipients, @subject = subject, @body = body, @body_format = body_format, @query = query, @query_result_width = query_result_width, @send_request_date = send_request_date, @query_result_separator = query_result_separator, @execute_query_database = execute_query_database FROM #FailedMail
	
	PRINT CAST(@mailitem_id AS NVARCHAR(20))

	
	--CHECK IF MAIL HAS ALREADY BEEN SENT SUCCESSFULLY
	
	IF NOT EXISTS(SELECT * FROM  msdb.dbo.sysmail_mailitems WHERE sent_status = 1 AND send_request_date > GETDATE() - 3  AND @recipients = recipients AND @subject = subject AND @body = body)
	BEGIN
	   
		   EXEC msdb.dbo.sp_send_dbmail 
								@profile_name = 'HSP_DBMAIL',
								@recipients = @recipients,
                                @body = @body,
                                @subject = @subject,
								--@query = @query,
								@execute_query_database = @execute_query_database,
								@query_result_width = @query_result_width,
								@query_result_separator = @query_result_separator,
								@body_format = @body_format
	   
	END
	
	DELETE FROM #FailedMail WHERE mailitem_id = @mailitem_id
END
--END

SELECT *
FROM msdb.dbo.sysmail_faileditems
ORDER BY mailitem_id DESC;
