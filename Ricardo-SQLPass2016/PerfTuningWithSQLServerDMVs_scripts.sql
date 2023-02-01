/* Complete Code Listing for "Performance Tuning with
SQL Server DMVs" by Tim Ford and Louis Davidson

Please report errata to: http://drsql.org/dmvbook.aspx
*/

/*---------------------------------------------*/
/* CHAPTER 1: USING DYNAMIC MANAGEMENT OBJECTS */
/*---------------------------------------------*/

-- Listing 1.1: Performance troubleshooting based on wait times
SELECT  wait_type ,
        SUM(wait_time_ms / 1000) AS [wait_time_s]
FROM    sys.dm_os_wait_stats DOWS
WHERE   wait_type NOT IN ( 'SLEEP_TASK', 'BROKER_TASK_STOP',
                           'SQLTRACE_BUFFER_FLUSH', 'CLR_AUTO_EVENT',
                           'CLR_MANUAL_EVENT', 'LAZYWRITER_SLEEP' )
GROUP BY wait_type
ORDER BY SUM(wait_time_ms) DESC

--DROP TABLE #baseline
--GO

-- Listing 1.2: Taking the baseline measurement
SELECT  DB_NAME(mf.database_id) AS databaseName ,
        mf.physical_name ,
        divfs.num_of_reads ,
   --other columns removed in this section. See listing 6-14 for complete code
        GETDATE() AS baselineDate
INTO    #baseline
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
        JOIN sys.master_files AS mf ON mf.database_id = divfs.database_id
                                       AND mf.file_id = divfs.file_id

-- Listing 1.3: Returning accumulated file reads since the baseline measurement
WITH  currentLine
        AS ( SELECT   DB_NAME(mf.database_id) AS databaseName ,
                        mf.physical_name ,
                        num_of_reads ,
        --other columms removed
                        GETDATE() AS currentlineDate
             FROM     sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
                        JOIN sys.master_files AS mf
                          ON mf.database_id = divfs.database_id
                             AND mf.file_id = divfs.file_id
             )
  SELECT  currentLine.databaseName ,
        currentLine.physical_name ,
       --gets the time diference in milliseconds since the baseline was taken
        DATEDIFF(millisecond,baseLineDate,currentLineDate) AS elapsed_ms,
        --gets the change in time since the baseline was taken
        currentLine.num_of_reads - #baseline.num_of_reads AS num_of_reads
        --other columns removed
  FROM  currentLine
      INNER JOIN #baseline ON #baseLine.databaseName = currentLine.databaseName
        AND #baseLine.physical_name = currentLine.physical_name 

/*-----------------------------------------------*/
/* CHAPTER 2: CONNECTIONS, SESSIONS AND REQUESTS */
/*-----------------------------------------------*/

-- Listing 2.1: Run the query against sysprocesses.
SELECT  spid ,
        cmd ,
        sql_handle
FROM    sys.sysprocesses
WHERE   DB_NAME(dbid) = 'ReportServer'

-- Listing 2.2: Run the query against sys.dm_exec_requests.
SELECT  session_id ,
        command ,
        sql_handle
FROM    sys.dm_exec_requests
WHERE   DB_NAME(database_id) = 'ReportServer'

-- Listing 2.3: Who is connected?
-- Get a count of SQL connections by IP address
SELECT  dec.client_net_address ,
        des.program_name ,
        des.host_name ,
      --des.login_name ,
        COUNT(dec.session_id) AS connection_count
FROM    sys.dm_exec_sessions AS des
        INNER JOIN sys.dm_exec_connections AS dec
                       ON des.session_id = dec.session_id
-- WHERE   LEFT(des.host_name, 2) = 'WK'
GROUP BY dec.client_net_address ,
         des.program_name ,
         des.host_name 
      -- des.login_name
-- HAVING COUNT(dec.session_id) > 1
ORDER BY des.program_name,
         dec.client_net_address ;

-- Listing 2.4: Who is executing what via SSMS?
SELECT  dec.client_net_address ,
        des.host_name ,
        dest.text
FROM    sys.dm_exec_sessions des
        INNER JOIN sys.dm_exec_connections dec
                     ON des.session_id = dec.session_id
        CROSS APPLY sys.dm_exec_sql_text(dec.most_recent_sql_handle) dest
WHERE   des.program_name LIKE 'Microsoft SQL Server Management Studio%'
ORDER BY des.program_name ,
        dec.client_net_address

-- Listing 2.5: Return session-level settings for the current session.
SELECT  des.text_size ,
        des.language ,
        des.date_format ,
        des.date_first ,
        des.quoted_identifier ,
        des.arithabort ,
        des.ansi_null_dflt_on ,
        des.ansi_defaults ,
        des.ansi_warnings ,
        des.ansi_padding ,
        des.ansi_nulls ,
        des.concat_null_yields_null ,
        des.transaction_isolation_level ,
        des.lock_timeout ,
        des.deadlock_priority
FROM    sys.dm_exec_sessions des
WHERE   des.session_id = @@SPID

-- Listing 2.6: Logins with more than one session.
SELECT  login_name ,
        COUNT(session_id) AS session_count
FROM    sys.dm_exec_sessions
WHERE   is_user_process = 1
GROUP BY login_name
ORDER BY login_name

-- Listing 2.7: Identify sessions with context switching.
SELECT  session_id ,
        login_name ,
        original_login_name
FROM    sys.dm_exec_sessions
WHERE   is_user_process = 1
        AND login_name <> original_login_name

-- Listing 2.8: Sessions that are open but have been inactive for more than 5 days.
DECLARE @days_old SMALLINT 
SELECT  @days_old = 5 

SELECT  des.session_id ,
        des.login_time ,
        des.last_request_start_time ,
        des.last_request_end_time ,
        des.[status] ,
        des.[program_name] ,
        des.cpu_time ,
        des.total_elapsed_time ,
        des.memory_usage ,
        des.total_scheduled_time ,
        des.total_elapsed_time ,
        des.reads ,
        des.writes ,
        des.logical_reads ,
        des.row_count ,
        des.is_user_process
FROM    sys.dm_exec_sessions des
        INNER JOIN sys.dm_tran_session_transactions dtst
                       ON des.session_id = dtst.session_id
WHERE   des.is_user_process = 1
        AND DATEDIFF(dd, des.last_request_end_time, GETDATE()) > @days_old
        AND des.status != 'Running'
ORDER BY des.last_request_end_time

-- Listing 2.9: Identifying sessions with orphaned transactions.
SELECT  des.session_id ,
        des.login_time ,
        des.last_request_start_time ,
        des.last_request_end_time ,
        des.host_name ,
        des.login_name
FROM    sys.dm_exec_sessions des
        INNER JOIN sys.dm_tran_session_transactions dtst
                       ON des.session_id = dtst.session_id
        LEFT JOIN sys.dm_exec_requests der
                       ON dtst.session_id = der.session_id
WHERE   der.session_id IS NULL
ORDER BY des.session_id

-- Listing 2.10: Retrieving the text for a currently executing ad hoc query.
SELECT  dest.text ,
        dest.dbid ,
        dest.objectid
FROM    sys.dm_exec_requests AS der
        CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) AS dest
WHERE   session_id = @@spid ;

-- Listing 2.11: Retrieving the text for a currently executing batch.
SELECT  dest.text
FROM    sys.dm_exec_requests AS der
        CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) AS dest
WHERE   session_id <> @@spid
        AND text LIKE '%waitfor%' ;

-- Listing 2.12: Creating the test stored procedure.
CREATE PROCEDURE dbo.test
AS 
    SELECT  *
    FROM    sys.objects
    WAITFOR DELAY '00:10:00';

-- Listing 2.13: Returning the text of an executing stored procedure
SELECT  dest.dbid ,
        dest.objectid ,
        dest.encrypted ,
        dest.text
FROM    sys.dm_exec_requests AS der
        CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) 
                                                    AS dest
WHERE   objectid = object_id('test', 'p');

-- Listing 2.14: Parsing the SQL text using statement_start_offset and statement_end_offset.
SELECT  der.statement_start_offset ,
        der.statement_end_offset ,
        SUBSTRING(dest.text, der.statement_start_offset / 2,
                  ( CASE WHEN der.statement_end_offset = -1
                         THEN DATALENGTH(dest.text)
                         ELSE der.statement_end_offset
                    END - der.statement_start_offset ) / 2)
                                                AS statement_executing ,
        dest.text AS [full statement code]
FROM    sys.dm_exec_requests der
        INNER JOIN sys.dm_exec_sessions des
                       ON des.session_id = der.session_id
        CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) dest
WHERE   des.is_user_process = 1
        AND der.session_id <> @@spid
ORDER BY der.session_id ;

-- Listing 2.15: Investigating offsets.
WAITFOR DELAY '00:01' ; 
BEGIN TRANSACTION 
-- WAITFOR DELAY '00:01' ; 
INSERT  INTO AdventureWorks.Production.ProductCategory
        ( Name, ModifiedDate )
VALUES  ( 'Reflectors', GETDATE() ) 
ROLLBACK TRANSACTION 

SELECT  Name ,
        ModifiedDate
FROM    AdventureWorks.Production.ProductCategory
WHERE   Name = 'Reflectors' ; 
-- WAITFOR DELAY '00:01' ;

-- Listing 2.16: Requests by CPU consumption.
SELECT  der.session_id ,
        DB_NAME(der.database_id) AS database_name ,
        deqp.query_plan ,
        SUBSTRING(dest.text, der.statement_start_offset / 2,
                  ( CASE WHEN der.statement_end_offset = -1
                         THEN DATALENGTH(dest.text)
                         ELSE der.statement_end_offset
                    END - der.statement_start_offset ) / 2)
                                        AS [statement executing] ,
        der.cpu_time
      --der.granted_query_memory
      --der.wait_time
      --der.total_elapsed_time
      --der.reads 
FROM    sys.dm_exec_requests der
        INNER JOIN sys.dm_exec_sessions des
                       ON des.session_id = der.session_id
        CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) dest
        CROSS APPLY sys.dm_exec_query_plan(der.plan_handle) deqp
WHERE   des.is_user_process = 1
        AND der.session_id <> @@spid
ORDER BY der.cpu_time DESC ;
-- ORDER BY der.granted_query_memory DESC ;
-- ORDER BY der.wait_time DESC;
-- ORDER BY der.total_elapsed_time DESC;
-- ORDER BY der.reads DESC;

-- Listing 2.17: Who is running what?
--  Who is running what at this instant 
SELECT  dest.text AS [Command text] ,
        des.login_time ,
        des.[host_name] ,
        des.[program_name] ,
        der.session_id ,
        dec.client_net_address ,
        der.status ,
        der.command ,
        DB_NAME(der.database_id) AS DatabaseName
FROM    sys.dm_exec_requests der
        INNER JOIN sys.dm_exec_connections dec
                       ON der.session_id = dec.session_id
        INNER JOIN sys.dm_exec_sessions des
                       ON des.session_id = der.session_id
        CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS dest
WHERE   des.is_user_process = 1

-- Listing 2.18: sp_who results.
EXEC sp_who;
EXEC sp_who2;

-- Listing 2.20: A better sp_who2.
SELECT  des.session_id ,
        des.status ,
        des.login_name ,
        des.[HOST_NAME] ,
        der.blocking_session_id ,
        DB_NAME(der.database_id) AS database_name ,
        der.command ,
        des.cpu_time ,
        des.reads ,
        des.writes ,
        dec.last_write ,
        des.[program_name] ,
        der.wait_type ,
        der.wait_time ,
        der.last_wait_type ,
        der.wait_resource ,
        CASE des.transaction_isolation_level
          WHEN 0 THEN 'Unspecified'
          WHEN 1 THEN 'ReadUncommitted'
          WHEN 2 THEN 'ReadCommitted'
          WHEN 3 THEN 'Repeatable'
          WHEN 4 THEN 'Serializable'
          WHEN 5 THEN 'Snapshot'
        END AS transaction_isolation_level ,
        OBJECT_NAME(dest.objectid, der.database_id) AS OBJECT_NAME ,
        SUBSTRING(dest.text, der.statement_start_offset / 2,
                  ( CASE WHEN der.statement_end_offset = -1
                         THEN DATALENGTH(dest.text)
                         ELSE der.statement_end_offset
                    END - der.statement_start_offset ) / 2)
                                          AS [executing statement] ,
        deqp.query_plan
FROM    sys.dm_exec_sessions des
        LEFT JOIN sys.dm_exec_requests der
                      ON des.session_id = der.session_id
        LEFT JOIN sys.dm_exec_connections dec
                      ON des.session_id = dec.session_id
        CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) dest
        CROSS APPLY sys.dm_exec_query_plan(der.plan_handle) deqp
