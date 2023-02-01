-- https://www.brentozar.com/blitz/
/******************************************************************************
SUMMARY:	FIRST RESPONDER 
CONTACT:	RICARDO FERNANDEZ

CHANGELOG:
DATE		USER		DESCRIPTION
2018-05-01	RICARDO		CREATED THIS SCRIPT.
******************************************************************************/


-- https://www.brentozar.com/archive/2006/12/dba-101-using-perfmon-for-sql-performance-tuning/
--USING PERFMON

/******************************************************************************
******************************************************************************/
SELECT name,
       user_access_desc,
       state_desc,
       log_reuse_wait_desc
FROM sys.databases;

/******************************************************************************
******************************************************************************/
DECLARE @schema VARCHAR(MAX);
EXEC dbo.sp_IEHP_WhoIsActive
    --@filter = NULL,               -- sysname
    --@filter_type = '',            -- varchar(10)
    --@not_filter = NULL,           -- sysname
    --@not_filter_type = '',        -- varchar(10)
    @show_own_spid = 1,        -- bit
    @show_system_spids = 0,    -- bit
    @show_sleeping_spids = 0,  -- tinyint
    @get_full_inner_text = 0,  -- bit
    @get_plans = 0,            -- tinyint
    @get_outer_command = 0,    -- bit
    @get_transaction_info = 1, -- bit
    @get_task_info = 1,        -- tinyint
    @get_locks = 1,            -- bit
    @get_avg_time = 1,         -- bit
    @get_additional_info = 1,  -- bit
    @find_block_leaders = 1,   -- bit
    @delta_interval = 0,       -- tinyint
	--@output_column_list = '',     -- varchar(8000)
    @sort_order = 'DESC',      -- varchar(500)
    @format_output = 0,        -- tinyint
    --@destination_table = '',      -- varchar(4000)
    @return_schema = 0,        -- bit
    @schema = @schema OUTPUT,  -- varchar(max)
    @help = 0;                 -- bit

/******************************************************************************
-- https://www.brentozar.com/askbrent/
******************************************************************************/
EXEC dbo.sp_BlitzFirst @ExpertMode = 1;

/******************************************************************************
******************************************************************************/
--1--VALUE OF ERROR LOG FILE YOU WANT TO READ: 0 = CURRENT, 1 = ARCHIVE #1, 2 = ARCHIVE #2, ETC...
--2--LOG FILE TYPE: 1 OR NULL = ERROR LOG, 2 = SQL AGENT LOG
--3--SEARCH STRING 1: STRING ONE YOU WANT TO SEARCH FOR
--4--SEARCH STRING 2: STRING TWO YOU WANT TO SEARCH FOR TO FURTHER REFINE THE RESULTS
--5--SEARCH FROM START TIME
--6--SEARCH TO END TIME
--7--SORT ORDER FOR RESULTS: N'ASC' = ASCENDING, N'DESC' = DESCENDING

--EXEC MASTER.DBO.XP_READERRORLOG 0, 1, '2005', 'EXEC', NULL, NULL, N'DESC' 
--EXEC MASTER.DBO.XP_READERRORLOG 0, 1, '2005', 'EXEC', NULL, NULL, N'ASC' 

EXEC xp_readerrorlog @p1 = 0,
                     @p2 = 1,
                     @P3 = NULL,
                     @P4 = NULL,
                     @P5 = NULL,
                     @P6 = NULL,
                     @p7 = 'desc';

/******************************************************************************
-- https://www.brentozar.com/responder/triage-wait-stats-in-sql-server/
******************************************************************************/
/*
SQL Server Wait Information from sys.dm_os_wait_stats
Copyright (C) 2014, Brent Ozar Unlimited.
See http://BrentOzar.com/go/eula for the End User Licensing Agreement.
*/

/*********************************
Let's build a list of waits we can safely ignore.
*********************************/
IF OBJECT_ID('tempdb..#ignorable_waits') IS NOT NULL
    DROP TABLE #ignorable_waits;
GO

