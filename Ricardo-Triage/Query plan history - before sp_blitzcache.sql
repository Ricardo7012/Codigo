-- https://www.brentozar.com/archive/2018/07/tsql2sday-how-much-plan-cache-history-do-you-have/
--Before I run sp_BlitzCache to analyze which queries have been the most resource-intensive, 
--I wanna know, “How much query plan history does SQL Server have available?” Looking at the top 10 plans in the cache doesn’t do me much good if:

--Someone restarted the server recently
--Someone ran DBCC FREEPROCCACHE
--Somebody’s addicted to rebuilding indexes and updating stats (which invalidates plans for all affected objects)
--The server’s under extreme memory pressure
--The developers aren’t parameterizing their queries
--The app has an old version of NHibernate with the parameterization bug
--The .NET app calls .Parameters.Add without setting the parameter size
--I could go on and on – there are so many things that give SQL Server amnesia. So here’s how I check:

SET TRAN ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 50
    creation_date = CAST(creation_time AS date),
    creation_hour = CASE
                        WHEN CAST(creation_time AS date) <> CAST(GETDATE() AS date) THEN 0
                        ELSE DATEPART(hh, creation_time)
                    END,
    SUM(1) AS plans
FROM sys.dm_exec_query_stats
GROUP BY CAST(creation_time AS date),
         CASE
             WHEN CAST(creation_time AS date) <> CAST(GETDATE() AS date) THEN 0
             ELSE DATEPART(hh, creation_time)
         END
ORDER BY 1 DESC, 2 DESC

SELECT @@ServerName, GETDATE() AS SERVERNAME