WHERE   des.session_id <> @@SPID
ORDER BY des.session_id

/*-----------------------------------------------*/
/* CHAPTER 3: QUERIES AND QUERY PLANS            */
/*-----------------------------------------------*/

-- Listing 3-1: Flushing the cache of plans belonging to a particular database
--Determine the id of your database
DECLARE @intDBID INTEGER
SET @intDBID = ( SELECT dbid
                 FROM   master.dbo.sysdatabases
                 WHERE  name = 'mydatabasename'
               )

--Flush the procedure cache for your database
DBCC FLUSHPROCINDB (@intDBID)

-- Listing 3-2: Retrieving the query plan for a cached stored procedure
CREATE PROCEDURE ShowQueryText
AS 
    SELECT TOP 10
            object_id ,
            name
    FROM    sys.objects ;
   --waitfor delay '00:00:00'
    SELECT TOP 10
            object_id ,
            name
    FROM    sys.objects ;
    SELECT TOP 10
            object_id ,
            name
    FROM    sys.procedures ;
GO
EXEC dbo.ShowQueryText ;
GO
SELECT  deqp.dbid ,
        deqp.objectid ,
        deqp.encrypted ,
        deqp.query_plan
FROM    sys.dm_exec_query_stats deqs
        CROSS APPLY sys.dm_exec_query_plan(deqs.plan_handle) AS deqp
WHERE   objectid = OBJECT_ID('ShowQueryText', 'p') ;

-- Listing 3-3: Viewing the sql_handle and plan_handle
SELECT  deqs.plan_handle ,
        deqs.sql_handle ,
        execText.text
FROM    sys.dm_exec_query_stats deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.plan_handle) AS execText
WHERE   execText.text LIKE 'CREATE PROCEDURE ShowQueryText%'

-- Listing 3-4: Extracting the SQL text for individual queries in a batch
SELECT  CHAR(13) + CHAR(10)
        + CASE WHEN deqs.statement_start_offset = 0
                    AND deqs.statement_end_offset = -1
               THEN '-- see objectText column--'
               ELSE '-- query --' + CHAR(13) + CHAR(10)
                    + SUBSTRING(execText.text, deqs.statement_start_offset / 2,
                                ( ( CASE WHEN deqs.statement_end_offset = -1
                                         THEN DATALENGTH(execText.text)
                                         ELSE deqs.statement_end_offset
                                    END ) - deqs.statement_start_offset ) / 2)
          END AS queryText ,
        deqp.query_plan
FROM    sys.dm_exec_query_stats deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.plan_handle) AS execText
        CROSS APPLY sys.dm_exec_query_plan(deqs.plan_handle) deqp
WHERE   execText.text LIKE 'CREATE PROCEDURE ShowQueryText%'

-- Listing 3-5: Returning the Plan using sys.dm_exec_text_query_plan
SELECT  deqp.dbid ,
        deqp.objectid ,
        CAST(detqp.query_plan AS XML) AS singleStatementPlan ,
        deqp.query_plan AS batch_query_plan ,
        --this won't actually work in all cases because nominal plans aren't
        -- cached, so you won't see a plan for waitfor if you uncomment it
        ROW_NUMBER() OVER ( ORDER BY Statement_Start_offset )
                                                AS query_position ,
        CASE WHEN deqs.statement_start_offset = 0
                  AND deqs.statement_end_offset = -1
             THEN '-- see objectText column--'
             ELSE '-- query --' + CHAR(13) + CHAR(10)
                  + SUBSTRING(execText.text, deqs.statement_start_offset / 2,
                              ( ( CASE WHEN deqs.statement_end_offset = -1
                                       THEN DATALENGTH(execText.text)
                                       ELSE deqs.statement_end_offset
                                  END ) - deqs.statement_start_offset ) / 2)
        END AS queryText
FROM    sys.dm_exec_query_stats deqs
        CROSS APPLY sys.dm_exec_text_query_plan(deqs.plan_handle,
                                                deqs.statement_start_offset,
                                                deqs.statement_end_offset)
                                                                     AS detqp
        CROSS APPLY sys.dm_exec_query_plan(deqs.plan_handle) AS deqp
        CROSS APPLY sys.dm_exec_sql_text(deqs.plan_handle) AS execText
WHERE   deqp.objectid = OBJECT_ID('ShowQueryText', 'p') ;

-- Listing 3-6: Retreiving the plans for compiled objects
SELECT  refcounts ,
        usecounts ,
        size_in_bytes ,
        cacheobjtype ,
        objtype
FROM    sys.dm_exec_cached_plans
WHERE   objtype IN ( 'proc', 'prepared ' ) ;

-- Listing 3-7: Total number of cached plans
SELECT  COUNT(*)
FROM    sys.dm_exec_cached_plans ;

-- Listing 3-8: An overview of plan reuse
SELECT  MAX(CASE WHEN usecounts BETWEEN 10 AND 100 THEN '10-100'
                 WHEN usecounts BETWEEN 101 AND 1000 THEN '101-1000'
                 WHEN usecounts BETWEEN 1001 AND 5000 THEN '1001-5000'
                 WHEN usecounts BETWEEN 5001 AND 10000 THEN '5001-10000'
                 ELSE CAST(usecounts AS VARCHAR(100))
            END) AS usecounts ,
        COUNT(*) AS countInstance
FROM    sys.dm_exec_cached_plans
GROUP BY CASE WHEN usecounts BETWEEN 10 AND 100 THEN 50
              WHEN usecounts BETWEEN 101 AND 1000 THEN 500
              WHEN usecounts BETWEEN 1001 AND 5000 THEN 2500
              WHEN usecounts BETWEEN 5001 AND 10000 THEN 7500
              ELSE usecounts
         END
ORDER BY CASE WHEN usecounts BETWEEN 10 AND 100 THEN 50
              WHEN usecounts BETWEEN 101 AND 1000 THEN 500
              WHEN usecounts BETWEEN 1001 AND 5000 THEN 2500
              WHEN usecounts BETWEEN 5001 AND 10000 THEN 7500
              ELSE usecounts
         END DESC ;

-- Listing 3-9: Investigating the most-used plans
SELECT TOP 2 WITH TIES
        decp.usecounts ,
        decp.cacheobjtype ,
        decp.objtype ,
        deqp.query_plan ,
        dest.text
FROM    sys.dm_exec_cached_plans decp
        CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp
        CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
ORDER BY usecounts DESC ;

-- Listing 3-10: Examining plan reuse for a single procedure
SELECT  usecounts ,
        cacheobjtype ,
        objtype ,
        OBJECT_NAME(dest.objectid)
FROM    sys.dm_exec_cached_plans decp
        CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
WHERE   dest.objectid = OBJECT_ID('<procedureName>')
        AND dest.dbid = DB_ID()
ORDER BY usecounts DESC ;

-- Listing 3-11: Examining single-use plans in the cache
-- Find single-use, ad-hoc queries that are bloating the plan cache
SELECT TOP ( 100 )
        [text] ,
        cp.size_in_bytes
FROM    sys.dm_exec_cached_plans AS cp
        CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE   cp.cacheobjtype = 'Compiled Plan'
        AND cp.objtype = 'Adhoc'
        AND cp.usecounts = 1
ORDER BY cp.size_in_bytes DESC ;
-- Listing 3-12: Non-parameterized ad-hoc SQL
-- Query 1
SELECT  FirstName ,
        LastName
FROM    dbo.Employee
WHERE   EmpID = 5

-- Query 2
SELECT  FirstName ,
        LastName
FROM    dbo.Employee
WHERE   EmpID = 187

-- Listing 3-13: Examining plan attributes
SELECT  CAST(depa.attribute AS VARCHAR(30)) AS attribute ,
        CAST(depa.value AS VARCHAR(30)) AS value ,
        depa.is_cache_key
FROM    ( SELECT TOP 1
                    *
          FROM      sys.dm_exec_cached_plans
          ORDER BY  usecounts DESC
        ) decp
        OUTER APPLY sys.dm_exec_plan_attributes(decp.plan_handle) depa
WHERE   is_cache_key = 1
ORDER BY usecounts DESC ;

-- Listing 3-14: Finding the CPU-intensive queries
SELECT TOP 3
        total_worker_time ,
        execution_count ,
        total_worker_time / execution_count AS [Avg CPU Time] ,
        CASE WHEN deqs.statement_start_offset = 0
                  AND deqs.statement_end_offset = -1
             THEN '-- see objectText column--'
             ELSE '-- query --' + CHAR(13) + CHAR(10)
                  + SUBSTRING(execText.text, deqs.statement_start_offset / 2,
                              ( ( CASE WHEN deqs.statement_end_offset = -1
                                       THEN DATALENGTH(execText.text)
                                       ELSE deqs.statement_end_offset
                                  END ) - deqs.statement_start_offset ) / 2)
        END AS queryText
FROM    sys.dm_exec_query_stats deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.plan_handle) AS execText
ORDER BY deqs.total_worker_time DESC ;

-- Listing 3-15: Grouping by sql_handle to see query stats at the batch level
SELECT TOP 100
        SUM(total_logical_reads) AS total_logical_reads ,
        COUNT(*) AS num_queries , --number of individual queries in batch
        --not all usages need be equivalent, in the case of looping
        --or branching code
        MAX(execution_count) AS execution_count ,
        MAX(execText.text) AS queryText
FROM    sys.dm_exec_query_stats deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS execText
GROUP BY deqs.sql_handle
HAVING  AVG(total_logical_reads / execution_count) <> SUM(total_logical_reads)
        / SUM(execution_count)
ORDER BY 1 DESC 

-- Listing 3-16: Investigating logical reads performed by cached stored procedures
-- Top Cached SPs By Total Logical Reads (SQL 2008 only).
-- Logical reads relate to memory pressure
SELECT TOP ( 25 )
        p.name AS [SP Name] ,
        deps.total_logical_reads AS [TotalLogicalReads] ,
        deps.total_logical_reads / deps.execution_count AS [AvgLogicalReads] ,
        deps.execution_count ,
        ISNULL(deps.execution_count / DATEDIFF(Second, deps.cached_time,
                                           GETDATE()), 0) AS [Calls/Second] ,
        deps.total_elapsed_time ,
        deps.total_elapsed_time / deps.execution_count AS [avg_elapsed_time] ,
        deps.cached_time
FROM    sys.procedures AS p
        INNER JOIN sys.dm_exec_procedure_stats
                       AS deps ON p.[object_id] = deps.[object_id]
WHERE   deps.database_id = DB_ID()
ORDER BY deps.total_logical_reads DESC ;


-- Listing 3-17: Examine optimizer counters
SELECT  counter ,
        occurrence ,
        value
FROM    sys.dm_exec_query_optimizer_info
WHERE   counter IN ( 'optimizations', 'elapsed time', 'final cost' ) ;


-- Listing 3-18: Trivial changes to query text can affect plan reuse
SELECT  COUNTER ,
        OCCURRENCE ,
        VALUE
FROM    SYS.DM_EXEC_QUERY_OPTIMIZER_INFO
WHERE   COUNTER IN ( 'optimizations', 'elapsed time', 'final cost' ) ;

/*-----------------------------------------------*/
/* CHAPTER 4: TRANSACTIONS                       */
/*-----------------------------------------------*/

-- Listing 4.1: All statements within SQL Server are transactional.
SELECT  DTAT.transaction_id
FROM    sys.dm_tran_active_transactions DTAT
WHERE   DTAT.name <> 'worktable' ; 

SELECT  DTAT.transaction_id
FROM    sys.dm_tran_active_transactions DTAT
WHERE   DTAT.name <> 'worktable' ; 

BEGIN TRAN 
SELECT  DTAT.transaction_id
FROM    sys.dm_tran_active_transactions DTAT
WHERE   DTAT.name <> 'worktable' ; 

SELECT  DTAT.transaction_id
FROM    sys.dm_tran_active_transactions DTAT
WHERE   DTAT.name <> 'worktable' ; 
COMMIT TRAN

-- Listing 4.2: An uncommitted update of the Production table in AdventureWorks.
BEGIN TRANSACTION 
UPDATE [Production].[ProductCategory] 
SET [Name] = 'Parts' 
WHERE [Name] = 'Components'; 
--ROLLBACK TRANSACTION

