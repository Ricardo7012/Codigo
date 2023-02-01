USE master
GO

SET NOCOUNT ON
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
