DBCC loginfo('HSP')
DBCC SQLPERF('LOGSPACE')
SELECT  name
       ,recovery_model_desc
       ,log_reuse_wait_desc
FROM    sys.databases;
--WHERE name = ''

DBCC OPENTRAN (HSP);

USE master;
GO
SELECT  spid
       ,status
       ,
-- hostname ,
-- program_name ,
-- loginame ,
        login_time
       ,last_batch
       ,( SELECT    text
          FROM      ::
                    fn_get_sql(sql_handle)
        ) AS [sql_text]
FROM    sysprocesses
WHERE   spid = 56;

--USE ;
GO
SELECT  s.session_id
       ,s.status
       ,
-- s.host_name ,
-- s.program_name ,
-- s.login_name ,
        s.login_time
       ,s.last_request_start_time
       ,s.last_request_end_time
       ,t.text
FROM    sys.dm_exec_sessions s
        JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
        CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) t
WHERE   s.session_id = 56;

SELECT  st.session_id
       ,st.is_user_transaction
       ,dt.database_transaction_begin_time
       ,dt.database_transaction_log_record_count
       ,dt.database_transaction_log_bytes_used
FROM    sys.dm_tran_session_transactions st
        JOIN sys.dm_tran_database_transactions dt ON st.transaction_id = dt.transaction_id
                                                     AND dt.database_id = DB_ID('FullRecovery')
WHERE   st.session_id = 56;

SELECT  name
       ,user_access_desc
       ,state_desc
       ,log_reuse_wait_desc
FROM    sys.databases;
DBCC SQLPERF('LOGSPACE');
DBCC OPENTRAN (HSP);
DECLARE @schema VARCHAR(MAX);
EXEC master.dbo.sp_IEHP_WhoIsActive @filter = NULL, -- sysname
    @filter_type = '', -- varchar(10)
    @not_filter = NULL, -- sysname
    @not_filter_type = '', -- varchar(10)
    @show_own_spid = NULL, -- bit
    @show_system_spids = NULL, -- bit
    @show_sleeping_spids = 0, -- tinyint
    @get_full_inner_text = NULL, -- bit
    @get_plans = 0, -- tinyint
    @get_outer_command = NULL, -- bit
    @get_transaction_info = NULL, -- bit
    @get_task_info = 0, -- tinyint
    @get_locks = NULL, -- bit
    @get_avg_time = NULL, -- bit
    @get_additional_info = NULL, -- bit
    @find_block_leaders = NULL, -- bit
    @delta_interval = 0, -- tinyint
    @output_column_list = '', -- varchar(8000)
    @sort_order = '', -- varchar(500)
    @format_output = 0, -- tinyint
    @destination_table = '', -- varchar(4000)
    @return_schema = NULL, -- bit
    @schema = @schema OUTPUT, -- varchar(max)
    @help = NULL -- bit
DECLARE @VersionDate DATETIME;
EXEC master.dbo.sp_BlitzFirst @expertmode = 1

EXEC xp_readerrorlog @p1=0,  @p2=1 

DECLARE @VersionDate1 DATETIME;
EXEC master.dbo.sp_Blitz @Help = 0, -- tinyint
    @CheckUserDatabaseObjects = 0, -- tinyint
    @CheckProcedureCache = 0, -- tinyint
    @OutputType = '', -- varchar(20)
    @OutputProcedureCache = 0, -- tinyint
    @CheckProcedureCacheFilter = '', -- varchar(10)
    @CheckServerInfo = 0, -- tinyint
    @SkipChecksServer = N'', -- nvarchar(256)
    @SkipChecksDatabase = N'', -- nvarchar(256)
    @SkipChecksSchema = N'', -- nvarchar(256)
    @SkipChecksTable = N'', -- nvarchar(256)
    @IgnorePrioritiesBelow = 0, -- int
    @IgnorePrioritiesAbove = 0, -- int
    @OutputServerName = N'', -- nvarchar(256)
    @OutputDatabaseName = N'', -- nvarchar(256)
    @OutputSchemaName = N'', -- nvarchar(256)
    @OutputTableName = N'', -- nvarchar(256)
    @OutputXMLasNVARCHAR = 0, -- tinyint
    @EmailRecipients = '', -- varchar(max)
    @EmailProfile = NULL, -- sysname
    @SummaryMode = 0, -- tinyint
    @BringThePain = 0, -- tinyint
    @VersionDate = @VersionDate1 OUTPUT -- datetime