-- Listing 4.3: Locking due to single UPDATE statement against a user table in SQL Server.
SELECT  [resource_type] ,
        DB_NAME([resource_database_id]) AS [Database Name] ,
        CASE WHEN DTL.resource_type IN ( 'DATABASE', 'FILE', 'METADATA' )
             THEN DTL.resource_type
             WHEN DTL.resource_type = 'OBJECT'
             THEN OBJECT_NAME(DTL.resource_associated_entity_id,
                              DTL.[resource_database_id])
             WHEN DTL.resource_type IN ( 'KEY', 'PAGE', 'RID' )
             THEN ( SELECT  OBJECT_NAME([object_id])
                    FROM    sys.partitions
                    WHERE   sys.partitions.hobt_id = 
                                            DTL.resource_associated_entity_id
                  )
             ELSE 'Unidentified'
        END AS requested_object_name ,
        [request_mode] ,
        [resource_description]
FROM    sys.dm_tran_locks DTL
WHERE   DTL.[resource_type] <> 'DATABASE' ;
-- Listing 4.4: A simple query against the ProductCategory table, which will be blocked.
SELECT  *
FROM    [Production].[ProductCategory] ;

-- Listing 4.5: Which sessions are causing blocking and what statement are they running? 
SELECT  DTL.[request_session_id] AS [session_id] ,
        DB_NAME(DTL.[resource_database_id]) AS [Database] ,
        DTL.resource_type ,
        CASE WHEN DTL.resource_type IN ( 'DATABASE', 'FILE', 'METADATA' )
             THEN DTL.resource_type
             WHEN DTL.resource_type = 'OBJECT'
             THEN OBJECT_NAME(DTL.resource_associated_entity_id,
                              DTL.[resource_database_id])
             WHEN DTL.resource_type IN ( 'KEY', 'PAGE', 'RID' )
             THEN ( SELECT  OBJECT_NAME([object_id])
                    FROM    sys.partitions
                    WHERE   sys.partitions.hobt_id = 
                                            DTL.resource_associated_entity_id
                  )
             ELSE 'Unidentified'
        END AS [Parent Object] ,
        DTL.request_mode AS [Lock Type] ,
        DTL.request_status AS [Request Status] ,
        DER.[blocking_session_id] ,
        DES.[login_name] ,
        CASE DTL.request_lifetime
          WHEN 0 THEN DEST_R.TEXT
          ELSE DEST_C.TEXT
        END AS [Statement]
FROM    sys.dm_tran_locks DTL
        LEFT JOIN sys.[dm_exec_requests] DER
                   ON DTL.[request_session_id] = DER.[session_id]
        INNER JOIN sys.dm_exec_sessions DES
                   ON DTL.request_session_id = DES.[session_id]
        INNER JOIN sys.dm_exec_connections DEC
                   ON DTL.[request_session_id] = DEC.[most_recent_session_id]
        OUTER APPLY sys.dm_exec_sql_text(DEC.[most_recent_sql_handle])
                                                         AS DEST_C
        OUTER APPLY sys.dm_exec_sql_text(DER.sql_handle) AS DEST_R
WHERE   DTL.[resource_database_id] = DB_ID()
        AND DTL.[resource_type] NOT IN ( 'DATABASE', 'METADATA' )
ORDER BY DTL.[request_session_id] ;

