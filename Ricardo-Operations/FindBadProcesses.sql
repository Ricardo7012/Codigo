-- https://technet.microsoft.com/en-us/library/2005.05.systemtables.aspx
-- GET A TRAFFIC REPORT: ANALYZE YOUR DATABASE USAGE WITH SYSTEM TABLES 
SELECT program_name, count(*)
FROM
Master..sysprocesses
WHERE ecid=0
GROUP BY program_name
ORDER BY count(*) desc

--FIND BAD PROCESSES
SELECT 
TOP 30
spid, blocked, 
    convert(varchar(10),db_name(dbid)) as DBName, 
    cpu, 
    datediff(second,login_time, getdate()) as Secs,
    convert(float, cpu / datediff(second,login_time, getdate())) as PScore,
    convert(varchar(16), hostname) as Host,
    convert(varchar(50), program_name) as Program,
    convert(varchar(20), loginame) as Login
FROM master..sysprocesses
WHERE datediff(second,login_time, getdate()) > 0 and spid > 50
ORDER BY pscore desc

--FIND RESOURCE HOGS
SELECT 
    convert(varchar(50), program_name) as Program,
    count(*) as CliCount,
    sum(cpu) as CPUSum, 
    sum(datediff(second, login_time, getdate())) as SecSum,
    convert(float, sum(cpu)) / convert(float, sum(datediff(second, login_time, getdate()))) as Score,
    convert(float, sum(cpu)) / convert(float, sum(datediff(second, login_time, getdate()))) / count(*) as ProgramBadnessFactor
FROM master..sysprocesses
WHERE spid > 50
GROUP BY
    convert(varchar(50), program_name)
ORDER BY score DESC

-- https://www.mssqltips.com/sqlservertip/3171/identify-sql-server-databases-that-are-no-longer-in-use/

-- SQL SERVER USER CONNECTION COUNT
SELECT @@ServerName AS server
 ,NAME AS dbname
 ,COUNT(STATUS) AS number_of_connections
 ,GETDATE() AS timestamp
FROM sys.databases sd
LEFT JOIN sysprocesses sp ON sd.database_id = sp.dbid
WHERE database_id NOT BETWEEN 1 AND 4
GROUP BY NAME


--DROP TABLE [dbo].[IEHP_Connections]
--GO


--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE TABLE [dbo].[ConnectionsCount](
-- [server] [nvarchar](130) NOT NULL,
-- [name] [nvarchar](130) NOT NULL,
-- [number_of_connections] [int] NOT NULL,
-- [timestamp] [datetime] NOT NULL
--) ON [PRIMARY]
--GO

--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--DROP PROCEDURE usp_ConnectionsCount 

--CREATE PROCEDURE usp_ConnectionsCount 
--AS
--BEGIN
-- SET NOCOUNT ON;
--INSERT INTO IEHP_Connections 
--  SELECT @@ServerName AS server
-- ,NAME AS dbname
-- ,COUNT(STATUS) AS number_of_connections
-- ,GETDATE() AS timestamp
--FROM sys.databases sd
--LEFT JOIN master.dbo.sysprocesses sp ON sd.database_id = sp.dbid
--WHERE database_id NOT BETWEEN 1
--  AND 4
--GROUP BY NAME
--END

--RESULTS
SELECT NAME
 ,MAX(number_of_connections) AS MAX#
FROM ConnectionsCount
GROUP BY NAME

SELECT 
 [server]
 ,[name]
 ,number_of_connections
 ,timestamp
FROM ConnectionsCount