CREATE TABLE #ignorable_waits
(
    wait_type NVARCHAR(256) PRIMARY KEY
);
GO
/* We aren't using row constructors to be SQL 2005 compatible */
set nocount on;
insert #ignorable_waits (wait_type) VALUES ('REQUEST_FOR_DEADLOCK_SEARCH');
insert #ignorable_waits (wait_type) VALUES ('SQLTRACE_INCREMENTAL_FLUSH_SLEEP');
insert #ignorable_waits (wait_type) VALUES ('SQLTRACE_BUFFER_FLUSH');
insert #ignorable_waits (wait_type) VALUES ('LAZYWRITER_SLEEP');
insert #ignorable_waits (wait_type) VALUES ('XE_TIMER_EVENT');
insert #ignorable_waits (wait_type) VALUES ('XE_DISPATCHER_WAIT');
insert #ignorable_waits (wait_type) VALUES ('FT_IFTS_SCHEDULER_IDLE_WAIT');
insert #ignorable_waits (wait_type) VALUES ('LOGMGR_QUEUE');
insert #ignorable_waits (wait_type) VALUES ('CHECKPOINT_QUEUE');
insert #ignorable_waits (wait_type) VALUES ('BROKER_TO_FLUSH');
insert #ignorable_waits (wait_type) VALUES ('BROKER_TASK_STOP');
insert #ignorable_waits (wait_type) VALUES ('BROKER_EVENTHANDLER');
insert #ignorable_waits (wait_type) VALUES ('SLEEP_TASK');
insert #ignorable_waits (wait_type) VALUES ('WAITFOR');
insert #ignorable_waits (wait_type) VALUES ('DBMIRROR_DBM_MUTEX')
insert #ignorable_waits (wait_type) VALUES ('DBMIRROR_EVENTS_QUEUE')
insert #ignorable_waits (wait_type) VALUES ('DBMIRRORING_CMD');
insert #ignorable_waits (wait_type) VALUES ('DISPATCHER_QUEUE_SEMAPHORE');
insert #ignorable_waits (wait_type) VALUES ('BROKER_RECEIVE_WAITFOR');
insert #ignorable_waits (wait_type) VALUES ('CLR_AUTO_EVENT');
insert #ignorable_waits (wait_type) VALUES ('DIRTY_PAGE_POLL');
insert #ignorable_waits (wait_type) VALUES ('HADR_FILESTREAM_IOMGR_IOCOMPLETION');
insert #ignorable_waits (wait_type) VALUES ('ONDEMAND_TASK_QUEUE');
insert #ignorable_waits (wait_type) VALUES ('FT_IFTSHC_MUTEX');
insert #ignorable_waits (wait_type) VALUES ('CLR_MANUAL_EVENT');
insert #ignorable_waits (wait_type) VALUES ('SP_SERVER_DIAGNOSTICS_SLEEP');
insert #ignorable_waits (wait_type) VALUES ('QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP');
insert #ignorable_waits (wait_type) VALUES ('QDS_PERSIST_TASK_MAIN_LOOP_SLEEP');
GO


/* Want to manually exclude an event and recalculate?*/
/* insert #ignorable_waits (wait_type) VALUES (''); */

/*********************************
What are the highest overall waits since startup?
*********************************/
SELECT TOP 25
       os.wait_type,
       SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
       CAST(100. * SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) / (1. * SUM(os.wait_time_ms) OVER ()) AS NUMERIC(12, 1)) AS pct_wait_time,
       SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks,
       CASE
           WHEN SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) > 0 THEN
               CAST(SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type)
                    / (1. * SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type)) AS NUMERIC(12, 1))
           ELSE
               0
       END AS avg_wait_time_ms,
       CURRENT_TIMESTAMP AS sample_time
FROM sys.dm_os_wait_stats os
    LEFT JOIN #ignorable_waits iw
        ON os.wait_type = iw.wait_type
WHERE iw.wait_type IS NULL
ORDER BY sum_wait_time_ms DESC;
GO

/*********************************
What are the higest waits *right now*?
*********************************/

/* Note: this is dependent on the #ignorable_waits table created earlier. */
IF OBJECT_ID('tempdb..#wait_batches') IS NOT NULL
    DROP TABLE #wait_batches;
IF OBJECT_ID('tempdb..#wait_data') IS NOT NULL
    DROP TABLE #wait_data;
GO

CREATE TABLE #wait_batches
(
    batch_id INT IDENTITY PRIMARY KEY,
    sample_time DATETIME NOT NULL
);
CREATE TABLE #wait_data
(
    batch_id INT NOT NULL,
    wait_type NVARCHAR(256) NOT NULL,
    wait_time_ms BIGINT NOT NULL,
    waiting_tasks BIGINT NOT NULL
);
CREATE CLUSTERED INDEX cx_wait_data ON #wait_data (batch_id);
GO

/*
This temporary procedure records wait data to a temp table.
*/
IF OBJECT_ID('tempdb..#get_wait_data') IS NOT NULL
    DROP PROCEDURE #get_wait_data;
GO
CREATE PROCEDURE #get_wait_data
    @intervals TINYINT = 2,
    @delay CHAR(12) = '00:00:30.000' /* 30 seconds*/
AS
DECLARE @batch_id INT,
        @current_interval TINYINT,
        @msg NVARCHAR(MAX);

SET NOCOUNT ON;
SET @current_interval = 1;

WHILE @current_interval <= @intervals
BEGIN
    INSERT #wait_batches
    (
        sample_time
    )
    SELECT CURRENT_TIMESTAMP;

    SELECT @batch_id = SCOPE_IDENTITY();

    INSERT #wait_data
    (
        batch_id,
        wait_type,
        wait_time_ms,
        waiting_tasks
    )
    SELECT @batch_id,
           os.wait_type,
           SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
           SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks
    FROM sys.dm_os_wait_stats os
        LEFT JOIN #ignorable_waits iw
            ON os.wait_type = iw.wait_type
    WHERE iw.wait_type IS NULL
    ORDER BY sum_wait_time_ms DESC;

    SET @msg
        = CONVERT(CHAR(23), CURRENT_TIMESTAMP, 121) + N': Completed sample ' + CAST(@current_interval AS NVARCHAR(4))
          + N' of ' + CAST(@intervals AS NVARCHAR(4)) + '.';
    RAISERROR(@msg, 0, 1) WITH NOWAIT;

    SET @current_interval = @current_interval + 1;

    IF @current_interval <= @intervals
        WAITFOR DELAY @delay;
