-- ADHOC QUERY USE AND ABUSE
-- https://solutioncenter.apexsql.com/monitoring-sql-server-ad-hoc-query-use-and-abuse/
SELECT @@SERVERNAME AS SN,
       DB_NAME(QueryText.dbid) AS database_name,
       SUM(   CASE
                  WHEN ExecPlans.usecounts = 1 THEN
                      1
                  ELSE
                      0
              END
          ) AS Single,
       SUM(   CASE
                  WHEN ExecPlans.usecounts > 1 THEN
                      1
                  ELSE
                      0
              END
          ) AS Reused,
       SUM(CAST(ExecPlans.size_in_bytes AS BIGINT)) AS Bytes
FROM sys.dm_exec_cached_plans AS ExecPlans
    CROSS APPLY sys.dm_exec_sql_text(ExecPlans.plan_handle) AS QueryText
WHERE ExecPlans.cacheobjtype = 'Compiled Plan'
      AND QueryText.dbid IS NOT NULL
GROUP BY QueryText.dbid;
GO

SELECT CONVERT(INT,
               SUM(   CASE a.objtype
                          WHEN 'Adhoc' THEN
                              1
                          ELSE
                              0
                      END
                  ) * 1.00 / COUNT(*) * 100
              ) AS 'Ad-hoc query %'
FROM sys.dm_exec_cached_plans AS a;
GO
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-cached-plans-transact-sql?view=sql-server-ver15

SELECT objtype,
       COUNT(objtype) AS CNT
FROM sys.dm_exec_cached_plans
GROUP BY objtype;
GO