-- Listing 4.6: Investigating locking and blocking based on waiting tasks
USE [AdventureWorks] ;
GO
SELECT  DTL.[resource_type] AS [resource type] ,
        CASE WHEN DTL.[resource_type] IN ( 'DATABASE', 'FILE', 'METADATA' )
             THEN DTL.[resource_type]
             WHEN DTL.[resource_type] = 'OBJECT'
             THEN OBJECT_NAME(DTL.resource_associated_entity_id)
             WHEN DTL.[resource_type] IN ( 'KEY', 'PAGE', 'RID' )
             THEN ( SELECT  OBJECT_NAME([object_id])
                    FROM    sys.partitions
                    WHERE   sys.partitions.[hobt_id] = 
                                 DTL.[resource_associated_entity_id]
                  )
             ELSE 'Unidentified'
        END AS [Parent Object] ,
        DTL.[request_mode] AS [Lock Type] ,
        DTL.[request_status] AS [Request Status] ,
        DOWT.[wait_duration_ms] AS [wait duration ms] ,
        DOWT.[wait_type] AS [wait type] ,
        DOWT.[session_id] AS [blocked session id] ,
        DES_blocked.[login_name] AS [blocked_user] ,
        SUBSTRING(dest_blocked.text, der.statement_start_offset / 2,
                  ( CASE WHEN der.statement_end_offset = -1
                         THEN DATALENGTH(dest_blocked.text)
                         ELSE der.statement_end_offset
                    END - der.statement_start_offset ) / 2
                                              AS [blocked_command] ,
        DOWT.[blocking_session_id] AS [blocking session id] ,
        DES_blocking.[login_name] AS [blocking user] ,
        DEST_blocking.[text] AS [blocking command] ,
        DOWT.resource_description AS [blocking resource detail]
FROM    sys.dm_tran_locks DTL
        INNER JOIN sys.dm_os_waiting_tasks DOWT
                    ON DTL.lock_owner_address = DOWT.resource_address
        INNER JOIN sys.[dm_exec_requests] DER
                    ON DOWT.[session_id] = DER.[session_id]
        INNER JOIN sys.dm_exec_sessions DES_blocked
                    ON DOWT.[session_id] = DES_Blocked.[session_id]
        INNER JOIN sys.dm_exec_sessions DES_blocking
                    ON DOWT.[blocking_session_id] = DES_Blocking.[session_id]
        INNER JOIN sys.dm_exec_connections DEC
                    ON DTL.[request_session_id] = DEC.[most_recent_session_id]
        CROSS APPLY sys.dm_exec_sql_text(DEC.[most_recent_sql_handle])
                                                         AS DEST_Blocking
        CROSS APPLY sys.dm_exec_sql_text(DER.sql_handle) AS DEST_Blocked
WHERE   DTL.[resource_database_id] = DB_ID()

-- Listing 4.7: An uncommitted UPDATE transaction on the Production.Culture table
BEGIN TRANSACTION
UPDATE  Production.Culture
SET     Name = 'English-British'
WHERE   Name = 'English' ;
--ROLLBACK TRANSACTION

-- Listing 4.8: A blocked query against the Production.Culture table
SELECT  ModifiedDate
FROM    Production.Culture
WHERE   Name = 'English' ;

-- Listing 4.9:An INSERT against the Production.Culture table
INSERT  INTO Production.Culture
        ( CultureID, Name )
VALUES  ( 'jp', 'Japanese' ) ;

SELECT  *
FROM    Production.Culture ;

-- Listing 4.10: Basic query against sys.dm_tran_session_transactions for transactions on the current session.
BEGIN TRANSACTION 
SELECT  DTST.[session_id] ,
        DTST.[transaction_id] ,
        DTST.[is_user_transaction]
FROM    sys.[dm_tran_session_transactions] AS DTST
WHERE   DTST.[session_id] = @@SPID
ORDER BY DTST.[transaction_id] 
COMMIT

-- Listing 4.11: Querying sys.dm_db_tran_active_transactions.
SELECT  DTAT.transaction_id ,
        DTAT.[name] ,
        DTAT.transaction_begin_time ,
        CASE DTAT.transaction_type
          WHEN 1 THEN 'Read/write'
          WHEN 2 THEN 'Read-only'
          WHEN 3 THEN 'System'
          WHEN 4 THEN 'Distributed'
        END AS transaction_type ,
        CASE DTAT.transaction_state
          WHEN 0 THEN 'Not fully initialized'
          WHEN 1 THEN 'Initialized, not started'
          WHEN 2 THEN 'Active'
          WHEN 3 THEN 'Ended' -- only applies to read-only transactions
          WHEN 4 THEN 'Commit initiated'-- distributed transactions only
          WHEN 5 THEN 'Prepared, awaiting resolution' 
          WHEN 6 THEN 'Committed'
          WHEN 7 THEN 'Rolling back'
          WHEN 8 THEN 'Rolled back'
        END AS transaction_state ,
        CASE DTAT.dtc_state
          WHEN 1 THEN 'Active'
          WHEN 2 THEN 'Prepared'
          WHEN 3 THEN 'Committed'
          WHEN 4 THEN 'Aborted'
          WHEN 5 THEN 'Recovered'
        END AS dtc_state
FROM    sys.dm_tran_active_transactions DTAT
        INNER JOIN sys.dm_tran_session_transactions DTST
                         ON DTAT.transaction_id = DTST.transaction_id
WHERE   [DTST].[is_user_transaction] = 1
ORDER BY DTAT.transaction_begin_time 

-- Listing 4.12: Eliminating worktables from the results returned by active_transactions.
…
FROM sys.dm_tran_active_transactions DTAT 
WHERE DTAT.name <> 'worktable' 
ORDER BY DTAT.transaction_begin_time

-- Listing 4.13: Decoding the integer values returned by database_transaction_state.
        CASE SDTDT.database_transaction_state
          WHEN 1 THEN 'Not initialized'
          WHEN 3 THEN 'initialized, but not producing log records'
          WHEN 4 THEN 'Producing log records'
          WHEN 5 THEN 'Prepared'
          WHEN 10 THEN 'Committed'
          WHEN 11 THEN 'Rolled back'
          WHEN 12 THEN 'Commit in process'

-- Listing 4.14: Transaction log impact of active transactions.
SELECT DTST.[session_id], 
 DES.[login_name] AS [Login Name], 
 DB_NAME (DTDT.database_id) AS [Database], 
 DTDT.[database_transaction_begin_time] AS [Begin Time], 
 -- DATEDIFF(ms,DTDT.[database_transaction_begin_time], GETDATE()) AS [Duration ms], 
 CASE DTAT.transaction_type 
   WHEN 1 THEN 'Read/write' 
    WHEN 2 THEN 'Read-only' 
    WHEN 3 THEN 'System' 
    WHEN 4 THEN 'Distributed' 
  END AS [Transaction Type], 
  CASE DTAT.transaction_state 
    WHEN 0 THEN 'Not fully initialized' 
    WHEN 1 THEN 'Initialized, not started' 
    WHEN 2 THEN 'Active' 
    WHEN 3 THEN 'Ended' 
    WHEN 4 THEN 'Commit initiated' 
    WHEN 5 THEN 'Prepared, awaiting resolution' 
    WHEN 6 THEN 'Committed' 
    WHEN 7 THEN 'Rolling back' 
    WHEN 8 THEN 'Rolled back' 
  END AS [Transaction State], 
 DTDT.[database_transaction_log_record_count] AS [Log Records], 
 DTDT.[database_transaction_log_bytes_used] AS [Log Bytes Used], 
 DTDT.[database_transaction_log_bytes_reserved] AS [Log Bytes RSVPd], 
 DEST.[text] AS [Last Transaction Text], 
 DEQP.[query_plan] AS [Last Query Plan] 
FROM sys.dm_tran_database_transactions DTDT 
 INNER JOIN sys.dm_tran_session_transactions DTST 
   ON DTST.[transaction_id] = DTDT.[transaction_id] 
 INNER JOIN sys.[dm_tran_active_transactions] DTAT 
   ON DTST.[transaction_id] = DTAT.[transaction_id] 
 INNER JOIN sys.[dm_exec_sessions] DES 
   ON DES.[session_id] = DTST.[session_id] 
 INNER JOIN sys.dm_exec_connections DEC 
   ON DEC.[session_id] = DTST.[session_id] 
 LEFT JOIN sys.dm_exec_requests DER 
   ON DER.[session_id] = DTST.[session_id] 
 CROSS APPLY sys.dm_exec_sql_text (DEC.[most_recent_sql_handle]) AS DEST 
 OUTER APPLY sys.dm_exec_query_plan (DER.[plan_handle]) AS DEQP 
ORDER BY DTDT.[database_transaction_log_bytes_used] DESC;
-- ORDER BY [Duration ms] DESC;

-- Listing 4.15: Enabling Snapshot isolation at the database level
ALTER DATABASE Test SET ALLOW_SNAPSHOT_ISOLATION ON;

-- Listing 4.16: Enabling SNAPSHOT isolation mode for a given session.
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

-- Listing 4.17: Enabling READ_COMMITTED_SNAPSHOT mode for a database.
ALTER DATABASE Test SET READ_COMMITTED_SNAPSHOT ON;

-- Listing 4.18: Which databases are using snapshot isolation?
SELECT  SD.[name] ,
        SD.snapshot_isolation_state_desc ,
        SD.is_read_committed_snapshot_on
FROM    sys.databases SD
WHERE   SD.snapshot_isolation_state_desc = 'ON'   


-- Listing 4.19: Creating the sample Culture table.
CREATE TABLE [dbo].[Culture]
    (
      [CultureID] [nchar](6) NOT NULL ,
      [Name] NVARCHAR(50) NOT NULL ,
      [ModifiedDate] [datetime] NOT NULL ,
      CONSTRAINT [PK_Culture_CultureID] PRIMARY KEY CLUSTERED
        ( [CultureID] ASC )
        WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
               IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
               ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
    )
ON  [PRIMARY]
GO

-- Listing 4.20: Enabling snapshot isolation in the DMV database.
-- Specify that snapshot isolation is enabled
-- does not affect the default behavior.
ALTER DATABASE DMV  SET ALLOW_SNAPSHOT_ISOLATION ON ;
GO

-- READ_COMMITTED_SNAPSHOT becomes the default isolation level.
ALTER DATABASE DMV  SET READ_COMMITTED_SNAPSHOT ON ;
GO

-- Listing 4.21: Tab 1, query then update the Culture table.
USE DMV ;
GO

SELECT  CultureID ,
        Name
FROM    dbo.Culture ;

BEGIN TRANSACTION
UPDATE  dbo.[Culture]
SET     [Name] = 'English-British'
WHERE   [Name] = 'English' ;

-- COMMIT ; 
-- ROLLBACK;

-- Listing 4.22: Tab 2, an open transaction that inserts a row into the Culture table.
USE DMV ;
GO

BEGIN TRANSACTION ;
INSERT  INTO dbo.[Culture] ([CultureID], [Name], [ModifiedDate])
VALUES  ('jp', 'Japanese', '2010-08-01') ;
-- COMMIT ;  

-- Listing 4.23: Tab 3, a query using SNAPSHOT isolation.
IF @@TRANCOUNT = 0 
    BEGIN ;
        SET TRANSACTION ISOLATION LEVEL SNAPSHOT ;
        PRINT 'Beginning transaction' ;
        BEGIN TRANSACTION ; 
    END ;
SELECT  CultureID ,
        Name
FROM    dbo.Culture ;
--commit;

-- Listing 4.24: Tab 4, a query using READ_COMMITTED_SNAPSHOT isolation.
IF @@TRANCOUNT = 0 
    BEGIN ;
-- since we have already set READ_COMMITTED_SNAPSHOT to ON
-- this is  READ_COMMITTED_SNAPSHOT
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
        PRINT 'Beginning transaction' ;
        BEGIN TRANSACTION ; 
    END ;
SELECT  CultureID ,
        Name
FROM    dbo.Culture ;
-- COMMIT;

-- Listing 4.25: A count of currently active snapshot transactions.
SELECT  COUNT([transaction_sequence_num]) AS [snapshot transaction count]
FROM    sys.dm_tran_transactions_snapshot ;

-- Listing 4.26: Interrogating the active_snapshot_database_transactions DMV.
SELECT  DTASDT.transaction_id ,
        DTASDT.session_id ,
        DTASDT.transaction_sequence_num ,
        DTASDT.first_snapshot_sequence_num ,
        DTASDT.commit_sequence_num ,
        DTASDT.is_snapshot ,
        DTASDT.elapsed_time_seconds ,
        DEST.text AS [command text]
FROM    sys.dm_tran_active_snapshot_database_transactions DTASDT
        INNER JOIN sys.dm_exec_connections DEC
                       ON DTASDT.session_id = DEC.most_recent_session_id
        INNER JOIN sys.dm_tran_database_transactions DTDT
                       ON DTASDT.transaction_id = DTDT.transaction_id
        CROSS APPLY sys.dm_exec_sql_text(DEC.most_recent_sql_handle) AS DEST
WHERE   DTDT.database_id = DB_ID()

-- Listing 4.27: Correlating the activity of the various transactions that are using the version store.
SELECT  DTTS.[transaction_sequence_num] ,
        trx_current.[session_id] AS current_session_id ,
        DES_current.[login_name] AS [current session login] ,
        DEST_current.text AS [current session command] ,
        DTTS.[snapshot_sequence_num] ,
        trx_existing.[session_id] AS existing_session_id ,
        DES_existing.[login_name] AS [existing session login] ,
        DEST_existing.text AS [existing session command]
FROM    sys.dm_tran_transactions_snapshot DTTS
        INNER JOIN sys.[dm_tran_active_snapshot_database_transactions]
                                                                trx_current
                         ON DTTS.[transaction_sequence_num] = 
                                  trx_current.[transaction_sequence_num]
        INNER JOIN sys.[dm_exec_connections] DEC_current
                         ON trx_current.[session_id] = 
                                         DEC_current.[most_recent_session_id]
        INNER JOIN sys.[dm_exec_sessions] DES_current
                         ON DEC_current.[most_recent_session_id] = 
                                         DES_current.[session_id]
        INNER JOIN sys.[dm_tran_active_snapshot_database_transactions]
                                                               trx_existing
                         ON DTTS.[snapshot_sequence_num] =
                                   trx_existing.[transaction_sequence_num]
        INNER JOIN sys.[dm_exec_connections] DEC_existing
                         ON trx_existing.[session_id] =
                                         DEC_existing.[most_recent_session_id]
        INNER JOIN sys.[dm_exec_sessions] DES_existing
                         ON DEC_existing.[most_recent_session_id] =
                                           DES_existing.[session_id]
        CROSS APPLY sys.[dm_exec_sql_text]
                         (DEC_current.[most_recent_sql_handle]) DEST_current
        CROSS APPLY sys.[dm_exec_sql_text]
                         (DEC_existing.[most_recent_sql_handle]) DEST_existing
ORDER BY DTTS.[transaction_sequence_num] ,
        DTTS.[snapshot_sequence_num] ;

-- Listing 4.28: Returning raw data from sys.dm_tra_version_store.
SELECT  DB_NAME(DTVS.database_id) AS [Database Name] ,
        DTVS.[transaction_sequence_num] ,
        DTVS.[version_sequence_num] ,
        CASE DTVS.[status]
          WHEN 0 THEN '1'
          WHEN 1 THEN '2'
        END AS [pages] ,
        DTVS.[record_length_first_part_in_bytes]
        + DTVS.[record_length_second_part_in_bytes] AS [record length (bytes)]
FROM    sys.dm_tran_version_store DTVS
ORDER BY DB_NAME(DTVS.database_id) ,
        DTVS.transaction_sequence_num ,
        DTVS.version_sequence_num

-- Listing 4.29: Storage requirements for the version store in the AdventureWorks database.
SELECT  DB_NAME(DTVS.[database_id]) ,
        SUM(DTVS.[record_length_first_part_in_bytes]
            + DTVS.[record_length_second_part_in_bytes]) AS [total store bytes consumed]
FROM    sys.dm_tran_version_store DTVS
GROUP BY DB_NAME(DTVS.[database_id]) ;

-- Listing 4.30: Finding the highest-consuming version store record within tempdb.
WITH    version_store ( [rowset_id], [bytes consumed] )
          AS ( SELECT TOP 1
                        [rowset_id] ,
                        SUM([record_length_first_part_in_bytes]
                            + [record_length_second_part_in_bytes])
                                                          AS [bytes consumed]
               FROM     sys.dm_tran_version_store
               GROUP BY [rowset_id]
               ORDER BY SUM([record_length_first_part_in_bytes]
                            + [record_length_second_part_in_bytes])
             )
    SELECT  VS.[rowset_id] ,
            VS.[bytes consumed] ,
            DB_NAME(DTVS.[database_id]) AS [database name] ,
            DTASDT.[session_id] AS session_id ,
            DES.[login_name] AS [session login] ,
            DEST.text AS [session command]
    FROM    version_store VS
            INNER JOIN sys.[dm_tran_version_store] DTVS
                         ON VS.rowset_id = DTVS.[rowset_id]
            INNER JOIN sys.[dm_tran_active_snapshot_database_transactions]
                                                                      DTASDT
                         ON DTVS.[transaction_sequence_num] = 
                                           DTASDT.[transaction_sequence_num]
            INNER JOIN sys.dm_exec_connections DEC
                         ON DTASDT.[session_id] = DEC.[most_recent_session_id]
            INNER JOIN sys.[dm_exec_sessions] DES
                         ON DEC.[most_recent_session_id] = DES.[session_id]
            CROSS APPLY sys.[dm_exec_sql_text](DEC.[most_recent_sql_handle]) 
                                                                       DEST ;

-- Listing 4.31: Returning raw data from sys.dm_tran_top_version_generators.
SELECT  DB_NAME(DTTVG.[database_id]) ,
        DTTVG.[rowset_id] ,
        DTTVG.[aggregated_record_length_in_bytes]
FROM    sys.[dm_tran_top_version_generators] DTTVG
ORDER BY DTTVG.[aggregated_record_length_in_bytes] DESC ;

/*-----------------------------------------------*/
/* CHAPTER 5: INDEXING STRATEGY AND MAINTENANCE  */
/*-----------------------------------------------*/

-- Listing 5.1: Querying index use in the AdventureWorks database.
SELECT  DB_NAME(ddius.[database_id]) AS database_name ,
        OBJECT_NAME(ddius.[object_id], DB_ID('AdventureWorks'))
                                                  AS [object_name] ,
        asi.[name] AS index_name ,
        ddius.user_seeks + ddius.user_scans + ddius.user_lookups AS user_reads
FROM    sys.dm_db_index_usage_stats ddius
        INNER JOIN AdventureWorks.sys.indexes asi
                   ON ddius.[object_id] = asi.[object_id]
                      AND ddius.index_id = asi.index_id ;

-- Listing 5.2: The combination of object_id and index_id cannot guarantee uniqueness at the instance level.
SELECT  DB_NAME(ddius.[database_id]) AS [database_name] ,
        ddius.[database_id] ,
        ddius.[object_id] ,
        ddius.[index_id]
FROM    sys.[dm_db_index_usage_stats] ddius
        INNER JOIN AdventureWorks.sys.[indexes] asi
            ON ddius.[object_id] = asi.[object_id]
               AND ddius.[index_id] = asi.[index_id]

-- Listing 5.3: Usage stats for indexes that have been used to resolve a query.
SELECT  OBJECT_NAME(ddius.[object_id], ddius.database_id) AS [object_name] ,
        ddius.index_id ,
        ddius.user_seeks ,
        ddius.user_scans ,
        ddius.user_lookups ,
        ddius.user_seeks + ddius.user_scans + ddius.user_lookups 
                                                     AS user_reads ,
        ddius.user_updates AS user_writes ,
        ddius.last_user_scan ,
        ddius.last_user_update
FROM    sys.dm_db_index_usage_stats ddius
WHERE   ddius.database_id > 4 -- filter out system tables
        AND OBJECTPROPERTY(ddius.object_id, 'IsUserTable') = 1
        AND ddius.index_id > 0  -- filter out heaps 
ORDER BY ddius.user_scans DESC

-- Listing 5.4: Finding unused indexes.
-- List unused indexes
SELECT  OBJECT_NAME(i.[object_id]) AS [Table Name] ,
        i.name
FROM    sys.indexes AS i
        INNER JOIN sys.objects AS o ON i.[object_id] = o.[object_id]
WHERE   i.index_id NOT IN ( SELECT  ddius.index_id
                            FROM    sys.dm_db_index_usage_stats AS ddius
                            WHERE   ddius.[object_id] = i.[object_id]
                                    AND i.index_id = ddius.index_id
                                    AND database_id = DB_ID() )
        AND o.[type] = 'U'
ORDER BY OBJECT_NAME(i.[object_id]) ASC ;

-- Listing 5.5: Querying sys.dm_db_index_usage_stats for indexes that are being maintained but not used.
SELECT  '[' + DB_NAME() + '].[' + su.[name] + '].[' + o.[name] + ']'
            AS [statement] ,
        i.[name] AS [index_name] ,
        ddius.[user_seeks] + ddius.[user_scans] + ddius.[user_lookups]
            AS [user_reads] ,
        ddius.[user_updates] AS [user_writes] ,
        SUM(SP.rows) AS [total_rows]
FROM    sys.dm_db_index_usage_stats ddius
        INNER JOIN sys.indexes i ON ddius.[object_id] = i.[object_id]
                                     AND i.[index_id] = ddius.[index_id]
        INNER JOIN sys.partitions SP ON ddius.[object_id] = SP.[object_id]
                                        AND SP.[index_id] = ddius.[index_id]
        INNER JOIN sys.objects o ON ddius.[object_id] = o.[object_id]
        INNER JOIN sys.sysusers su ON o.[schema_id] = su.[UID]
WHERE   ddius.[database_id] = DB_ID() -- current database only
        AND OBJECTPROPERTY(ddius.[object_id], 'IsUserTable') = 1
        AND ddius.[index_id] > 0
GROUP BY su.[name] ,
        o.[name] ,
        i.[name] ,
        ddius.[user_seeks] + ddius.[user_scans] + ddius.[user_lookups] ,
        ddius.[user_updates]
HAVING  ddius.[user_seeks] + ddius.[user_scans] + ddius.[user_lookups] = 0
ORDER BY ddius.[user_updates] DESC ,
        su.[name] ,
        o.[name] ,
        i.[name ]

-- Listing 5.6: How old are the index usage stats?
SELECT  DATEDIFF(DAY, sd.crdate, GETDATE()) AS days_history
FROM    sys.sysdatabases sd
WHERE   sd.[name] = 'tempdb' ;

-- Listing 5.7: Finding rarely used indexes.
-- Potentially inefficent non-clustered indexes (writes > reads)
SELECT  OBJECT_NAME(ddius.[object_id]) AS [Table Name] ,
        i.name AS [Index Name] ,
        i.index_id ,
        user_updates AS [Total Writes] ,
        user_seeks + user_scans + user_lookups AS [Total Reads] ,
        user_updates - ( user_seeks + user_scans + user_lookups )
            AS [Difference]
FROM    sys.dm_db_index_usage_stats AS ddius WITH ( NOLOCK )
        INNER JOIN sys.indexes AS i WITH ( NOLOCK )
            ON ddius.[object_id] = i.[object_id]
            AND i.index_id = ddius.index_id
WHERE   OBJECTPROPERTY(ddius.[object_id], 'IsUserTable') = 1
        AND ddius.database_id = DB_ID()
        AND user_updates > ( user_seeks + user_scans + user_lookups )
        AND i.index_id > 1
ORDER BY [Difference] DESC ,
        [Total Writes] DESC ,
        [Total Reads] ASC ;

-- Listing 5.8: Detailed write information for unused indexes.
SELECT  '[' + DB_NAME() + '].[' + su.[name] + '].[' + o.[name] + ']'
                                                       AS [statement] ,
        i.[name] AS [index_name] ,
        ddius.[user_seeks] + ddius.[user_scans] + ddius.[user_lookups]
            AS [user_reads] ,
        ddius.[user_updates] AS [user_writes] ,
        ddios.[leaf_insert_count] ,
        ddios.[leaf_delete_count] ,
        ddios.[leaf_update_count] ,
        ddios.[nonleaf_insert_count] ,
        ddios.[nonleaf_delete_count] ,
        ddios.[nonleaf_update_count]
FROM    sys.dm_db_index_usage_stats ddius
        INNER JOIN sys.indexes i ON ddius.[object_id] = i.[object_id]
                                     AND i.[index_id] = ddius.[index_id]
        INNER JOIN sys.partitions SP ON ddius.[object_id] = SP.[object_id]
                                        AND SP.[index_id] = ddius.[index_id]
        INNER JOIN sys.objects o ON ddius.[object_id] = o.[object_id]
        INNER JOIN sys.sysusers su ON o.[schema_id] = su.[UID]
        INNER JOIN sys.[dm_db_index_operational_stats](DB_ID(), NULL, NULL,
                                                       NULL)
                  AS ddios
                      ON ddius.[index_id] = ddios.[index_id]
                         AND ddius.[object_id] = ddios.[object_id]
                         AND SP.[partition_number] = ddios.[partition_number]
                         AND ddius.[database_id] = ddios.[database_id]
WHERE OBJECTPROPERTY(ddius.[object_id], 'IsUserTable') = 1
      AND ddius.[index_id] > 0
      AND ddius.[user_seeks] + ddius.[user_scans] + ddius.[user_lookups] = 0
ORDER BY ddius.[user_updates] DESC ,
        su.[name] ,
        o.[name] ,
        i.[name ]

-- Listing 5.9: Retrieving locking and blocking details for each index.
SELECT  '[' + DB_NAME(ddios.[database_id]) + '].[' + su.[name] + '].['
        + o.[name] + ']' AS [statement] ,
        i.[name] AS 'index_name' ,
        ddios.[partition_number] ,
        ddios.[row_lock_count] ,
        ddios.[row_lock_wait_count] ,
        CAST (100.0 * ddios.[row_lock_wait_count]
        / ( ddios.[row_lock_count] ) AS DECIMAL(5, 2)) AS [%_times_blocked] ,
        ddios.[row_lock_wait_in_ms] ,
        CAST (1.0 * ddios.[row_lock_wait_in_ms]
        / ddios.[row_lock_wait_count] AS DECIMAL(15, 2))
             AS [avg_row_lock_wait_in_ms]
FROM    sys.dm_db_index_operational_stats(DB_ID(), NULL, NULL, NULL) ddios
        INNER JOIN sys.indexes i ON ddios.[object_id] = i.[object_id]
                                     AND i.[index_id] = ddios.[index_id]
        INNER JOIN sys.objects o ON ddios.[object_id] = o.[object_id]
        INNER JOIN sys.sysusers su ON o.[schema_id] = su.[UID]
WHERE   ddios.row_lock_wait_count > 0
        AND OBJECTPROPERTY(ddios.[object_id], 'IsUserTable') = 1
        AND i.[index_id] > 0
ORDER BY ddios.[row_lock_wait_count] DESC ,
        su.[name] ,
        o.[name] ,
        i.[name ]

-- Listing 5.10: Investigating latch waits.
SELECT  '[' + DB_NAME() + '].[' + OBJECT_SCHEMA_NAME(ddios.[object_id])
        + '].[' + OBJECT_NAME(ddios.[object_id]) + ']' AS [object_name] ,
        i.[name] AS index_name ,
        ddios.page_io_latch_wait_count ,
        ddios.page_io_latch_wait_in_ms ,
        ( ddios.page_io_latch_wait_in_ms / ddios.page_io_latch_wait_count )
                                             AS avg_page_io_latch_wait_in_ms
FROM    sys.dm_db_index_operational_stats(DB_ID(), NULL, NULL, NULL) ddios
        INNER JOIN sys.indexes i ON ddios.[object_id] = i.[object_id]
                                    AND i.index_id = ddios.index_id
WHERE   ddios.page_io_latch_wait_count > 0
        AND OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
ORDER BY ddios.page_io_latch_wait_count DESC ,
        avg_page_io_latch_wait_in_ms DESC 

-- Listing 5.11: Investigating lock escalation.
SELECT  OBJECT_NAME(ddios.[object_id], ddios.database_id) AS [object_name] ,
        i.name AS index_name ,
        ddios.index_id ,
        ddios.partition_number ,
        ddios.index_lock_promotion_attempt_count ,
        ddios.index_lock_promotion_count ,
        ( ddios.index_lock_promotion_attempt_count
          / ddios.index_lock_promotion_count ) AS percent_success
FROM    sys.dm_db_index_operational_stats(DB_ID(), NULL, NULL, NULL) ddios
        INNER JOIN sys.indexes i ON ddios.object_id = i.object_id
                                    AND ddios.index_id = i.index_id
WHERE   ddios.index_lock_promotion_count > 0
ORDER BY index_lock_promotion_count DESC ;

-- Listing 5.12: Indexes associated with lock contention.
SELECT  OBJECT_NAME(ddios.object_id, ddios.database_id) AS object_name ,
        i.name AS index_name ,
        ddios.index_id ,
        ddios.partition_number ,
        ddios.page_lock_wait_count ,
        ddios.page_lock_wait_in_ms ,
        CASE WHEN DDMID.database_id IS NULL THEN 'N'
             ELSE 'Y'
        END AS missing_index_identified
FROM    sys.dm_db_index_operational_stats(DB_ID(), NULL, NULL, NULL) ddios
        INNER JOIN sys.indexes i ON ddios.object_id = i.object_id
                                    AND ddios.index_id = i.index_id
        LEFT OUTER JOIN ( SELECT DISTINCT
                                    database_id ,
                                    object_id
                          FROM      sys.dm_db_missing_index_details
                        ) AS DDMID ON DDMID.database_id = ddios.database_id
                                      AND DDMID.object_id = ddios.object_id
WHERE   ddios.page_lock_wait_in_ms > 0
ORDER BY ddios.page_lock_wait_count DESC ;
-- Listing 5.13: Finding beneficial missing indexes.
SELECT  user_seeks * avg_total_user_cost * ( avg_user_impact * 0.01 ) AS [index_advantage] ,
        dbmigs.last_user_seek ,
        dbmid.[statement] AS [Database.Schema.Table] ,
        dbmid.equality_columns ,
        dbmid.inequality_columns ,
        dbmid.included_columns ,
        dbmigs.unique_compiles ,
        dbmigs.user_seeks ,
        dbmigs.avg_total_user_cost ,
        dbmigs.avg_user_impact
FROM    sys.dm_db_missing_index_group_stats AS dbmigs WITH ( NOLOCK )
        INNER JOIN sys.dm_db_missing_index_groups AS dbmig WITH ( NOLOCK )
                    ON dbmigs.group_handle = dbmig.index_group_handle
        INNER JOIN sys.dm_db_missing_index_details AS dbmid WITH ( NOLOCK )
                    ON dbmig.index_handle = dbmid.index_handle
WHERE   dbmid.[database_id] = DB_ID()
ORDER BY index_advantage DESC ;

-- Listing 5.14: Investigating fragmented indexes.
SELECT  '[' + DB_NAME() + '].[' + OBJECT_SCHEMA_NAME(ddips.[object_id],
                                                     DB_ID()) + '].['
        + OBJECT_NAME(ddips.[object_id], DB_ID()) + ']' AS [statement] ,
        i.[name] AS [index_name] ,
        ddips.[index_type_desc] ,
        ddips.[partition_number] ,
        ddips.[alloc_unit_type_desc] ,
        ddips.[index_depth] ,
        ddips.[index_level] ,
        CAST(ddips.[avg_fragmentation_in_percent] AS SMALLINT)
            AS [avg_frag_%] ,
        CAST(ddips.[avg_fragment_size_in_pages] AS SMALLINT)
            AS [avg_frag_size_in_pages] ,
        ddips.[fragment_count] ,
        ddips.[page_count]
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL,
                                         NULL, NULL, 'limited') ddips
        INNER JOIN sys.[indexes] i ON ddips.[object_id] = i.[object_id]
                                       AND ddips.[index_id] = i.[index_id]
