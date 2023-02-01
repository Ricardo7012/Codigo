-- SYS.DM_OS_WAIT_STATS : http://msdn.microsoft.com/en-us/library/ms179984.aspx 
--*****************************************************************************
-- THE TOTAL TIME SPENT WAITING IS EXPOSED BY THE WAIT_TIME_MS COLUMN, SO YOU CAN CALCULATE THE RESOURCE WAIT TIME, AS FOLLOWS:
-- RESOURCE WAITS = TOTAL WAITS – SIGNAL WAITS (OR (WAIT_TIME_MS) - (SIGNAL_WAIT_TIME_MS))
-- TOTAL WAITS ARE WAIT_TIME_MS (HIGH SIGNAL WAITS INDICATE CPU PRESSURE)
SELECT CAST(100.0 * SUM(signal_wait_time_ms) / SUM(wait_time_ms) AS 
            NUMERIC(20, 2)) AS 
       [%signal (cpu) waits] 
       , CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / 
              SUM(wait_time_ms) AS 
                NUMERIC( 
                20, 2)) 
         AS [%resource waits] 
FROM   
	sys.dm_os_wait_stats;  

--*****************************************************************************
-- CLEAR WAIT STATS
DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR) ;

--*****************************************************************************
-- ISOLATE TOP WAITS FOR SERVER INSTANCE SINCE LAST RESTART OR STATISTICS CLEAR 
WITH waits 
     AS (SELECT wait_type 
                , wait_time_ms / 1000.             AS wait_time_s 
                , 100. * wait_time_ms / SUM(wait_time_ms) 
                                          OVER ( ) AS pct 
                , ROW_NUMBER() 
                    OVER ( 
                      ORDER BY wait_time_ms DESC ) AS rn 
         FROM   sys.dm_os_wait_stats 
         WHERE  wait_type NOT IN ( 'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 
                                   'RESOURCE_QUEUE', 
                                   'SLEEP_TASK', 
                                   'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 
                                   'WAITFOR', 
                                           'LOGMGR_QUEUE', 
                                   'CHECKPOINT_QUEUE', 
                                   'REQUEST_FOR_DEADLOCK_SEARCH', 
                                           'XE_TIMER_EVENT', 
                                                            'BROKER_TO_FLUSH', 
                                   'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 
                                   'CLR_AUTO_EVENT', 
                                   'DISPATCHER_QUEUE_SEMAPHORE' 
                                   , 
                                   'FT_IFTS_SCHEDULER_IDLE_WAIT', 
                                   'XE_DISPATCHER_WAIT', 
                                           'XE_DISPATCHER_JOIN' )) 
SELECT W1.wait_type 
       , CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s 
       , CAST(W1.pct AS DECIMAL(12, 2))         AS pct 
       , CAST(SUM(W2.pct) AS DECIMAL(12, 2))    AS running_pct 
FROM   waits AS W1 
       INNER JOIN waits AS W2 
               ON W2.rn <= W1.rn 
GROUP  BY W1.rn 
          , W1.wait_type 
          , W1.wait_time_s 
          , W1.pct 
HAVING SUM(W2.pct) - W1.pct < 95; -- percentage threshold 

-- RECOVERY MODEL, LOG REUSE WAIT DESCRIPTION, LOG FILE SIZE,
-- LOG USAGE SIZE AND COMPATIBILITY LEVEL FOR ALL DATABASES ON INSTANCE
--TORN PAGE DETECTION WRITES A BIT FOR EVERY 512 BYTES IN THE PAGE.  THIS ALLOWS YOU TO DETECT WHEN A PAGE WAS NOT SUCCESSFULLY WRITTEN TO DISK, BUT DOES NOT TELL YOU IF THE DATA STORED IN THOSE 512 BYTES IS ACTUALLY CORRECT AS A COUPLE OF BYTES MAY HAVE BEEN WRITTEN INCORRECTLY.
--CHECKSUM, ON THE OTHER HAND, CALCULATES A CHECKSUM VALUE AS THE FINAL THING BEFORE PASSING IT TO THE IO SYSTEM TO BE WRITTEN TO DISK.  THIS GUARANTEES THAT SQL SERVER HAD NO PART IN CORRUPTING THE PAGE.  WHEN SQL SERVER READS IT BACK, IF A SINGLE BIT IS DIFFERENT, IT WILL BE CAUGHT, AND A CHECKSUM ERROR (824) WILL BE GENERATED. 
--ACTIVE_TRANSACTION, and your transaction log is 85 percent full, then there should be some alarm bells going off.
SELECT db.[name]                      AS [Database Name] 
       , db.recovery_model_desc       AS [Recovery Model] 
       , db.log_reuse_wait_desc       AS [Log Reuse Wait Description] 
       , ls.cntr_value                AS [Log Size (KB)] 
       , lu.cntr_value                AS [Log Used (KB)] 
       , CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT) AS 
                DECIMAL(18, 2)) * 100 AS [Log Used %] 
       , db.[compatibility_level]     AS [DB Compatibility Level] 
       , db.page_verify_option_desc   AS [Page Verify Option] 
FROM   sys.databases AS db 
       INNER JOIN sys.dm_os_performance_counters AS lu 
               ON db.name = lu.instance_name 
       INNER JOIN sys.dm_os_performance_counters AS ls 
               ON db.name = ls.instance_name 
WHERE  lu.counter_name LIKE 'Log File(s) Used Size (KB)%' 
       AND ls.counter_name LIKE 'Log File(s) Size (KB)%'   
