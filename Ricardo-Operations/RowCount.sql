USE HSP_RPT


SET STATISTICS TIME ON
SET STATISTICS IO ON 

DECLARE @tablename AS varchar(50) = 'MemberAidCodes'


--1--THE WAY THE SQL MANAGEMENT STUDIO COUNTS ROWS (LOOK AT TABLE PROPERTIES, STORAGE, ROW COUNT). VERY FAST, BUT STILL AN APPROXIMATE NUMBER OF ROWS.
SELECT tbl.name,
       CAST(p.rows AS FLOAT) AS Row_Count
FROM sys.tables AS tbl
    INNER JOIN sys.indexes AS idx
        ON idx.object_id = tbl.object_id
           AND idx.index_id < 2
    INNER JOIN sys.partitions AS p
        ON p.object_id = CAST(tbl.object_id AS INT)
           AND p.index_id = idx.index_id
WHERE ((
    tbl.name = @tablename
    AND 
    SCHEMA_NAME(tbl.schema_id) = 'dbo'
       ))

--2--FAST WAY TO RETRIEVE ROW COUNT. DEPENDS ON STATISTICS AND IS INACCURATE.
--RUN DBCC UPDATEUSAGE(DATABASE) WITH COUNT_ROWS, WHICH CAN TAKE SIGNIFICANT TIME FOR LARGE TABLES.
SELECT CONVERT(BIGINT, rows)
FROM sysindexes
WHERE id = OBJECT_ID(@tablename)
      AND indid < 2

--3--QUICK (ALTHOUGH NOT AS FAST AS METHOD 2) OPERATION AND EQUALLY IMPORTANT, RELIABLE.
SELECT SUM(row_count)
FROM sys.dm_db_partition_stats
WHERE object_id = OBJECT_ID(@tablename)
      AND
      (
          index_id = 0
          OR index_id = 1
      )


--4--PERFORMS A FULL TABLE SCAN. SLOW ON LARGE TABLES. SLOWWWWW!
SELECT COUNT(*) FROM dbo.MemberAidCodes

SET STATISTICS TIME OFF
SET STATISTICS IO OFF
