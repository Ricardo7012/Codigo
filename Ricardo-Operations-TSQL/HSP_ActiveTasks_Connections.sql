set transaction isolation level read uncommitted

select
    t1.session_id		[Session_ID]
    , t1.request_id		[Request_ID]
	, t1.task_alloc_pages	[Total_Pages_Allocated]
	, t1.task_dealloc_pages	[Total_Pages_DeAllocated]
    , cast((t1.task_alloc_pages * 8./1024./1024.) as numeric(10,1))		[Total_Allocated_in_GB]
    , cast((t1.task_dealloc_pages * 8./1024./1024.) as numeric(10,1))	[Total_DeAllocated_in_GB]
    , case when t1.session_id <= 50 then 'SYS' else s1.host_name end    [Host_Name]
       , db_name(s1.database_id) [Database_Name]


   
       , s1.logical_reads		[Logical_Reads]
       , s1.reads				[Reads]
       , s1.writes				[Writes]
       , s1.program_name		[Progam_Name]
    , s1.login_name				[Login_Name]
    , s1.status					[Status]
    , s1.last_request_start_time	[Last_Request_Start_Time]
    , s1.last_request_end_time		[Last_Request_End_Time]
	, DATEDIFF(ms, s1.last_request_start_time, s1.last_request_end_time) [Last_Request_Time_in_millisec]
    , s1.row_count	[Row_Count]
    , s1.transaction_isolation_level	[Transaction_Isolation_Level]

    ,t2.blocking_session_id [Blocking_Session_Id]
	,t2.wait_time			[Wait_Time]
    ,t2.last_wait_type		[Wait_Type]
    ,t2.wait_resource		[Wait_Resource]
    ,t2.statement_start_offset	[Statement_Start_Offset]
    ,t2.statement_end_offset	[Statement_End_Offset]

    ,  (SELECT object_name(objectid,dbid) 
        FROM sys.dm_exec_sql_text(t2.sql_handle)) 	[Object_Name]

 
 
    ,  coalesce((SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,
          (CASE WHEN statement_end_offset = -1
              THEN LEN(CONVERT(nvarchar(max),text)) * 2
                   ELSE statement_end_offset
              END - t2.statement_start_offset)/2)
        FROM sys.dm_exec_sql_text(t2.sql_handle)) , 'Not currently executing')	[Query_Text_UnScrubbed]



    , (SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle))	        [Query_Plan]


	,object_name(T.objectid,T.dbid) [Last_Execution_Object_Name]
	,CAST(SS.user_objects_alloc_page_count / 128 AS DECIMAL(15,2))              [Last_Execution_Total_Allocation_User_Objects] ,
    CAST(( SS.user_objects_alloc_page_count
            - SS.user_objects_dealloc_page_count )
    / 128 AS DECIMAL(15, 2))                                                    [Last_Execution_Net_Allocation_User_Objects] ,
    CAST(SS.internal_objects_alloc_page_count / 128 AS DECIMAL(15,2))           [Last_Execution_Total_Allocation_Internal_Objects] ,
    CAST(( SS.internal_objects_alloc_page_count
            - SS.internal_objects_dealloc_page_count )
    / 128 AS DECIMAL(15, 2))                                                    [Last_Execution_Net_Allocation_Internal_Objects] ,
    CAST(( SS.user_objects_alloc_page_count
            + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15,2))       [Last_Execution_Total_Allocation] ,
    CAST(( SS.user_objects_alloc_page_count
            + SS.internal_objects_alloc_page_count
            - SS.internal_objects_dealloc_page_count
            - SS.user_objects_dealloc_page_count )
    / 128 AS DECIMAL(15, 2))                                                    [Last_Execution_Net_Allocation] ,
    T.text                                                                      [Last_Execution_Query_Text_UnScrubbed]


from
    (Select session_id, request_id
    , task_alloc_pages=sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count)
    , task_dealloc_pages = sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count)
    from sys.dm_db_task_space_usage
    group by session_id, request_id) as t1
left join sys.dm_exec_requests as t2 on
    t1.session_id = t2.session_id
    and t1.request_id = t2.request_id
left join sys.dm_exec_sessions as s1 on
    t1.session_id=s1.session_id


	LEFT JOIN sys.dm_db_session_space_usage SS on SS.session_id = t1.session_id
    LEFT JOIN sys.dm_exec_connections CN ON CN.session_id = SS.session_id
    OUTER APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) T


where
    t1.session_id > 50 -- ignore system unless you suspect there's a problem there
    and t1.session_id <> @@SPID -- ignore this request itself
order by t1.task_alloc_pages DESC;

set transaction isolation level read uncommitted

