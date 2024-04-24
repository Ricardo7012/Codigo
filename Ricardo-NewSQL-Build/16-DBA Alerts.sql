USE [msdb]
GO

/****** Object:  Operator [DBA Alerts]    Script Date: 4/29/2020 10:12:31 AM ******/
EXEC msdb.dbo.sp_add_operator @name=N'DBA Alerts', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'dgdatasystems@iehp.org', 
		@category_name=N'[Uncategorized]'
GO


