--SET STATISTICS IO,TIME ON
SELECT 'START', @@ServerName AS SERVERNAME,DB_NAME() AS DATABASENAME, GETDATE() AS DATETIME

IF OBJECT_ID('tempdb..#RebuildHeaps') IS NOT NULL
    DROP TABLE #RebuildHeaps

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @i int
DECLARE @numrows int

CREATE TABLE #RebuildHeaps
(
	  idx smallint Primary Key IDENTITY(1,1)
    , HEAPSQL Varchar(max)
);

INSERT INTO #RebuildHeaps
SELECT 'ALTER TABLE ' + SCH.[name] + '.' + TBL.[name] + ' REBUILD;' 
FROM sys.tables AS TBL
     INNER JOIN sys.schemas AS SCH
         ON TBL.schema_id = SCH.schema_id
     INNER JOIN sys.indexes AS IDX
         ON TBL.object_id = IDX.object_id
            AND IDX.type = 0 -- = Heap

DECLARE @HEAPSQL NVARCHAR(MAX);

--SELECT * FROM #RebuildHeaps ORDER BY idx ASC

SET @i = 1
SET @numrows = (SELECT COUNT(*) FROM #RebuildHeaps);

if @numrows > 0
	WHILE (@i <=(SELECT MAX(idx) FROM #RebuildHeaps))
	BEGIN 
		SET @HEAPSQL = (SELECT HEAPSQL FROM #RebuildHeaps WHERE idx = @i)
		--EXECUTE sp_executesql @HEAPSQL
		PRINT convert(varchar(4),@i) + ' - ' + @HEAPSQL + ' COMPLETED'
		SET @i = @i + 1
	END 
DROP TABLE #RebuildHeaps;


SELECT 'END', @@ServerName AS SERVERNAME,DB_NAME() AS DATABASENAME, GETDATE() AS DATETIME
--SET STATISTICS IO,TIME OFF


/* QUICK CHECK*/

--SELECT 'ALTER TABLE ' + SCH.[name] + '.' + TBL.[name] + ' REBUILD;' 
--FROM sys.tables AS TBL
--     INNER JOIN sys.schemas AS SCH
--         ON TBL.schema_id = SCH.schema_id
--     INNER JOIN sys.indexes AS IDX
--         ON TBL.object_id = IDX.object_id
--            AND IDX.type = 0 -- = Heap
--ORDER BY TBL.name ASC