WHERE   ddips.[avg_fragmentation_in_percent] > 15
        AND ddips.[page_count] > 500
ORDER BY ddips.[avg_fragmentation_in_percent] ,
        OBJECT_NAME(ddips.[object_id], DB_ID()) ,
        i.[name ]

/*-----------------------------------------------------*/
/* CHAPTER 6: PHYSICAL DISK STATISTICS AND UTILIZATION */
/*-----------------------------------------------------*/

-- Listing 6.1: Number of rows in clustered tables and heaps.
SELECT  object_schema_name(ddps.object_id) + 
                '.' + OBJECT_NAME(ddps.object_id) AS name ,
        SUM(ddps.row_count) AS row_count
FROM    sys.dm_db_partition_stats AS ddps
        JOIN sys.indexes ON indexes.object_id = ddps.object_id
                            AND indexes.index_id = ddps.index_id
WHERE   indexes.type_desc IN ( 'CLUSTERED', 'HEAP' )
  and   objectproperty(ddps.object_id,'IsMSShipped') = 0
GROUP   BY ddps.object_id 

-- Listing 6.2: Creating a three-partition salesOrder table.
CREATE PARTITION FUNCTION PFdateRange (SMALLDATETIME)
AS RANGE LEFT FOR VALUES ('20020101','20030101') ;
GO
CREATE PARTITION SCHEME PSdateRange
AS PARTITION PFdateRange ALL TO ( [PRIMARY] )
GO

CREATE TABLE salesOrder
    (
      salesOrderId INT ,
      customerId INT ,
      orderAmount DECIMAL(10, 2) ,
      orderDate SMALLDATETIME ,
      CONSTRAINT PKsalesOrder PRIMARY KEY NONCLUSTERED ( salesOrderId )
        ON [Primary] ,
      CONSTRAINT AKsalesOrder UNIQUE CLUSTERED ( salesOrderId, orderDate )
    )
--the ON clause causes this clustered table to be partitioned by orderDate 
--using the partition function/scheme
ON  PSdateRange(orderDate)
GO
--Generate some random data
INSERT  INTO salesOrder
        SELECT  SalesOrderId ,
                CustomerId ,
                TotalDue ,
                OrderDate
        FROM    AdventureWorks.Sales.SalesOrderHeader

-- Listing 6.3: Number of rows in each object, per partition.
SELECT  indexes.name ,
        indexes.type_desc ,
        dps.row_count AS row_count ,
        partition_id
FROM    sys.dm_db_partition_stats AS dps
        JOIN sys.indexes ON indexes.object_id = dps.object_id
                            AND indexes.index_id = dps.index_id
WHERE   OBJECT_ID('salesOrder') = dps.object_id

