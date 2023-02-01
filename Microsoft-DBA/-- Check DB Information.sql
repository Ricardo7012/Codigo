-- Check DB Information

SELECT CONVERT(VARCHAR(25), DB.NAME) AS 'DB Name'
	, CONVERT(VARCHAR(10), DATABASEPROPERTYEX(NAME, 'status')) AS 'Status'
	, state_desc AS 'DB State'
	, (
		SELECT COUNT(1)
		FROM sys.master_files
		WHERE DB_NAME(database_id) = DB.NAME
			AND type_desc = 'rows'
		) AS 'Data Files'
	, (
		SELECT SUM((size * 8) / 1024)
		FROM sys.master_files
		WHERE DB_NAME(database_id) = DB.NAME
			AND type_desc = 'rows'
		) AS 'Data (mb)'
	, (
		SELECT COUNT(1)
		FROM sys.master_files
		WHERE DB_NAME(database_id) = DB.NAME
			AND type_desc = 'log'
		) AS 'Log Files'
	, (
		SELECT SUM((size * 8) / 1024)
		FROM sys.master_files
		WHERE DB_NAME(database_id) = DB.NAME
			AND type_desc = 'log'
		) AS 'Log (mb)'
	, user_access_desc AS 'User Access'
	, recovery_model_desc AS 'Recovery model'
	, CASE compatibility_level
		WHEN 60
			THEN '60 (SQL Server 6.0)'
		WHEN 65
			THEN '65 (SQL Server 6.5)'
		WHEN 70
			THEN '70 (SQL Server 7.0)'
		WHEN 80
			THEN '80 (SQL Server 2000)'
		WHEN 90
			THEN '90 (SQL Server 2005)'
		WHEN 100
			THEN '100 (SQL Server 2008)'
		WHEN 110
			THEN '110 (SQL Server 2012)'
		WHEN 120
			THEN '120 (SQL Server 2014)'
		WHEN 130
			THEN '130 (SQL Server 2016)'
		END AS 'Compatibility Level'
	, CONVERT(VARCHAR(20), create_date, 103) + ' ' + CONVERT(VARCHAR(20), create_date, 108) AS 'Creation Date'
	-- last backup
	, ISNULL((
			SELECT TOP 1 CASE TYPE
					WHEN 'D'
						THEN 'Full'
					WHEN 'I'
						THEN 'Differential'
					WHEN 'L'
						THEN 'Transaction log'
					END + ' – ' + LTRIM(ISNULL(STR(ABS(DATEDIFF(DAY, GETDATE(), Backup_finish_date))) + ' days ago', 'NEVER')) + ' – ' + CONVERT(VARCHAR(20), backup_start_date, 103) + ' ' + CONVERT(VARCHAR(20), backup_start_date, 108) + ' – ' + CONVERT(VARCHAR(20), backup_finish_date, 103) + ' ' + CONVERT(VARCHAR(20), backup_finish_date, 108) + ' (' + CAST(DATEDIFF(second, BK.backup_start_date, BK.backup_finish_date) AS VARCHAR(4)) + ' ' + 'seconds)'
			FROM msdb..backupset BK
			WHERE BK.database_name = DB.NAME
			ORDER BY backup_set_id DESC
			), '-') AS 'Last Backup'
	, CASE 
		WHEN is_fulltext_enabled = 1
			THEN 'Fulltext Enabled'
		ELSE ''
		END AS 'Full Text'
	, CASE 
		WHEN is_auto_close_on = 1
			THEN 'Auto Close'
		ELSE ''
		END AS [autoclose]
	, page_verify_option_desc AS 'Page Verify Option'
	, CASE
		WHEN DB.page_verify_option = 1
			THEN 'Old SQL 2000 Setting, SQL 2005 On set to ''< CHECKSUM >'''
		ELSE 'Microsoft Best Pratice'
		END AS 'Microsoft Setting'
	, CASE 
		WHEN is_read_only = 1
			THEN 'Read Only'
		ELSE ''
		END AS 'Read Only'
	, CASE 
		WHEN is_auto_shrink_on = 1
			THEN 'Auto Shrink'
		ELSE ''
		END AS 'Auto Shrink'
	, CASE 
		WHEN is_auto_create_stats_on = 1
			THEN 'Auto Create Statistics'
		ELSE ''
		END AS 'Auto Create Statistics'
	, CASE 
		WHEN is_auto_update_stats_on = 1
			THEN 'Auto Update Statistics'
		ELSE ''
		END AS 'Auto Update Statistics'
	, CASE 
		WHEN is_in_standby = 1
			THEN 'Standby'
		ELSE ''
		END AS 'Standby'
	, CASE 
		WHEN is_cleanly_shutdown = 1
			THEN 'Cleanly Shutdown'
		ELSE ''
		END AS 'Cleanly Shutdown'
FROM sys.databases DB
ORDER BY 'DB Name'
	, [Last backup] DESC
	, NAME
