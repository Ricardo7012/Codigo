/*
https://sqljunkieshare.com/tag/page-locks-in-tempdb/
What is tempDB contention?

From the outside looking in, tempDB contention may look like any other blocking. 
There are two types of contention that tends to plague tempDB’s, especially when 
the tempDB is not configured to best practices (multiple, equally sized data files, 
located on a dedicated, high-speed drive, etc.). lets focus on latch contention on 
the allocation pages.

What are allocation pages?

Allocation pages are special pages in the data files that track and mange extent allocations. 
There are 3 types of allocation pages that can experience contention and bring a server to a slow crawl.

Global Allocation Map (GAM): Tracks which extents have been allocated. 
There is 1 GAM page for every 4 GB of data file. It is always page 2 in 
the data file and then repeats every 511,232 pages.

Shared Global Allocation Map (SGAM): Tracks which extents are being used as 
mixed (shared) extents. There is 1 SGAM page for every 4 GB of data file. It is 
always page 3 in the data file and then repeats every 511,232 pages.

Page Free Space (PFS): Tracks the allocation status of each page and approximately 
how much free space it has. There is 1 PFS page for every 1/2 GB of data file. It 
is always page 1 in the data file and then repeats every 8,088 pages.

Finding Latch Contention on Allocation Pages

You can use the dynamic management view (DMV) sys.dm_os_waiting_tasks to find tasks 
that are waiting on a resource. Tasks waiting on PageIOLatch or PageLatch wait types 
are experiencing contention. The resource description points to the page that is 
experiencing contention, and you can easily parse the resource description to get 
the page number. Then it’s just a math problem to determine if it is an allocation page.
*/

--Key Wait
SELECT 
 o.name AS TableName, 
i.name AS IndexName,
SCHEMA_NAME(o.schema_id) AS SchemaName
FROM sys.partitions p JOIN sys.objects o ON p.OBJECT_ID = o.OBJECT_ID 
JOIN sys.indexes i ON p.OBJECT_ID = i.OBJECT_ID  AND p.index_id = i.index_id 
WHERE p.hobt_id = 72057594040811520


--Page Wait
8:19:1966734
2:5:3578624

SELECT DB_NAME(2)
/*

DBCC traceon (3604)
GO
DBCC page (2, 5, 3578624) --Database_id,file_id,page_id
GO
DBCC traceoff (3604)
GO

*/

Select session_id,
wait_type,
wait_duration_ms,
blocking_session_id,
resource_description,
ResourceType = Case
When Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) As Int) - 1 % 8088 = 0 Then 'Is PFS Page'
When Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) As Int) - 2 % 511232 = 0 Then 'Is GAM Page'
When Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) As Int) - 3 % 511232 = 0 Then 'Is SGAM Page'
Else 'Is Not PFS, GAM, or SGAM page'
End
From sys.dm_os_waiting_tasks
Where wait_type Like 'PAGE%LATCH_%'
And resource_description Like '2:%'




;WITH task_space_usage AS (
    -- SUM alloc/delloc pages
    SELECT session_id,
           request_id,
           SUM(internal_objects_alloc_page_count) AS alloc_pages,
           SUM(internal_objects_dealloc_page_count) AS dealloc_pages
    FROM sys.dm_db_task_space_usage WITH (NOLOCK)
    WHERE session_id <> @@SPID
    GROUP BY session_id, request_id
)
SELECT TSU.session_id,
       TSU.alloc_pages * 1.0 / 128 AS [internal object MB space],
       TSU.dealloc_pages * 1.0 / 128 AS [internal object dealloc MB space],
       EST.text,
       -- Extract statement from sql text
       ISNULL(
           NULLIF(
               SUBSTRING(
                 EST.text, 
                 ERQ.statement_start_offset / 2, 
                 CASE WHEN ERQ.statement_end_offset < ERQ.statement_start_offset 
                  THEN 0 
                 ELSE( ERQ.statement_end_offset - ERQ.statement_start_offset ) / 2 END
               ), ''
           ), EST.text
       ) AS [statement text],
       EQP.query_plan
FROM task_space_usage AS TSU
INNER JOIN sys.dm_exec_requests ERQ WITH (NOLOCK)
    ON  TSU.session_id = ERQ.session_id
    AND TSU.request_id = ERQ.request_id
OUTER APPLY sys.dm_exec_sql_text(ERQ.sql_handle) AS EST
OUTER APPLY sys.dm_exec_query_plan(ERQ.plan_handle) AS EQP
WHERE EST.text IS NOT NULL OR EQP.query_plan IS NOT NULL
ORDER BY 3 DESC;