END;
GO

/*
Let's take two samples 30 seconds apart
*/
EXEC #get_wait_data @intervals = 2, @delay = '00:00:30.000';
GO
;

/*
What were we waiting on?
This query compares the most recent two samples.
*/
WITH max_batch
AS (SELECT TOP 1
           batch_id,
           sample_time
    FROM #wait_batches
    ORDER BY batch_id DESC)
SELECT b.sample_time AS [Second Sample Time],
       DATEDIFF(ss, wb1.sample_time, b.sample_time) AS [Sample Duration in Seconds],
       wd1.wait_type,
       CAST((wd2.wait_time_ms - wd1.wait_time_ms) / 1000. AS NUMERIC(12, 1)) AS [Wait Time (Seconds)],
       (wd2.waiting_tasks - wd1.waiting_tasks) AS [Number of Waits],
       CASE
           WHEN (wd2.waiting_tasks - wd1.waiting_tasks) < 0 THEN
               CAST((wd2.wait_time_ms - wd1.wait_time_ms) / (1.0 * (wd2.waiting_tasks - wd1.waiting_tasks)) AS NUMERIC(12, 1))
           ELSE
               0
       END AS [Avg ms Per Wait]
FROM max_batch b
    JOIN #wait_data wd2
        ON wd2.batch_id = b.batch_id
    JOIN #wait_data wd1
        ON wd1.wait_type = wd2.wait_type
           AND wd2.batch_id - 1 = wd1.batch_id
    JOIN #wait_batches wb1
        ON wd1.batch_id = wb1.batch_id
WHERE (wd2.waiting_tasks - wd1.waiting_tasks) > 0
ORDER BY [Wait Time (Seconds)] DESC;
GO

/******************************************************************************
CURRENT ACTIVITY
******************************************************************************/
SELECT 'CurrentActivity' AS QueryType,
       er.session_id,
       er.start_time,
       [User] = sp.nt_username,
       sp.hostname,
       er.cpu_time, --er.total_elapsed_time, 
       (CASE
            WHEN CONVERT(VARCHAR(10), (GETDATE() - er.start_time), 108) = '23:59:59' THEN
                '00:00:00'
            ELSE
                CONVERT(VARCHAR(10), (GETDATE() - er.start_time), 108)
        END
       ) + ' ( >= ' + CONVERT(VARCHAR(4), DATEDIFF(HOUR, er.start_time, GETDATE())) + ' hrs)' AS Duration,
       [DatabaseName] = DB_NAME(sp.dbid),
       [Status] = er.status,
       [WaitType] = er.wait_type,
       er.logical_reads,
       CASE
           WHEN er.transaction_isolation_level = 0 THEN
               'Unspecified'
           WHEN er.transaction_isolation_level = 1 THEN
               'ReadUncomitted'
           WHEN er.transaction_isolation_level = 2 THEN
               'ReadCommitted'
           WHEN er.transaction_isolation_level = 3 THEN
               'Repeatable'
           WHEN er.transaction_isolation_level = 4 THEN
               'Serializable'
           WHEN er.transaction_isolation_level = 5 THEN
               'Snapshot'
           ELSE
               NULL
       END AS tran_isolation_level,
       [QueryText] = SUBSTRING(
                                  qt.text,
                                  er.statement_start_offset / 2,
                                  (CASE
                                       WHEN er.statement_end_offset = -1 THEN
                                           LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                       ELSE
                                           er.statement_end_offset
                                   END - er.statement_start_offset
                                  ) / 2
                              ),
       [Parent Query] = qt.text,
       [Program] = sp.[program_name],
       er.percent_complete,
       er.reads,
       er.writes,
       er.row_count,
       sp.kpid,
       Protocol = con.net_transport,
       ConnectionWrites = con.num_writes,
       ConnectionReads = con.num_reads,
       ClientAddress = con.client_net_address,
       [Authentication] = con.auth_scheme
--,wt.wait_duration_ms, wt.wait_type, wt.resource_address,
--wt.blocking_session_id,
--wt.resource_description 
FROM sys.dm_exec_requests AS er
    INNER JOIN sys.sysprocesses AS sp
        ON er.session_id = sp.spid
    LEFT JOIN sys.dm_exec_sessions AS ses
        ON ses.session_id = er.session_id
    LEFT JOIN sys.dm_exec_connections AS con
        ON con.session_id = ses.session_id
    --INNER JOIN sys.dm_os_waiting_tasks AS wt ON er.session_id = wt.session_id
    --CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt
    CROSS APPLY sys.dm_exec_sql_text(con.most_recent_sql_handle) AS qt
WHERE er.session_id <> @@SPID
      AND
      (
          er.wait_type NOT IN ( 'BROKER_RECEIVE_WAITFOR', 'WAITFOR' )
          OR er.wait_type IS NULL
      )
--AND blocked <> 0
ORDER BY er.total_elapsed_time DESC;