-- Listing 6.4: Physical characteristics of each partition.
SELECT  OBJECT_NAME(indexes.object_id) AS Object_Name ,
        ddps.index_id AS Index_ID ,
        ddps.partition_number ,
        ddps.row_count ,
        ddps.used_page_count ,
        ddps.in_row_reserved_page_count ,
        ddps.lob_reserved_page_count ,
        CASE pf.boundary_value_on_right
          WHEN 1 THEN 'less than'
          ELSE 'less than or equal to'
        END AS comparison ,
        value
FROM    sys.dm_db_partition_stats ddps
        JOIN sys.indexes ON ddps.object_id = indexes.object_id
                            AND ddps.index_id = indexes.index_id
        JOIN sys.partition_schemes ps
                  ON ps.data_space_id = indexes.data_space_id
        JOIN sys.partition_functions pf ON pf.function_id = ps.function_id
        LEFT OUTER JOIN sys.partition_range_values prv
                  ON pf.function_id = prv.function_id
                     AND ddps.partition_number = prv.boundary_id
WHERE   OBJECT_NAME(ddps.object_id) = 'salesOrder '
        AND ddps.index_id IN ( 0, 1 ) --CLUSTERED table or HEAP

-- Listing 6.5: The testClusteredIdentity clustered table, with an IDENTITY clustering key.
CREATE TABLE testClusteredIdentity
    (
      testClusteredId INT
        IDENTITY
        CONSTRAINT PKtestClusteredIdentity PRIMARY KEY CLUSTERED ,
      value VARCHAR(1000)
    )
GO

INSERT INTO testClusteredIdentity(value)
SELECT replicate('a',1000) --only allows 8 rows per page.
GO 100

-- Listing 6.6: Fragmentation statistics for the testClusteredIdentity clustered table.
SELECT  avg_fragmentation_in_percent AS avgFragPct ,
        fragment_count AS fragCount ,
        avg_fragment_size_in_pages AS avgFragSize
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED')
WHERE   index_type_desc = 'CLUSTERED INDEX'
        AND index_level = 0 -- the other levels are the index pages
        AND OBJECT_NAME(object_id) = 'testClusteredIdentity'

-- Listing 6.7: The testClustered clustered table, with a GUID clustering key.
CREATE TABLE testClustered
    (
      testClusteredId UNIQUEIDENTIFIER
        CONSTRAINT PKtestClustered PRIMARY KEY CLUSTERED ,
      value VARCHAR(1000)
    )

INSERT INTO testClustered
SELECT NEWID(), replicate('a',1000)
GO 100

-- Listing 6.8: The testHeap heap structure.
CREATE TABLE testHeap
    (
      testHeapId UNIQUEIDENTIFIER
        CONSTRAINT PKtestHeap PRIMARY KEY NONCLUSTERED ,
      value VARCHAR(100)
    )

INSERT INTO testHeap
SELECT NEWID(),'a'
GO 100

-- Listing 6.9: Fragmentation statistics for testHeap.
SELECT  avg_fragmentation_in_percent AS avgFragPct ,
        fragment_count AS fragCount ,
        avg_fragment_size_in_pages AS avgFragSize ,
        forwarded_record_count AS forwardPointers
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED')
WHERE   index_type_desc = 'HEAP'
        AND index_level = 0 -- the other levels are the index pages
        AND OBJECT_NAME(object_id) = 'testHeap'

-- Listing 6.10: Updating the value column in testHeap with bigger values.
UPDATE testHeap
SET    value = REPLICATE('a',100)

-- Listing 6.11: Capturing I/O statistics when reading the testheap table.
SET STATISTICS I/O ON
SELECT  *
FROM    testHeap
SET STATISTICS I/O OFF

-- Listing 6.12: Rebuilding a heap to remove fragmentation (SQL 2008 only).
ALTER TABLE testHeap REBUILD

-- Listing 6.13: Capturing baseline disk I/O statistics from sys.dm_io_virtual_file_stats in a temporary table.
SELECT  DB_NAME(mf.database_id) AS databaseName ,
        mf.physical_name ,
        divfs.num_of_reads ,
        divfs.num_of_bytes_read ,
        divfs.io_stall_read_ms ,
        divfs.num_of_writes ,
        divfs.num_of_bytes_written ,
        divfs.io_stall_write_ms ,
        divfs.io_stall ,
        size_on_disk_bytes ,
        GETDATE() AS baselineDate
INTO    #baseline
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
        JOIN sys.master_files AS mf ON mf.database_id = divfs.database_id
                                       AND mf.file_id = divfs.file_id

-- Listing 6.14: Querying the #baseline temporary table.
SELECT  physical_name ,
        num_of_reads ,
        num_of_bytes_read ,
        io_stall_read_ms
FROM    #baseline
WHERE   databaseName = 'DatabaseName'

-- Listing 6.15: Capturing 10 seconds of disk I/O statistics, since the baseline measurement.
WITH  currentLine
        AS ( SELECT   DB_NAME(mf.database_id) AS databaseName ,
                        mf.physical_name ,
                        num_of_reads ,
                        num_of_bytes_read ,
                        io_stall_read_ms ,
                        num_of_writes ,
                        num_of_bytes_written ,
                        io_stall_write_ms ,
                        io_stall ,
                        size_on_disk_bytes ,
                        GETDATE() AS currentlineDate
             FROM     sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
                        JOIN sys.master_files AS mf
                          ON mf.database_id = divfs.database_id
                             AND mf.file_id = divfs.file_id
             )
  SELECT  currentLine.databaseName ,
        LEFT(currentLine.physical_name, 1) AS drive ,
        currentLine.physical_name ,
        DATEDIFF(millisecond,baseLineDate,currentLineDate) AS elapsed_ms,
        currentLine.io_stall - #baseline.io_stall AS io_stall_ms ,
        currentLine.io_stall_read_ms - #baseline.io_stall_read_ms
                                                      AS io_stall_read_ms ,
        currentLine.io_stall_write_ms - #baseline.io_stall_write_ms
                                                      AS io_stall_write_ms ,
        currentLine.num_of_reads - #baseline.num_of_reads AS num_of_reads ,
        currentLine.num_of_bytes_read - #baseline.num_of_bytes_read
                                                      AS num_of_bytes_read ,
        currentLine.num_of_writes - #baseline.num_of_writes AS num_of_writes ,
        currentLine.num_of_bytes_written - #baseline.num_of_bytes_written
                                                      AS num_of_bytes_written
  FROM  currentLine
      INNER JOIN #baseline ON #baseLine.databaseName = currentLine.databaseName
        AND #baseLine.physical_name = currentLine.physical_name 
  WHERE #baseline.databaseName = 'DatabaseName'   

-- Listing 6.16: Returning pending I/O requests.
SELECT  mf.physical_name ,
        dipir.io_pending ,
        dipir.io_pending_ms_ticks
FROM    sys.dm_io_pending_io_requests AS dipir
        JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
                                    ON dipir.io_handle = divfs.file_handle
        JOIN sys.master_files AS mf ON divfs.database_id = mf.database_id
                                       AND divfs.file_id = mf.file_id
ORDER BY dipir.io_pending , --Show I/O completed by the OS first 
        dipir.io_pending_ms_ticks DESC  

-- Listing 6.17: The read/write ratio, by database, for amount of data transferred.
--uses a LIKE comparison to only include desired databases, rather than
--using the database_id parameter of sys.dm_io_virtual_file_stats
--if you have a rather large number of databases, this may not be the 
--optimal way to execute the query, but this gives you flexibility
--to look at multiple databases simultaneously.
DECLARE @databaseName SYSNAME
SET @databaseName = '%'
 --'%' gives all databases

SELECT  CAST(SUM(num_of_bytes_read) AS DECIMAL)
        / ( CAST(SUM(num_of_bytes_written) AS DECIMAL)
            + CAST(SUM(num_of_bytes_read) AS DECIMAL) ) AS RatioOfReads ,
        CAST(SUM(num_of_bytes_written) AS DECIMAL)
        / ( CAST(SUM(num_of_bytes_written) AS DECIMAL)
            + CAST(SUM(num_of_bytes_read) AS DECIMAL) ) AS RatioOfWrites ,
        SUM(num_of_bytes_read) AS TotalBytesRead ,
        SUM(num_of_bytes_written) AS TotalBytesWritten
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
WHERE   DB_NAME(database_id) LIKE @databaseName  

-- Listing 6.18: The read/write ratio, by drive, for amount of data transferred.
DECLARE @databaseName SYSNAME
SET @databaseName = '%'
 --'%' gives all databases

SELECT  LEFT(physical_name, 1) AS drive ,
        CAST(SUM(num_of_bytes_read) AS DECIMAL)
        / ( CAST(SUM(num_of_bytes_written) AS DECIMAL)
            + CAST(SUM(num_of_bytes_read) AS DECIMAL) ) AS RatioOfReads ,
        CAST(SUM(num_of_bytes_written) AS DECIMAL)
        / ( CAST(SUM(num_of_bytes_written) AS DECIMAL)
            + CAST(SUM(num_of_bytes_read) AS DECIMAL) ) AS RatioOfWrites ,
        SUM(num_of_bytes_read) AS TotalBytesRead ,
        SUM(num_of_bytes_written) AS TotalBytesWritten
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
        JOIN sys.master_files AS mf ON mf.database_id = divfs.database_id
                                       AND mf.file_id = divfs.file_id
WHERE   DB_NAME(divfs.database_id) LIKE @databaseName
GROUP BY LEFT(mf.physical_name, 1)

-- Listing 6.19: The read/write ratio, by database, for number of read/write operations.
DECLARE @databaseName SYSNAME
SET @databaseName = 'BusyDatabase'
 --obviously not the real name
 --'%' gives all databases

SELECT  CAST(SUM(num_of_reads) AS DECIMAL)
        / ( CAST(SUM(num_of_writes) AS DECIMAL)
            + CAST(SUM(num_of_reads) AS DECIMAL) ) AS RatioOfReads ,
        CAST(SUM(num_of_writes) AS DECIMAL)
        / ( CAST(SUM(num_of_reads) AS DECIMAL)
            + CAST(SUM(num_of_writes) AS DECIMAL) ) AS RatioOfWrites ,
        SUM(num_of_reads) AS TotalReadOperations ,
        SUM(num_of_writes) AS TotalWriteOperations
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
WHERE   DB_NAME(database_id) LIKE @databaseName

-- Listing 6.20: Read/write ratio for all objects in a given database.
DECLARE @databaseName SYSNAME
SET @databaseName = 'BusyDatabase' --obviously not the real name
 --'%' gives all databases

SELECT  CASE 
        WHEN ( SUM(user_updates + user_seeks + user_scans + user_lookups) = 0 )
             THEN NULL
             ELSE ( CAST(SUM(user_seeks + user_scans + user_lookups)
                                                               AS DECIMAL)
                    / CAST(SUM(user_updates + user_seeks + user_scans
                               + user_lookups) AS DECIMAL) )
        END AS RatioOfReads ,
        CASE 
        WHEN ( SUM(user_updates + user_seeks + user_scans + user_lookups) = 0 )
             THEN NULL
             ELSE ( CAST(SUM(user_updates) AS DECIMAL)
                    / CAST(SUM(user_updates + user_seeks + user_scans
                               + user_lookups) AS DECIMAL) )
        END AS RatioOfWrites ,
        SUM(user_updates + user_seeks + user_scans + user_lookups)
                                                      AS TotalReadOperations ,
        SUM(user_updates) AS TotalWriteOperations
FROM    sys.dm_db_index_usage_stats AS ddius
WHERE   DB_NAME(database_id) LIKE @databaseName 

-- Listing 6.21: Read/write ratio per object.
--only works in the context of the database due to sys.indexes usage
USE BusyDatabase
 --obviously not the real name

SELECT  OBJECT_NAME(ddius.object_id) AS object_name ,
       CASE
        WHEN ( SUM(user_updates + user_seeks + user_scans + user_lookups) = 0 )
        THEN NULL
        ELSE ( CAST(SUM(user_seeks + user_scans + user_lookups) AS DECIMAL)
                    / CAST(SUM(user_updates + user_seeks + user_scans
                               + user_lookups) AS DECIMAL) )
        END AS RatioOfReads ,
       CASE 
        WHEN ( SUM(user_updates + user_seeks + user_scans + user_lookups) = 0 )
        THEN NULL
        ELSE ( CAST(SUM(user_updates) AS DECIMAL)
                    / CAST(SUM(user_updates + user_seeks + user_scans
                               + user_lookups) AS DECIMAL) )
        END AS RatioOfWrites ,
        SUM(user_updates + user_seeks + user_scans + user_lookups)
                                                  AS TotalReadOperations ,
        SUM(user_updates) AS TotalWriteOperations
