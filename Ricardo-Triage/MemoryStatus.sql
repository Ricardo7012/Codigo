SELECT @@SERVERNAME AS SERVERNAME, GETDATE() AS DATETIME
-- https://support.microsoft.com/en-us/help/907877/how-to-use-the-dbcc-memorystatus-command-to-monitor-memory-usage-on-sq
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/*
The first section of the output is Memory Manager. This section shows overall memory consumption by SQL Server.
   Memory Manager                 KB 
   ------------------------------ --------------------
   VM Reserved                    1761400
   VM Committed                   1663556
   AWE Allocated                  0
   Reserved Memory                1024
   Reserved Memory In Use         0
*/
--DBCC MEMORYSTATUS

-- http://slavasql.blogspot.com/2016/08/parsing-dbcc-memorystatus-without-using.html
SET NOCOUNT ON
GO

EXEC sp_configure 'xp_cmdshell', 1 ;  
GO  
RECONFIGURE ;  
GO  

IF OBJECT_ID('tempdb..#tbl_MemoryStatusDump') IS NOT NULL
DROP TABLE #tbl_MemoryStatusDump;
GO
IF OBJECT_ID('tempdb..#tbl_MemoryStatus') IS NOT NULL
DROP TABLE #tbl_MemoryStatus;
GO
CREATE TABLE #tbl_MemoryStatusDump(
 ID INT IDENTITY(1,1) PRIMARY KEY
 , Dump VARCHAR(100));
GO
CREATE TABLE #tbl_MemoryStatus(
 ID INT IDENTITY(1,1), 
 [DataSet] VARCHAR(100), 
 [Measure] VARCHAR(20), 
 [Counter] VARCHAR(100), 
 [Value] MONEY);
GO
INSERT INTO #tbl_MemoryStatusDump(Dump)
EXEC ('xp_cmdshell ''sqlcmd -E -S localhost -Q "DBCC MEMORYSTATUS" ''');
GO
DECLARE @f BIT = 1
 , @i SMALLINT = 1
 , @m SMALLINT = (SELECT MAX(ID) FROM #tbl_MemoryStatusDump)
 , @CurSet VARCHAR(100)
 , @CurMeasure VARCHAR(20)
 , @Divider TINYINT
 , @CurCounter VARCHAR(100)
 , @CurValue VARCHAR(20);

WHILE @i < @m
BEGIN
 SELECT @Divider = PATINDEX('% %',REVERSE(RTRIM(Dump)))
  , @CurCounter = LEFT(Dump, LEN(Dump) - @Divider)
  , @CurValue = RIGHT(RTRIM(Dump), @Divider - 1)
 FROM #tbl_MemoryStatusDump WHERE ID = @i;

 IF @f = 1 
  SELECT @CurSet = @CurCounter, @CurMeasure = @CurValue, @f = 0 
  FROM #tbl_MemoryStatusDump WHERE ID = @i;
 ELSE IF LEFT(@CurCounter,1) = '(' SET @f = 1;
 ELSE IF @CurCounter != 'NULL' and LEFT(@CurCounter,1) != '-'
  INSERT INTO #tbl_MemoryStatus([DataSet], [Measure], [Counter], [Value])
  SELECT @CurSet, @CurMeasure, @CurCounter, CAST(@CurValue as MONEY)
  FROM #tbl_MemoryStatusDump WHERE ID = @i;
 SET @i += 1;
END
GO
SELECT * FROM #tbl_MemoryStatus
GO

EXEC sp_configure 'xp_cmdshell', 0 ;  
GO  
RECONFIGURE ;  
GO  