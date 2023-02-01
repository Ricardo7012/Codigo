
EXEC DBAKit.dbo.sp_blitzwho	@ShowSleepingSpids = 0, @expertmode=1
GO

 --@get_plans=0, @show_system_spids = 0
DECLARE @i AS int = 149
-- MONITORING-SCHEDULERS-THREADS-WORKERS-TASKS-REQUESTS-SESSIONS-CONNECTIONS-USERS
/**************************************************************************************************
--Query 1: User Connection & Query as a Request
--Query 2: Request is divided into Task(s)
--Query 3: Each Task is assigned to a Worker (an available worker)
--Query 4: Each Worker is associated with a Thread
--Query 5: Schedulers associated with CPU schedules CPU time for Workers
****************************************************************************************************/

/**************************************************************************************************
--Query 1: User Connection & Query as a Request
****************************************************************************************************/
SELECT req.connection_id
     , req.database_id
     , req.session_id
     , req.command
     , req.request_id
     , req.start_time
     , req.task_address
     , query.text
FROM sys.dm_exec_requests                            req
    CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS query
WHERE req.session_id = @i; -- *****SPID of your query that is running*****

/**************************************************************************************************
--Query 2: Request is divided into Task(s)
****************************************************************************************************/
SELECT task.task_address
     , task.parent_task_address
     , task.task_state
     , req.request_id
     , req.database_id
     , req.session_id
     , req.start_time
     , req.command
     , req.connection_id
     , req.task_address
     , query.text
FROM sys.dm_exec_requests                            req
    INNER JOIN sys.dm_os_tasks                       task
        ON req.task_address = task.task_address
           OR req.task_address = task.parent_task_address
    CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS query
WHERE req.session_id = @i;

/**************************************************************************************************
--Query 3: Each Task is assigned to a Worker (an available worker)
****************************************************************************************************/
SELECT WORKER.worker_address
     , WORKER.last_wait_type
     , WORKER.state
     , task.task_address AS [task.task_address]
     , task.parent_task_address
     , task.task_state
     , req.request_id
     , req.database_id
     , req.session_id
     , req.start_time
     , req.command
     , req.connection_id
     , req.task_address AS [req.task_address]
     , query.text
FROM sys.dm_exec_requests                            req
    INNER JOIN sys.dm_os_tasks                       task
        ON req.task_address = task.task_address
           OR req.task_address = task.parent_task_address
    INNER JOIN sys.dm_os_workers                     WORKER
        ON task.task_address = WORKER.task_address
    CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS query
WHERE req.session_id = @i;
/**************************************************************************************************
--Query 4: Each Worker is associated with a Thread
****************************************************************************************************/
SELECT thread.thread_address
     , thread.priority
     , thread.processor_group
     , thread.started_by_sqlservr
     , WORKER.worker_address
     , WORKER.last_wait_type
     , WORKER.state
     , task.task_address
     , task.parent_task_address
     , task.task_state
     , req.request_id
     , req.database_id
     , req.session_id
     , req.start_time
     , req.command
     , req.connection_id
     , req.task_address
     , query.text
FROM sys.dm_exec_requests                            req
    INNER JOIN sys.dm_os_tasks                       task
        ON req.task_address = task.task_address
           OR req.task_address = task.parent_task_address
    INNER JOIN sys.dm_os_workers                     WORKER
        ON task.task_address = WORKER.task_address
    INNER JOIN sys.dm_os_threads                     thread
        ON WORKER.thread_address = thread.thread_address
    CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS query
WHERE req.session_id = @i;
/**************************************************************************************************
--Query 5: Schedulers associated with CPU schedules CPU time for Workers
****************************************************************************************************/
SELECT sch.scheduler_address
     , sch.runnable_tasks_count
     , sch.scheduler_id
     , sch.cpu_id
     , sch.status                 AS 'SchedulerStatus'
     , thread.thread_address
     , thread.priority            AS 'thread priority'
     , thread.processor_group
     , thread.started_by_sqlservr AS 'ThreadStartedByMSSQL'
     , WORKER.worker_address
     , WORKER.last_wait_type
     , WORKER.state               AS 'WorkerState'
     , task.task_address
     , task.parent_task_address
     , task.task_state
     , req.request_id
     , req.database_id
     , req.session_id
     , req.start_time
     , req.command
     , req.connection_id
     , req.task_address
     , query.text
FROM sys.dm_exec_requests                            req
    INNER JOIN sys.dm_os_tasks                       task
        ON req.task_address = task.task_address
           OR req.task_address = task.parent_task_address
    INNER JOIN sys.dm_os_workers                     WORKER
        ON task.task_address = WORKER.task_address
    INNER JOIN sys.dm_os_threads                     thread
        ON WORKER.thread_address = thread.thread_address
    INNER JOIN sys.dm_os_schedulers                  sch
        ON sch.scheduler_address = WORKER.scheduler_address
    CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS query
WHERE req.session_id = @i
ORDER BY sch.scheduler_id ASC;


