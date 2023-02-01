/*In addition, we need to pay attention that, the column 'usecounts' of the 
DMV will be reset after a SQL Server service restart, so the execution count 
we got is the accumulated executed count since the lasted server restart .

http://social.msdn.microsoft.com/Forums/en-AU/sqltools/thread/64c6ed3f-4d34-42e0-9a3c-9d3976fabb16

*/
 

SELECT 
    DB_NAME(st.dbid) DBName
   ,OBJECT_SCHEMA_NAME(st.objectid,dbid) SchemaName
   ,OBJECT_NAME(st.objectid,dbid) StoredProcedure
   ,max(cp.usecounts) Execution_count
 FROM 
	sys.dm_exec_cached_plans cp
     CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
 where 
	DB_NAME(st.dbid) is not null and 
	cp.objtype = 'proc'
  group by 
	cp.plan_handle, DB_NAME(st.dbid),
    OBJECT_SCHEMA_NAME(objectid,st.dbid), 
	OBJECT_NAME(objectid,st.dbid) 
 order by 
	OBJECT_NAME(st.objectid,dbid) asc
  --max(cp.usecounts)