SELECT
     sdes.session_id [Session_ID]
    ,sdes.login_time [Login_Time]
    ,sdes.last_request_start_time [Start_Time_Of_Last_Request]
    ,sdes.last_request_end_time [End_Time_Of_Last_Request]
    ,sdes.is_user_process [Is_User_Process]
    ,sdes.host_name [Host_Name]
    ,sdes.program_name [Program_Name]
    ,sdes.login_name [Login_Name]
    ,sdes.status [Status]

    ,sdec.num_reads [Number_of_Byte_Reads]
    ,sdec.num_writes [Number_of_Byte_Writes]
    ,sdec.last_read [Time_of_Last_Read]
    ,sdec.last_write [Time_of_Last_Write]
    ,sdes.reads [Number_of_Reads]
    ,sdes.logical_reads [Number_of_Logical_Reads]
    ,sdes.writes [Number_of_Writes]

    ,sdest.DatabaseName [DatabaseName]
    ,sdest.ObjName [ObjectName]
	,sdes.client_interface_name [Client_Interface_Name]
    ,sdes.nt_domain [NT_Domain]
    ,sdes.nt_user_name [NT_UserName]
    ,sdest.Query [Query_UnScrubbed]
FROM sys.dm_exec_sessions AS sdes

INNER JOIN sys.dm_exec_connections AS sdec
        ON sdec.session_id = sdes.session_id

CROSS APPLY (

    SELECT DB_NAME(dbid) AS DatabaseName
        ,OBJECT_NAME(objectid) AS ObjName
        ,COALESCE((
            SELECT TEXT AS [processing-instruction(definition)]
            FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
            FOR XML PATH('')
                ,TYPE
            ), '') AS Query

    FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)

) sdest
WHERE sdes.session_id <> @@SPID
  AND sdest.DatabaseName =db_name()

  set transaction isolation level read uncommitted

-- Which Queries are taking the most time/cpu to execute
SELECT TOP 50
    isnull(DB_NAME(dbid),'') + ISNULL('..' + OBJECT_NAME(objectid, dbid), '') [Object_Name],

    substring((SELECT isnull(SUBSTRING(est.[text], statement_start_offset/2 + 1,
        (CASE WHEN statement_end_offset = -1
            THEN LEN(CONVERT(nvarchar(max), est.[text])) * 2
            ELSE statement_end_offset
            END - statement_start_offset) / 2
        ), 'Offsets: ' + convert(varchar,statement_start_offset) + ' - ' + convert(varchar,statement_end_offset))
        FROM sys.dm_exec_sql_text([sql_handle]) AS est) , 0,2000) AS [Statement_Text_or_Offset_UnScrubbed],   
    

    total_worker_time [Total_Worker_Time_in_microsec], 
    total_elapsed_time [Total_Elapsed_Time_in_microsec],
    execution_count [Execution_Count],

    total_worker_time/execution_count [Avg_Worker_Time_in_microsec], 
    (total_worker_time/execution_count) * .000001 [Avg_Worker_Time_in_sec],
    (total_elapsed_time/execution_count) * .000001 [Avg_Elapsed_Time_in_sec],
    total_logical_reads/execution_count [Avg_Logical_Reads],
    total_logical_writes/execution_count AS [Avg_Logical_Writes],
    total_physical_reads/execution_count as [Avg_Physical_Reads],

    last_worker_time [Last_Worker_Time], 
    min_worker_time [Min_Worker_Time], 
    max_worker_time [Max_Worker_Time],
    last_elapsed_time [Last_Elapsed_Time], 
    min_elapsed_time [Min_Elapsed_Time], 
    max_elapsed_time [Max_Elapsed_Time],

    creation_time [Creation_Time], 
    last_execution_time [Last_Execution_Time],

    plan_generation_num [Number_Of_Plan_Recompiles],
    total_dop [Total_DOP],
    last_dop [Last_DOP], 
    min_dop [Min_DOP], 
    max_dop [Max_DOP], 
    total_used_threads [Total_Used_Threads],
    total_used_threads / execution_count [Avg_Used_Threads], 
    last_used_threads [Last_Used_Threads], 
    min_used_threads [Min_Used_Threads], 
    max_used_threads [Max_Used_Threads],

	(select convert(varchar,statement_start_offset) + ' - ' + convert(varchar,statement_end_offset)
        FROM sys.dm_exec_sql_text([sql_handle])) as [Statement_Offsets]




----------------------------------------------------
-- 2016 SP2+ only columns below this line !!!!!!!
--    total_spills / execution_count as avg_spills,
--    min_spills,  max_spills, last_spills,
----------------------------------------------------
FROM sys.dm_exec_query_stats
    OUTER APPLY sys.dm_exec_query_plan([plan_handle]) AS qp
WHERE [dbid] >= 5 AND DB_NAME(dbid) IS NOT NULL
  AND (total_worker_time/execution_count) > 100
  and dbid = db_id()
ORDER BY total_elapsed_time DESC
option (recompile);
