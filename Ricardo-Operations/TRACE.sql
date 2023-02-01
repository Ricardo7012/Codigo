-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-trace-setstatus-transact-sql?view=sql-server-2017
-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-tracestatus-transact-sql?view=sql-server-2017
-- https://www.brentozar.com/blitz/trace-flags-enabled-globally/

DBCC TRACESTATUS(1);  
GO  
DBCC TRACESTATUS(2,3,4,5);  
GO  

SELECT * FROM sys.fn_trace_getinfo(0) ;  
GO  
--SELECT *  
--FROM ::fn_trace_getinfo(2)  
GO
EXECUTE sp_trace_setstatus @traceid = 2, @status = 0 
EXECUTE sp_trace_setstatus @traceid = 3, @status = 0 
EXECUTE sp_trace_setstatus @traceid = 4, @status = 0 
EXECUTE sp_trace_setstatus @traceid = 5, @status = 0 
--EXECUTE sp_trace_setstatus @traceid = 2, @status = 2 
DBCC TRACEOFF (2,3,4,5, -1);  
GO 

--SELECT *  
--FROM ::fn_trace_getinfo(2)
GO
  
SELECT * FROM sys.fn_trace_getinfo(0) ;  
GO  