FROM    sys.dm_db_index_usage_stats AS ddius
        JOIN sys.indexes AS i ON ddius.object_id = i.object_id
                                 AND ddius.index_id = i.index_id
WHERE   i.type_desc IN ( 'CLUSTERED', 'HEAP' ) --only works in Current db
GROUP BY ddius.object_id
ORDER BY OBJECT_NAME(ddius.object_id)

-- Listing 6.22: An overview of tempdb utilization.
SELECT  mf.physical_name ,
        mf.size AS entire_file_page_count ,
        dfsu.version_store_reserved_page_count ,
        dfsu.unallocated_extent_page_count ,
        dfsu.user_object_reserved_page_count ,
        dfsu.internal_object_reserved_page_count ,
        dfsu.mixed_extent_page_count
FROM    sys.dm_db_file_space_usage dfsu
        JOIN sys.master_files AS mf ON mf.database_id = dfsu.database_id
                                       AND mf.file_id = dfsu.file_id 

-- Listing 6.23: tempdb file size and version store usage.
SELECT  SUM(mf.size) AS entire_page_count ,
        SUM(dfsu.version_store_reserved_page_count) AS version_store_reserved_page_count
FROM    sys.dm_db_file_space_usage dfsu
        JOIN sys.master_files AS mf ON mf.database_id = dfsu.database_id
                                       AND mf.file_id = dfsu.file_id 


/*-----------------------------------------------*/
/* CHAPTER 7: OS AND HARDWARE INTERACTION        */
/*-----------------------------------------------*/

-- Listing 7.1: Resetting the wait statistics.
DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR);

-- Listing 7.2: The most common waits.
SELECT TOP 3
        wait_type ,
        waiting_tasks_count ,
        wait_time_ms / 1000.0 AS wait_time_sec ,
        CASE WHEN waiting_tasks_count = 0 THEN NULL
             ELSE wait_time_ms / 1000.0 / waiting_tasks_count
        END AS avg_wait_time_sec ,
        max_wait_time_ms / 1000.0 AS max_wait_time_sec ,
        ( wait_time_ms - signal_wait_time_ms ) / 1000.0 AS resource_wait_time_sec
FROM    sys.dm_os_wait_stats
WHERE   wait_type NOT IN --tasks that are actually good or expected
                         --to be waited on
( 'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK',
  'SLEEP_SYSTEMTASK', 'WAITFOR' )
ORDER BY waiting_tasks_count DESC

-- Listing 7.3: Report on top resource waits.
-- Isolate top waits for server instance since last restart 
-- or statistics clear
WITH    Waits
          AS ( SELECT   wait_type ,
                        wait_time_ms / 1000. AS wait_time_sec ,
                        100. * wait_time_ms / SUM(wait_time_ms) OVER ( ) AS pct ,
                        ROW_NUMBER() OVER ( ORDER BY wait_time_ms DESC ) AS rn
               FROM     sys.dm_os_wait_stats
               WHERE    wait_type NOT IN ( 'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP',
                                           'RESOURCE_QUEUE', 'SLEEP_TASK',
                                           'SLEEP_SYSTEMTASK',
                                           'SQLTRACE_BUFFER_FLUSH', 'WAITFOR',
                                           'LOGMGR_QUEUE', 'CHECKPOINT_QUEUE' )
             )
    SELECT  wait_type ,
            CAST(wait_time_sec AS DECIMAL(12, 2)) AS wait_time_sec ,
            CAST(pct AS DECIMAL(12, 2)) AS wait_time_percentage
    FROM    Waits
    WHERE   pct > 1
    ORDER BY wait_time_sec DESC

-- Listing 7.4: Seeking out locking waits.
SELECT  wait_type ,
        waiting_tasks_count ,
        wait_time_ms ,
        max_wait_time_ms
FROM    sys.dm_os_wait_stats
WHERE   wait_type LIKE 'LCK%'
        AND Waiting_tasks_count > 0
ORDER BY waiting_tasks_count DESC

-- Listing 7.5: Is there any CPU pressure?
-- Total waits are wait_time_ms (high signal waits indicates CPU pressure)
SELECT  CAST(100.0 * SUM(signal_wait_time_ms) / SUM(wait_time_ms)
                              AS NUMERIC(20,2)) AS [%signal (cpu) waits] ,
        CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms)
        / SUM(wait_time_ms) AS NUMERIC(20, 2)) AS [%resource waits]
FROM    sys.dm_os_wait_stats ;

-- Listing 7.6: Returning a list of PerfMon counter types.
SELECT DISTINCT
        cntr_type
FROM    sys.dm_os_performance_counters
ORDER BY cntr_type

cntr_type
-----------
65792
272696576
537003264
1073874176
1073939712

-- Listing 7.7: Returning the values of directly usable PerfMon counters.
DECLARE @PERF_COUNTER_LARGE_RAWCOUNT INT 
SELECT  @PERF_COUNTER_LARGE_RAWCOUNT = 65792

SELECT  object_name ,
        counter_name ,
        instance_name ,
        cntr_value
FROM    sys.dm_os_performance_counters
WHERE   cntr_type = @PERF_COUNTER_LARGE_RAWCOUNT
ORDER BY object_name ,
        counter_name ,
        instance_name

-- Listing 7.8: Monitoring changes in the size of the transaction log.
--the default instance reports as SQLServer, but other 
--instances as MSSQL$InstanceName
DECLARE @object_name SYSNAME
SET @object_name = CASE WHEN @@servicename = 'MSSQLSERVER' THEN 'SQLServer'
                        ELSE 'MSSQL$' + @@serviceName
                   END + ':Databases'

DECLARE @PERF_COUNTER_LARGE_RAWCOUNT INT 
SELECT  @PERF_COUNTER_LARGE_RAWCOUNT = 65792

SELECT  object_name ,
        counter_name ,
        instance_name ,
        cntr_value
FROM    sys.dm_os_performance_counters
WHERE   cntr_type = @PERF_COUNTER_LARGE_RAWCOUNT
        AND object_name = @object_name
        AND counter_name IN ( 'Log Growths', 'Log Shrinks' )
        AND cntr_value > 0
ORDER BY object_name ,
        counter_name ,
        instance_name

-- Listing 7.9: Which deprecated features are still in use?
DECLARE @object_name SYSNAME
SET @object_name = CASE WHEN @@servicename = 'MSSQLSERVER' THEN 'SQLServer'
                        ELSE 'MSSQL$' + @@serviceName
                   END + ':Deprecated Features'
DECLARE @PERF_COUNTER_LARGE_RAWCOUNT INT 
SELECT  @PERF_COUNTER_LARGE_RAWCOUNT = 65792

SELECT  object_name ,
        counter_name ,
        instance_name ,
        cntr_value
FROM    sys.dm_os_performance_counters
WHERE   cntr_type = @PERF_COUNTER_LARGE_RAWCOUNT
        AND object_name = @object_name
        AND cntr_value > 0

-- Listing 7.10: Returning the values of ratio PerfMon counters.
DECLARE @PERF_LARGE_RAW_FRACTION INT ,
    @PERF_LARGE_RAW_BASE INT 
SELECT  @PERF_LARGE_RAW_FRACTION = 537003264 ,
        @PERF_LARGE_RAW_BASE = 1073939712 

SELECT  dopc_fraction.object_name ,
        dopc_fraction.instance_name ,
        dopc_fraction.counter_name ,
         --when divisor is 0, return I return NULL to indicate
         --divide by 0/no values captured
        CAST(dopc_fraction.cntr_value AS FLOAT)
        / CAST(CASE dopc_base.cntr_value
                 WHEN 0 THEN NULL
                 ELSE dopc_base.cntr_value
               END AS FLOAT) AS cntr_value
FROM    sys.dm_os_performance_counters AS dopc_base
        JOIN sys.dm_os_performance_counters AS dopc_fraction
            ON dopc_base.cntr_type = @PERF_LARGE_RAW_BASE
               AND dopc_fraction.cntr_type = @PERF_LARGE_RAW_FRACTION
               AND dopc_base.object_name = dopc_fraction.object_name
               AND dopc_base.instance_name = dopc_fraction.instance_name
               AND ( REPLACE(dopc_base.counter_name,
                'base', '') = dopc_fraction.counter_name
              --Worktables From Cache has "odd" name where 
              --Ratio was left off
               OR REPLACE(dopc_base.counter_name,
               'base', '') = ( REPLACE(dopc_fraction.counter_name,
               'ratio', '') )
               )
ORDER BY dopc_fraction.object_name ,
         dopc_fraction.instance_name ,
         dopc_fraction.counter_name

-- Listing 7.11: Returning the current value for the buffer cache hit ratio.
DECLARE @object_name SYSNAME
SET @object_name = CASE WHEN @@servicename = 'MSSQLSERVER' THEN 'SQLServer'
                        ELSE 'MSSQL$' + @@serviceName
                   END + ':Buffer Manager'
DECLARE
    @PERF_LARGE_RAW_FRACTION INT ,
    @PERF_LARGE_RAW_BASE INT 
SELECT  @PERF_LARGE_RAW_FRACTION = 537003264 ,
        @PERF_LARGE_RAW_BASE = 1073939712 

SELECT  dopc_fraction.object_name ,
        dopc_fraction.instance_name ,
        dopc_fraction.counter_name ,
     --when divisor is 0, return I return NULL to indicate
     --divide by 0/no values captured
        CAST(dopc_fraction.cntr_value AS FLOAT)
        / CAST(CASE dopc_base.cntr_value
                 WHEN 0 THEN NULL
                 ELSE dopc_base.cntr_value
               END AS FLOAT) AS cntr_value
FROM    sys.dm_os_performance_counters AS dopc_base
        JOIN sys.dm_os_performance_counters AS dopc_fraction
            ON dopc_base.cntr_type = @PERF_LARGE_RAW_BASE
               AND dopc_fraction.cntr_type = @PERF_LARGE_RAW_FRACTION
               AND dopc_base.object_name = dopc_fraction.object_name
               AND dopc_base.instance_name = dopc_fraction.instance_name
               AND ( REPLACE(dopc_base.counter_name,
                'base', '') = dopc_fraction.counter_name
      --Worktables From Cache has "odd" name where 
      --Ratio was left off
               OR REPLACE(dopc_base.counter_name,
                'base', '') = ( REPLACE(dopc_fraction.counter_name,
                'ratio', '') )
                )
WHERE   dopc_fraction.object_name = @object_name
        AND dopc_fraction.instance_name = ''
        AND dopc_fraction.counter_name = 'Buffer cache hit ratio'
ORDER BY dopc_fraction.object_name ,
        dopc_fraction.instance_name ,
        dopc_fraction.counter_name

-- Listing 7.12: Returning the values of "per second average" PerfMon counters.
DECLARE @PERF_COUNTER_BULK_COUNT INT  
SELECT  @PERF_COUNTER_BULK_COUNT = 272696576 

--Holds initial state
DECLARE @baseline TABLE
    (
      object_name NVARCHAR(256) ,
      counter_name NVARCHAR(256) ,
      instance_name NVARCHAR(256) ,
      cntr_value BIGINT ,
      cntr_type INT ,
      time DATETIME DEFAULT ( GETDATE() )
    )

DECLARE @current TABLE
    (
      object_name NVARCHAR(256) ,
      counter_name NVARCHAR(256) ,
      instance_name NVARCHAR(256) ,
      cntr_value BIGINT ,
      cntr_type INT ,
      time DATETIME DEFAULT ( GETDATE() )
    )

--capture the initial state of bulk counters
INSERT  INTO @baseline
        ( object_name ,
          counter_name ,
          instance_name ,
          cntr_value ,
          cntr_type
        )
        SELECT  object_name ,
                counter_name ,
                instance_name ,
                cntr_value ,
                cntr_type
        FROM    sys.dm_os_performance_counters AS dopc
        WHERE   cntr_type = @PERF_COUNTER_BULK_COUNT

WAITFOR DELAY '00:00:05' --the code will work regardless of delay chosen

--get the followon state of the counters
INSERT  INTO @current
        ( object_name ,
          counter_name ,
          instance_name ,
          cntr_value ,
          cntr_type
        )
        SELECT  object_name ,
                counter_name ,
                instance_name ,
                cntr_value ,
                cntr_type
        FROM    sys.dm_os_performance_counters AS dopc
        WHERE   cntr_type = @PERF_COUNTER_BULK_COUNT

