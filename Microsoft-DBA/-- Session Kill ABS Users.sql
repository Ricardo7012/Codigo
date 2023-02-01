-- Session Kill ABS Users by Application

DECLARE @QKILLsp VARCHAR(1000)

-- Create the Tmp table
CREATE TABLE #SYSPROCESSES (
       spid SMALLINT
       , loginame NCHAR(128)
       , hostname NCHAR(128)
       , dbid NVARCHAR(128)
       , program_name NCHAR(128)
       , machinename NVARCHAR(128)
       , servername NVARCHAR(128)
       )
-- Pull the login
INSERT INTO #SYSPROCESSES
SELECT spid AS 'SPID'
       , loginame AS 'Login Name'
       , hostname AS 'Host Name'
       , DB_NAME(dbid) AS 'DBName'
       , program_name AS 'Program Name'
       , CONVERT(SYSNAME, SERVERPROPERTY(N'MachineName'))
       , CONVERT(SYSNAME, SERVERPROPERTY(N'ServerName'))
FROM SYS.SYSPROCESSES
WHERE loginame IN (       
              'ABSAttStat'
              , 'ABSBif'
              , 'ABSBimbo'
              , 'ABSBingo'
              , 'ABSCrystal'
              , 'ABSFjp'
              , 'ABSGuardian'
              , 'ABSHardDrop'
              , 'ABSMonitor'
              , 'ABSPaging'
              , 'ABSPlayerTracking'
              , 'ABSProphet'
              , 'ABSRedemption'
              , 'ABSSql'
              , 'ABSTrans'
              , 'ABSTransPT'
              , 'ABSTransTW'
              , 'ABSWizard'
              , 'Merlin'
              )
       AND program_name IN (
              'Microsoft SQL Server Management Studio - Query'
              , 'Microsoft SQL Server Management Studio'
              , 'dbForge SQL Complete'
              , '2007 Microsoft Office system'
              , 'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense'
              , '.Net SqlClient Data Provider'
              )
     
       SET @QKILLsp = (
                     SELECT DISTINCT ' KILL ' + CONVERT(VARCHAR, spid)
                     FROM #SYSPROCESSES
                     FOR XML PATH('')
                     )

       EXEC (@QKILLsp)

DROP TABLE #SYSPROCESSES