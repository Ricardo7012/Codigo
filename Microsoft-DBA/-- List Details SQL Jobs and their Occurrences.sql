-- List Details SQL Jobs and their Occurrences

IF (
		left(cast(SERVERPROPERTY('ProductVersion') AS VARCHAR), 5) = '10.00'
		AND SERVERPROPERTY('EngineEdition') = 3
		)
	OR (
		left(cast(SERVERPROPERTY('ProductVersion') AS VARCHAR), 5) = '10.50'
		AND SERVERPROPERTY('EngineEdition') IN (
			2
			, 3
			)
		)
	OR (
		left(cast(SERVERPROPERTY('ProductVersion') AS VARCHAR), 5) = '9.00.'
		AND SERVERPROPERTY('EngineEdition') IN (
			2
			, 3
			)
		)
BEGIN
	DECLARE @DML11 VARCHAR(8000)
	DECLARE @DML12 VARCHAR(8000)
	DECLARE @DML13 VARCHAR(8000)

	SET @DML11 = 'SELECT ''' + @@Servername + 
		''' ''Server Name''
	, @@version AS ''Version''
	, [Schedule_UID] AS ''Schedule ID''
    , [name] AS ''Schedule Name''
    , CASE [enabled]
        WHEN 1 THEN ''Yes''
        WHEN 0 THEN ''No''
      END AS ''Is Enabled''
    , CASE 
        WHEN [freq_type] = 64 THEN ''Start automatically when SQL Server Agent starts''
        WHEN [freq_type] = 128 THEN ''Start whenever the CPUs become idle''
        WHEN [freq_type] IN (4,8,16,32) THEN ''Recurring''
        WHEN [freq_type] = 1 THEN ''One Time''
      END ''Schedule Type''
    , CASE [freq_type]
        WHEN 1 THEN ''One Time''
        WHEN 4 THEN ''Daily''
        WHEN 8 THEN ''Weekly''
        WHEN 16 THEN ''Monthly''
        WHEN 32 THEN ''Monthly - Relative to Frequency Interval''
        WHEN 64 THEN ''Start automatically when SQL Server Agent starts''
        WHEN 128 THEN ''Start whenever the CPUs become idle''
      END ''Occurrence''
    ,
     CASE [freq_type]
        WHEN 4 THEN ''Occurs every '' + CAST([freq_interval] AS VARCHAR(3)) + '' day(s)''
        WHEN 8 THEN ''Occurs every '' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                    + '' week(s) on ''
                    + CASE WHEN [freq_interval] & 1 = 1 THEN ''Sunday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 2 = 2 THEN '', Monday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 4 = 4 THEN '', Tuesday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 8 = 8 THEN '', Wednesday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 16 = 16 THEN '', Thursday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 32 = 32 THEN '', Friday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 64 = 64 THEN '', Saturday'' ELSE '''' END
        WHEN 16 THEN ''Occurs on Day '' + CAST([freq_interval] AS VARCHAR(3)) 
                     + '' of every ''
                     + CAST([freq_recurrence_factor] AS VARCHAR(3)) + '' month(s)''
        WHEN 32 THEN ''Occurs on ''
                     + CASE [freq_relative_interval]
                        WHEN 1 THEN ''First''
                        WHEN 2 THEN ''Second''
                        WHEN 4 THEN ''Third''
                        WHEN 8 THEN ''Fourth''
                        WHEN 16 THEN ''Last''
                       END
                     + '' '' 
                     + CASE [freq_interval]
                        WHEN 1 THEN ''Sunday''
                        WHEN 2 THEN ''Monday''
                        WHEN 3 THEN ''Tuesday''
                        WHEN 4 THEN ''Wednesday''
                        WHEN 5 THEN ''Thursday''
                        WHEN 6 THEN ''Friday''
                        WHEN 7 THEN ''Saturday''
                        WHEN 8 THEN ''Day''
                        WHEN 9 THEN ''Weekday''
                        WHEN 10 THEN ''Weekend day''
                       END
                     + '' of every '' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                     + '' month(s)''
      END AS ''Recurrence''
    ,
  
   CASE [freq_subday_type]
        WHEN 1 THEN ''Occurs once at '' 
                    + STUFF(
                 STUFF(RIGHT(''000000'' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
        WHEN 2 THEN ''Occurs every '' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + '' Second(s) between '' 
                    + STUFF(
                   STUFF(RIGHT(''000000'' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                           , 6, 0, '':'')
                    + '' & '' 
                    + STUFF(
                    STUFF(RIGHT(''000000'' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')'
	SET @DML12 = 
		'WHEN 4 THEN ''Occurs every '' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + '' Minute(s) between '' 
                    + STUFF(
                   STUFF(RIGHT(''000000'' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
                    + '' & '' 
                    + STUFF(
                    STUFF(RIGHT(''000000'' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
        WHEN 8 THEN ''Occurs every '' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + '' Hour(s) between '' 
                    + STUFF(
                    STUFF(RIGHT(''000000'' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
                    + '' & '' 
                    + STUFF(
                    STUFF(RIGHT(''000000'' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
      END AS ''Frequency''
    , STUFF(
            STUFF(CAST([active_start_date] AS VARCHAR(8)), 5, 0, ''-'')
                , 8, 0, ''-'') AS [ScheduleUsageStartDate]
    , STUFF(
            STUFF(CAST([active_end_date] AS VARCHAR(8)), 5, 0, ''-'')
                , 8, 0, ''-'') AS ''Schedule Usage End Date''
    , [date_created] AS ''Schedule Created On''
    , [date_modified] AS ''Schedule Last Modified On''
FROM [msdb].[dbo].[sysschedules]
ORDER BY ''Schedule Name''
'
	SET @DML13 = @DML11 + @DML12

	EXEC (@DML13)
END

IF (
		left(cast(SERVERPROPERTY('ProductVersion') AS VARCHAR), 5) = '8.00.'
		AND SERVERPROPERTY('EngineEdition') = 3
		)
BEGIN
	DECLARE @DML1 VARCHAR(8000)
	DECLARE @DML2 VARCHAR(8000)
	DECLARE @DML3 VARCHAR(8000)

	SET @DML1 = 'SELECT ''' + @@Servername + 
		''' ServerName,@@version Version,
    so.[job_id] AS [ScheduleID]
    , so.[name] AS [ScheduleName]
    , CASE so.[enabled]
        WHEN 1 THEN ''Yes''
        WHEN 0 THEN ''No''
      END AS [IsEnabled]
    , CASE 
        WHEN [freq_type] = 64 THEN ''Start automatically when SQL Server Agent starts''
        WHEN [freq_type] = 128 THEN ''Start whenever the CPUs become idle''
        WHEN [freq_type] IN (4,8,16,32) THEN ''Recurring''
        WHEN [freq_type] = 1 THEN ''One Time''
      END [ScheduleType]
    , CASE [freq_type]
        WHEN 1 THEN ''One Time''
        WHEN 4 THEN ''Daily''
        WHEN 8 THEN ''Weekly''
        WHEN 16 THEN ''Monthly''
        WHEN 32 THEN ''Monthly - Relative to Frequency Interval''
        WHEN 64 THEN ''Start automatically when SQL Server Agent starts''
        WHEN 128 THEN ''Start whenever the CPUs become idle''
      END [Occurrence]
    ,
     CASE [freq_type]
        WHEN 4 THEN ''Occurs every '' + CAST([freq_interval] AS VARCHAR(3)) + '' day(s)''
        WHEN 8 THEN ''Occurs every '' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                    + '' week(s) on ''
                    + CASE WHEN [freq_interval] & 1 = 1 THEN ''Sunday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 2 = 2 THEN '', Monday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 4 = 4 THEN '', Tuesday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 8 = 8 THEN '', Wednesday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 16 = 16 THEN '', Thursday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 32 = 32 THEN '', Friday'' ELSE '''' END
                    + CASE WHEN [freq_interval] & 64 = 64 THEN '', Saturday'' ELSE '''' END
        WHEN 16 THEN ''Occurs on Day '' + CAST([freq_interval] AS VARCHAR(3)) 
                     + '' of every ''
                     + CAST([freq_recurrence_factor] AS VARCHAR(3)) + '' month(s)''
        WHEN 32 THEN ''Occurs on ''
                     + CASE [freq_relative_interval]
                        WHEN 1 THEN ''First''
                        WHEN 2 THEN ''Second''
                        WHEN 4 THEN ''Third''
                        WHEN 8 THEN ''Fourth''
                        WHEN 16 THEN ''Last''
                       END
                     + '' '' 
                     + CASE [freq_interval]
                        WHEN 1 THEN ''Sunday''
                        WHEN 2 THEN ''Monday''
                        WHEN 3 THEN ''Tuesday''
                        WHEN 4 THEN ''Wednesday''
                        WHEN 5 THEN ''Thursday''
                        WHEN 6 THEN ''Friday''
                        WHEN 7 THEN ''Saturday''
                        WHEN 8 THEN ''Day''
                        WHEN 9 THEN ''Weekday''
                        WHEN 10 THEN ''Weekend day''
                       END
                     + '' of every '' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                     + '' month(s)''
      END AS [Recurrence]
    ,
  
   CASE [freq_subday_type]
        WHEN 1 THEN ''Occurs once at '' 
                    + STUFF(
                 STUFF(RIGHT(''000000'' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
        WHEN 2 THEN ''Occurs every '' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + '' Second(s) between '' 
                    + STUFF(
                   STUFF(RIGHT(''000000'' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                           , 6, 0, '':'')
                    + '' & '' 
                    + STUFF(
                    STUFF(RIGHT(''000000'' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')'
	SET @DML2 = 
		'WHEN 4 THEN ''Occurs every '' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + '' Minute(s) between '' 
                    + STUFF(
                   STUFF(RIGHT(''000000'' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
                    + '' & '' 
                    + STUFF(
                    STUFF(RIGHT(''000000'' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
        WHEN 8 THEN ''Occurs every '' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + '' Hour(s) between '' 
                    + STUFF(
                    STUFF(RIGHT(''000000'' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
                    + '' & '' 
                    + STUFF(
                    STUFF(RIGHT(''000000'' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, '':'')
                            , 6, 0, '':'')
      END [Frequency]
    , STUFF(
            STUFF(CAST([active_start_date] AS VARCHAR(8)), 5, 0, ''-'')
                , 8, 0, ''-'') AS [ScheduleUsageStartDate]
    , STUFF(
            STUFF(CAST([active_end_date] AS VARCHAR(8)), 5, 0, ''-'')
                , 8, 0, ''-'') AS [ScheduleUsageEndDate]
    , so.[date_created] AS [ScheduleCreatedOn]
    , [date_modified] AS [ScheduleLastModifiedOn]
FROM [msdb].[dbo].[sysjobschedules] sj
inner join msdb.dbo.sysjobs so on so.job_id=sj.job_id'
	SET @DML3 = @DML1 + @DML2

	EXEC (@DML3)
END
