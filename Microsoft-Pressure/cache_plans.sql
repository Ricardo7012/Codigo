/* Use Statistics Profile /XML events in Sql Trace
Obtain query plan using set statistics profile on/off */



/*
Only showing top 20 modify or remove top(20) if more data is needed but may take longer and use more resource
*/
select top(20) b.query_plan , c.text from sys.dm_exec_cached_plans a cross apply sys.dm_exec_query_plan(a.plan_handle)  b cross apply 
sys.dm_exec_sql_text(a.plan_handle) c order by a.usecounts desc