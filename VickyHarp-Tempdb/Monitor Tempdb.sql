-- View File Information
select
	getdate(),
	name,
	physical_name,
	size,	
	UserObjectsMB = user_object_reserved_page_count / 128.0,
	InternalObjectsMB = internal_object_reserved_page_count / 128.0,
	VersionStoreMB = version_store_reserved_page_count / 128.0,
	MixedExtentsMB = mixed_extent_page_count / 128.0,
	FreeSpaceMB = unallocated_extent_page_count / 128.0
from 
	tempdb.sys.dm_db_file_space_usage fsu
	inner join tempdb.sys.database_files df
	on fsu.file_id = df.file_id
where fsu.database_id = 2 

-- Contention
;With Tasks
As (Select session_id,
        wait_type,
        cast(wait_duration_ms as dec(38,0)) as wait_duration_ms,
        PageID = Right(resource_description, Len(resource_description)
                - Charindex(':', resource_description, 3))
    From sys.dm_os_waiting_tasks
    Where wait_type Like 'PAGE%LATCH_%'
    And resource_description Like '2:%')
, wait_page_descriptions
As (Select wait_duration_ms,
              wait_type= Case IsNumeric(PageID)
					When 1 Then Case
						 When PageID = 1 Or PageID % 8088 = 0 Then 'PFS'
						 When PageID = 2 Or PageID % 511232 = 0 Then 'GAM'
						 When PageID = 3 Or (PageID - 1) % 511232 = 0 Then 'SGAM'
	                    End
              End
       From Tasks)
select
       wait_duration = sum(wait_duration_ms),
       wait_type
from
       wait_page_descriptions
where wait_type in ('PFS', 'GAM', 'SGAM')
group by
       wait_type


-- View snapshot isolation transactions
select 
	*
from 
	sys.dm_tran_active_snapshot_database_transactions snaps 

-- View version store generation and cleanup
select
	rtrim(counter_name),
	cast(cntr_value as bigint)
from
	sys.dm_os_performance_counters
where 
	counter_name in( 'Version Generation rate (KB/s)', 'Version Cleanup rate (KB/s)')

-- View session usage data
select
	ssu.session_id,
	sessionUserPagesAlloc = sum(ssu.user_objects_alloc_page_count),
	sessionUserPagesDealloc = sum(ssu.user_objects_dealloc_page_count),
	taskUserPagesAlloc = sum(tsu.user_objects_alloc_page_count),
	taskUserPagesDealloc = sum(tsu.user_objects_dealloc_page_count),
	sessionInternalPagesAlloc = sum(ssu.internal_objects_alloc_page_count),
	sessionInternalPagesDealloc = sum(ssu.internal_objects_dealloc_page_count),
	taskInternalPagesAlloc = sum(tsu.internal_objects_alloc_page_count),
	taskInternalPagesDealloc = sum(tsu.internal_objects_dealloc_page_count)
from
	tempdb.sys.dm_db_session_space_usage ssu
	left join tempdb.sys.dm_db_task_space_usage tsu
	on ssu.session_id = tsu.session_id
group by
	ssu.session_id
having sum(ssu.user_objects_alloc_page_count  
			+ tsu.user_objects_alloc_page_count 
			+ ssu.internal_objects_alloc_page_count 
			+ tsu.internal_objects_alloc_page_count 
			) > 0