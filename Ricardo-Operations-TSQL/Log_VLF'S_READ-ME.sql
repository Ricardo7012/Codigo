-- https://docs.microsoft.com/en-us/sql/relational-databases/system-compatibility-views/sys-sysfiles-transact-sql?view=sql-server-ver15
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-master-files-transact-sql?view=sql-server-ver15 
SELECT name, (size*8)/1024 AS log_MB, * FROM [HSP_QA2].dbo.sysfiles WHERE (64 & status) = 64
SELECT name, (size*8)/1024 AS log_MB, * FROM [HSP_QA2].sys.sysfiles WHERE (64 & status) = 64

-- 
-- VLF stands for Virtual Log File and the transaction log file is made up of one or more virtual log files. 
-- The number of virtual log files can grow based on the autogrowth settings for the log file and how often the active transactions are written to disk.  
-- Too many virtual log files can cause transaction log backups to slow down and can also slow down database recovery, and in extreme cases, even affect insert/update/delete performance.
   
-- Server sp_Blitz script checks the number of virtual log files (VLFs) in each database and alerts when there’s 1,000 or more. 
-- Right at 1,000 may not be a problem based on your database size 
-- we just want to bring the problem up before it becomes critical, since fixing this issue is a pain in the rear.
   
-- To Fix the Problem
-- Bad news: we’re going to have some downtime.  The whole server doesn’t have to be down, but to fix this, we have to shrink and regrow the log file – and that’s a blocking operation. 

-- https://www.brentozar.com/blitz/ 
-- sp_Blitz® – Free SQL Server Health Check Script checks VLFs
-- see free 7 min video 
--