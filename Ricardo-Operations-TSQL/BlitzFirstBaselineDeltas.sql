--:CONNECT HSP3S1A

-- https://www.brentozar.com/archive/2019/02/video-how-to-capture-baselines-with-sp_blitzfirst/
USE [DBAKit];
GO
SELECT *
FROM [DBAKit].[dbo].[BlitzFirst_FileStats]
ORDER BY CheckDate DESC;
GO
SELECT *
FROM [DBAKit].[dbo].[BlitzFirst_PerfmonStats]
--WHERE counter_name = 'Forwarded Records/sec'
ORDER BY CheckDate DESC;
GO

SELECT *
FROM [DBAKit].[dbo].[BlitzFirst]
WHERE CheckDate >= '2021-04-14 14:00:00.0000000 -07:00'
      AND CheckDate <= '2021-04-14 15:00:00.0000000 -07:00'
ORDER BY CheckDate DESC;
GO

SELECT *
FROM [DBAKit].[dbo].[BlitzFirst_FileStats_Deltas]
ORDER BY CheckDate DESC;


SELECT *
FROM [DBAKit].[dbo].[BlitzFirst_PerfmonStats_Actuals]
ORDER BY CheckDate DESC;
GO

SELECT *
FROM [DBAKit].[dbo].[BlitzFirst_PerfmonStats_Deltas]
WHERE 
       CheckDate >= '2021-04-21 07:00:00.0000000 -07:00'
      AND CheckDate <= '2021-04-21 16:00:00.0000000 -07:00'
	  AND counter_name = 'Forwarded Records/sec'
ORDER BY CheckDate DESC;
GO

SELECT *
FROM [DBAKit].[dbo].[BlitzFirst_WaitStats_Deltas]
ORDER BY CheckDate DESC;
GO

SELECT *
FROM [DBAKit].[dbo].[BlitzWho_Deltas]
ORDER BY CheckDate DESC;
GO
