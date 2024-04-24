--CONNECT:HSP1S1A
USE HSP;
GO

SELECT [ReportType],
        CONVERT(VARCHAR(10), [event time], 101) [Event Date],
       --[client app _name],
       --[client host name],
       case 
	   when [database name] = '' then NULL
	   else [database name]
	   end as [database name],
    --   case 
	   --when [schema] = '' then NULL
	   --when [schema] = ' -- N/A -- ' then NULL
	   --else [schema]
	   --end as [schema],
	   case 
	   when [table] = '' then NULL
	   when [table] = ' -- N/A -- ' then NULL
	   else [table]
	   end as [table],
       [index_id],
	   [duration (ms)],
       CONVERT(TIME,DATEADD (ms, [duration (ms)], 0))as [duration(min)],
       [lock_mode]
       --[username],
       --[Report]
FROM [DB_Admin].[dbo].[Deadlock_BPR_Trace]
WHERE CONVERT(DATE, [event time]) > '10-16-2021'
      AND ReportType != 'Lock Escalation'
	  AND ReportType != 'Deadlock'
ORDER BY [duration (ms)] desc
GO