SELECT  dopc.object_name ,
        dopc.instance_name ,
        dopc.counter_name ,
        --ms to second conversion factor
        1000 *
        --current value less the previous value
       ( ( dopc.cntr_value - prev_dopc.cntr_value )
           --divided by the number of milliseconds that pass 
           --casted as float to get fractional results. Float
           --lets really big or really small numbers to work
          / CAST(DATEDIFF(ms, prev_dopc.time, dopc.time) AS FLOAT) )
                                                       AS cntr_value
       --simply join on the names of the counters
FROM    @current AS dopc
        JOIN @baseline AS prev_dopc ON prev_dopc.object_name = dopc.object_name
                             AND prev_dopc.instance_name = dopc.instance_name
                             AND prev_dopc.counter_name = dopc.counter_name
WHERE   dopc.cntr_type = @PERF_COUNTER_BULK_COUNT
        AND 1000 * ( ( dopc.cntr_value - prev_dopc.cntr_value )
                     / CAST(DATEDIFF(ms, prev_dopc.time, dopc.time) AS FLOAT) )
/*  default to only showing non-zero values */ <> 0
ORDER BY dopc.object_name ,
        dopc.instance_name ,
        dopc.counter_name

-- Listing 7.13: Returning the values for the "average number of operations" PerfMon counters.
DECLARE @PERF_AVERAGE_BULK INT ,
    @PERF_LARGE_RAW_BASE INT 

SELECT  @PERF_AVERAGE_BULK = 1073874176 ,
        @PERF_LARGE_RAW_BASE = 1073939712 

SELECT  dopc_avgBulk.object_name ,
        dopc_avgBulk.instance_name ,
        dopc_avgBulk.counter_name ,
        CAST(dopc_avgBulk.cntr_value AS FLOAT) 
         --when divisor is 0, return NULL to indicate
         --divide by 0
        / CAST(CASE dopc_base.cntr_value
                 WHEN 0 THEN NULL
                 ELSE dopc_base.cntr_value
               END AS FLOAT) AS cntr_value
FROM    sys.dm_os_performance_counters dopc_base
        JOIN sys.dm_os_performance_counters dopc_avgBulk
            ON dopc_base.cntr_type = @PERF_LARGE_RAW_BASE
             AND dopc_avgBulk.cntr_type = @PERF_AVERAGE_BULK
             AND dopc_base.object_name = dopc_avgBulk.object_name
             AND dopc_base.instance_name = dopc_avgBulk.instance_name
        --Average Wait Time has (ms) in name, 
        --so it has handled "special"
             AND ( REPLACE(dopc_base.counter_name,
              'base', '') = dopc_avgBulk.counter_name
             OR REPLACE(dopc_base.counter_name,
              'base', '') = REPLACE(dopc_avgBulk.counter_name,
              '(ms)', '')
             )
ORDER BY dopc_avgBulk.object_name ,
        dopc_avgBulk.instance_name ,
        dopc_avgBulk.counter_name

-- Listing 7.14: CPU configuration details.
-- Hardware information from SQL Server 2008 
-- (Cannot distinguish between HT and multi-core)
SELECT  cpu_count AS [Logical CPU Count] ,
        hyperthread_ratio AS [Hyperthread Ratio] ,
        cpu_count / hyperthread_ratio AS [Physical CPU Count] ,
        physical_memory_in_bytes / 1048576 AS [Physical Memory (MB)] ,
        sqlserver_start_time
FROM    sys.dm_os_sys_info ;

-- Listing 7.15: Interrogating memory configuration.
--Determine if this is a 32- or 64-bit SQL Server edition
DECLARE @ServerAddressing AS TINYINT
SELECT  @serverAddressing = CASE WHEN CHARINDEX('64',
                                                CAST(SERVERPROPERTY('Edition')
                                                     AS VARCHAR(100))) > 0
                                 THEN 64
                                 ELSE 32
                            END ;

SELECT  cpu_count / hyperthread_ratio AS SocketCount ,
        physical_memory_in_bytes / 1024 / 1024 AS physical_memory_mb ,
        virtual_memory_in_bytes / 1024 / 1024 AS sql_max_virtual_memory_mb ,
           -- same with other bpool columns as they are page oriented. 
           -- Multiplying by 8 takes it to 8K, then / 1024 to convert to mb
        bpool_committed * 8 / 1024 AS buffer_pool_committed_mb ,
           --64 bit OS does not have limitations with addressing as 32 did
        CASE WHEN @serverAddressing = 32
             THEN CASE WHEN virtual_memory_in_bytes / 1024 /
                                                     ( 2048 * 1024 ) < 1
                       THEN 'off'
                       ELSE 'on'
                  END
             ELSE 'N/A on 64 bit'
        END AS [/3GB switch]
FROM    sys.dm_os_sys_info

-- Listing 7.16: Investigating scheduler activity.
-- Get Avg task count and Avg runnable task count
SELECT  AVG(current_tasks_count) AS [Avg Task Count] ,
        AVG(runnable_tasks_count) AS [Avg Runnable Task Count]
FROM    sys.dm_os_schedulers
WHERE   scheduler_id < 255
        AND [status] = 'VISIBLE ONLINE' ;

-- Listing 7.17: Investigating potential disk I/O or CPU pressure.
SELECT  scheduler_id ,
        cpu_id ,
        Status ,
        is_online ,
        is_idle ,
        current_tasks_count ,
        runnable_tasks_count ,
        current_workers_count ,
        active_workers_count ,
        work_queue_count ,
        pending_disk_io_count ,
        load_factor
FROM    sys.dm_os_schedulers
WHERE   scheduler_id < 255
        AND runnable_tasks_count > 0 
     -- AND pending_disk_io_count > 0

-- Listing 7.18: Are there sufficient worker threads for the workload?
SELECT  AVG(work_queue_count)
FROM    sys.dm_os_schedulers
WHERE   status = 'VISIBLE ONLINE'

-- Listing 7.19: Investigating context switching.
SELECT  scheduler_id ,
        preemptive_switches_count ,
        context_switches_count ,
        idle_switches_count ,
        failed_to_create_worker
FROM    sys.dm_os_schedulers
WHERE   scheduler_id < 255

-- Listing 7.20: Is NUMA enabled?
-- Is NUMA enabled
SELECT  CASE COUNT(DISTINCT parent_node_id)
          WHEN 1 THEN 'NUMA disabled'
          ELSE 'NUMA enabled'
        END
FROM    sys.dm_os_schedulers
WHERE   parent_node_id <> 32 ;

-- Listing 7.21: Recent CPU utilization.
-- Get CPU Utilization History for last 30 minutes (in one minute intervals)
-- This version works with SQL Server 2008 and SQL Server 2008 R2 only
DECLARE @ts_now BIGINT = ( SELECT   cpu_ticks / ( cpu_ticks / ms_ticks )
                           FROM     sys.dm_os_sys_info
                         ) ; 

SELECT TOP ( 30 )
        SQLProcessUtilization AS [SQL Server Process CPU Utilization] ,
        SystemIdle AS [System Idle Process] ,
        100 - SystemIdle – SQLProcessUtilization
                             AS [Other Process CPU Utilization] ,
        DATEADD(ms, -1 * ( @ts_now - [timestamp] ), GETDATE())
                             AS [Event Time]
FROM    ( SELECT    record.value('(./Record/@id)[1]', 'int') AS record_id ,
                    record.value('(./Record/SchedulerMonitorEvent/
                                     SystemHealth/SystemIdle)[1]', 'int')
                                                             AS [SystemIdle] ,
                    record.value('(./Record/SchedulerMonitorEvent/
                                     SystemHealth/ProcessUtilization)[1]', 
                                     'int')
                                                AS [SQLProcessUtilization] ,
                    [timestamp]
          FROM      ( SELECT    [timestamp] ,
                                CONVERT(XML, record) AS [record]
                      FROM      sys.dm_os_ring_buffers
                      WHERE     ring_buffer_type = 
                                         N'RING_BUFFER_SCHEDULER_MONITOR'
                                AND record LIKE N'%<SystemHealth>%'
                    ) AS x
        ) AS y
ORDER BY record_id DESC ;

-- Listing 7.22: System memory usage.
SELECT  total_physical_memory_kb / 1024 AS total_physical_memory_mb ,
        available_physical_memory_kb / 1024 AS available_physical_memory_mb ,
        total_page_file_kb / 1024 AS total_page_file_mb ,
        available_page_file_kb / 1024 AS available_page_file_mb ,
        system_memory_state_desc
FROM    sys.dm_os_sys_memory

-- Listing 7.23: Memory usage by the SQL Server process.
SELECT  physical_memory_in_use_kb ,
        virtual_address_space_committed_kb ,
        virtual_address_space_available_kb ,
        page_fault_count ,
        process_physical_memory_low ,
        process_virtual_memory_low
FROM    sys.dm_os_process_memory

-- Listing 7.24: Memory allocation in the buffer pool.
-- Get total buffer usage by database
SELECT  DB_NAME(database_id) AS [Database Name] ,
        COUNT(*) * 8 / 1024.0 AS [Cached Size (MB)]
FROM    sys.dm_os_buffer_descriptors
WHERE   database_id > 4 -- exclude system databases
        AND database_id <> 32767 -- exclude ResourceDB
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC ;

-- Breaks down buffers by object (table, index) in the buffer pool
SELECT  OBJECT_NAME(p.[object_id]) AS [ObjectName] ,
        p.index_id ,
        COUNT(*) / 128 AS [Buffer size(MB)] ,
        COUNT(*) AS [Buffer_count]
FROM    sys.allocation_units AS a
        INNER JOIN sys.dm_os_buffer_descriptors
                 AS b ON a.allocation_unit_id = b.allocation_unit_id
        INNER JOIN sys.partitions AS p ON a.container_id = p.hobt_id
WHERE   b.database_id = DB_ID()
        AND p.[object_id] > 100 -- exclude system objects
GROUP BY p.[object_id] ,
        p.index_id
ORDER BY buffer_count DESC ;

-- Listing 7.25: Buffer pool usage.
-- Buffer Pool Usage for instance
SELECT TOP(20) [type], SUM(single_pages_kb) AS [SPA Mem, Kb] 
FROM sys.dm_os_memory_clerks 
GROUP BY [type]  
ORDER BY SUM(single_pages_kb) DESC;

-- Listing 7.26: Which queries have requested, or have had to wait for, large memory grants?
-- Shows the memory required by both running (non-null grant_time) 
-- and waiting queries (null grant_time)
-- SQL Server 2008 version
SELECT  DB_NAME(st.dbid) AS [DatabaseName] ,
        mg.requested_memory_kb ,
        mg.ideal_memory_kb ,
        mg.request_time ,
        mg.grant_time ,
        mg.query_cost ,
        mg.dop ,
        st.[text]
FROM    sys.dm_exec_query_memory_grants AS mg
        CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE   mg.request_time < COALESCE(grant_time, '99991231')
ORDER BY mg.requested_memory_kb DESC ;

-- Shows the memory required by both running (non-null grant_time) 
-- and waiting queries (null grant_time)
-- SQL Server 2005 version
SELECT  DB_NAME(st.dbid) AS [DatabaseName] ,
        mg.requested_memory_kb ,
        mg.request_time ,
        mg.grant_time ,
        mg.query_cost ,
        mg.dop ,
        st.[text]
FROM    sys.dm_exec_query_memory_grants AS mg
        CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE   mg.request_time < COALESCE(grant_time, '99991231')
ORDER BY mg.requested_memory_kb DESC ;

-- Listing 7.27: Returning the cache counters.
SELECT  type ,
        name ,
        single_pages_kb ,
        multi_pages_kb ,
        single_pages_in_use_kb ,
        multi_pages_in_use_kb ,
        entries_count ,
        entries_in_use_count
FROM    sys.dm_os_memory_cache_counters
ORDER BY type,name;

-- Listing 7.28: Investigating the use of the plan cache.
SELECT  name ,
        type ,
        entries_count ,
        entries_in_use_count
FROM    sys.dm_os_memory_cache_counters
WHERE   type IN ( 'CACHESTORE_SQLCP', 'CACHESTORE_OBJCP' ) 
               --ad hoc plans and object plans
ORDER BY name ,
        type

-- Listing 7.29: Investigating plan reuse counts.
--in a different connection, execute this all at once:
USE tempdb
go
CREATE PROCEDURE test
AS 
    WAITFOR DELAY '00:00:30'
    SELECT  *
    FROM    sys.sysobjects
go
EXECUTE test

-- Listing 7.30: Resetting the latch statistics.
DBCC SQLPERF ('sys.dm_os_latch_stats', CLEAR);

-- Listing 7.31: Seeking out latch waits.
SELECT  latch_class ,
        waiting_requests_count AS waitCount ,
        wait_time_ms AS waitTime ,
        max_wait_time_ms AS maxWait
FROM    sys.dm_os_latch_stats
ORDER BY wait_time_ms DESC