/**************************************************************************************************
-- https://docs.microsoft.com/en-us/sql/relational-databases/thread-and-task-architecture-guide?view=sql-server-ver15

High-level:

1. When an user connects to SQL Server a ConnectionID & SessionID are assigned to the user.
DMV: sys.dm_exec_connections, sys.dm_exec_sessions

2. Queries being executed by the User/Connection/Session are Requests
DMV: sys.dm_exec_requests and sys.dm_exec_sql_text(plan_handle)

3. Once the Execution Plan of a Query is generated, it is divided into one or more tasks. The number of Tasks depends on Query Parallelism.
DMV: sys.dm_os_tasks

4. Each Task is assigned to a Worker. A Worker is where the work actually gets done.
Maximum number of workers (assigned to SQL Server) depends on the number of CPUs and hardware architecture (32 bit or 64 bit)
Further read: http://blogs.msdn.com/b/sqlsakthi/archive/2011/03/14/max-worker-threads-and-when-you-should-change-it.aspx
DMV: sys.dm_os_workers

5. Each Worker is associated with a Thread.
DMV: sys.dm_os_threads

6. Scheduler schedules CPU time for a Task/Worker.
When SQL Server service starts, it creates one Scheduler for each logical CPU. (few more Schedulers for internal purpose).
During this period, Scheduler may keep a task in RUNNING or RUNNABLE or SUSPENDED state for various reasons.
DMV: sys.dm_os_schedulers

7. Once the Task is completed, all consumed resources are freed


--THE SCHEDULER IS THE PHYSICAL OR LOGICAL PROCESSOR THAT IS RESPONSIBLE FOR SCHEDULING THE EXECUTION OF THE SQL SERVER THREADS.
--THE WORKER IS THE THREAD THAT IS BOUND TO A SCHEDULER TO PERFORM A SPECIFIC TASK.
--THE DEGREE OF PARALLELISM IS THE NUMBER OF WORKERS, OR THE NUMBER OF PROCESSORS, THAT ARE ASSIGNED FOR THE PARALLEL PLAN TO ACCOMPLISH THE WORKER TASK.
--THE MAXIMUM DEGREE OF PARALLELISM (MAXDOP) IS A SERVER, DATABASE OR QUERY LEVEL OPTION THAT IS USED TO LIMIT THE NUMBER OF PROCESSORS THAT THE PARALLEL PLAN CAN USE. 
THE DEFAULT VALUE OF MAXDOP IS 0, IN WHICH THE SQL SERVER ENGINE CAN USE ALL AVAILABLE PROCESSORS, UP TO 64, IN THE QUERY PARALLEL EXECUTION. SETTING THE MAXDOP OPTION 
TO 1 WILL PREVENT USING MORE THAN ONE PROCESSOR IN EXECUTING THE QUERY, WHICH MEANS THAT THE SQL SERVER ENGINE WILL USE A SERIAL PLAN TO EXECUTE THE QUERY. THE MAXDOP 
OPTION CAN TAKE VALUE UP TO 32767, WHERE THE SQL SERVER ENGINE WILL USE ALL AVAILABLE SERVER PROCESSORS IN THE PARALLEL PLAN EXECUTION IF THE MAXDOP VALUE EXCEEDS THE 
NUMBER OF PROCESSORS AVAILABLE IN THE SERVER. IF THE SQL SERVER IS INSTALLED ON A SINGLE PROCESSOR SERVER, THE VALUE OF MAXDOP WILL BE IGNORED.

--THE TASK IS A SMALL PIECE OF WORK THAT IS ASSIGNED TO A SPECIFIC WORKER.
--THE EXECUTION CONTEXT IS THE BOUNDARY IN WHICH EACH SINGLE TASK RUN INSIDE.
--THE PARALLEL PAGE SUPPLIER IS A PART OF THE SQL SERVER STORAGE ENGINE THAT DISTRIBUTES THE DATA SETS REQUESTED BY THE QUERY WITHIN THE PARTICIPATED WORKERS.
--THE EXCHANGE IS THE COMPONENT THAT WILL CONNECT THE DIFFERENT EXECUTION CONTEXTS INVOLVED IN THE QUERY PARALLEL PLAN TOGETHER, TO GET THE FINAL RESULT.
--THE DECISION OF USING A PARALLEL PLAN TO EXECUTE THE QUERY OR NOT DEPENDS ON MULTIPLE FACTORS. FOR EXAMPLE, SQL SERVER SHOULD BE INSTALLED ON A MULTI-PROCESSOR SERVER, 
THE REQUESTED NUMBER OF THREADS SHOULD BE AVAILABLE TO BE SATISFIED, THE MAXIMUM DEGREE OF PARALLELISM OPTION IS NOT SET TO 1 AND THE COST OF THE QUERY EXCEEDS 
THE PREVIOUSLY CONFIGURED COST THRESHOLD FOR PARALLELISM VALUE.


****************************************************************************************************/
