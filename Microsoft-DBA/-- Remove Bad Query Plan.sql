-- Remove Bad Query Plan

DECLARE @Object_Name varchar(35)
DECLARE @Plan_Handle varbinary(64)

SET @Object_Name = '%Proc_CompositeView%'

SELECT @Plan_Handle = cp.plan_handle
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE OBJECT_NAME(st.objectid) LIKE @Object_Name
OPTION (RECOMPILE);

DBCC FREEPROCCACHE(@Plan_Handle);
