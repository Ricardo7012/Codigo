USE Pharmacy; 
GO
SET NOCOUNT OFF;
DECLARE @SQL VARCHAR(MAX); 

CREATE TABLE #TMP
    (
      Clmn VARCHAR(500) ,
      Val VARCHAR(50)
    ); 

SELECT  @SQL = COALESCE(@SQL, '')
        + CAST('INSERT INTO #TMP Select ''' + TABLE_SCHEMA + '.' + TABLE_NAME
        + '.' + COLUMN_NAME + ''' AS Clmn, '''' FROM ' + TABLE_SCHEMA + '.['
        + TABLE_NAME + '];' AS VARCHAR(MAX))
FROM    INFORMATION_SCHEMA.COLUMNS
        JOIN sysobjects B ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = B.name
WHERE    
		TABLE_NAME = 'iehp_pharmacy_providers';
PRINT @SQL; 
EXEC(@SQL); 

SELECT  *
FROM    #TMP; 
DROP TABLE #TMP;

USE Pharmacy; 
GO
SET NOCOUNT OFF;
DECLARE @SQL VARCHAR(MAX); 

CREATE TABLE #TMP
    (
      Clmn VARCHAR(500) ,
      Val VARCHAR(50)
    ); 

SELECT  @SQL = COALESCE(@SQL, '','')
        + CAST('INSERT INTO #TMP Select dbo.iehp_pharmacy_providers.'''+ COLUMN_NAME + ''' AS CLMN, ' 
		+ COUNT(COLUMN_NAME) + '''AS VAL FROM ''' 
		+ 'dbo.[iehp_pharmacy_providers] GROUP BY CLMN ORDER BY VAL DESC;' AS VARCHAR(MAX))
FROM    INFORMATION_SCHEMA.COLUMNS
        JOIN sysobjects B ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = B.name
WHERE    
		TABLE_NAME = 'iehp_pharmacy_providers'
		
PRINT @SQL; 
--EXEC(@SQL); 

--SELECT * FROM #TMP; 
DROP TABLE #TMP;



--USE Pharmacy; 
--GO
--SET NOCOUNT OFF;
--DECLARE @columns TABLE ( clmn VARCHAR(255) );
--INSERT  INTO @columns
--        SELECT  COLUMN_NAME
--        FROM    INFORMATION_SCHEMA.COLUMNS
--        WHERE   TABLE_NAME = 'iehp_pharmacy_providers';

--DECLARE @currentColumn VARCHAR(255);
--DECLARE @statement NVARCHAR(1024);

--WHILE EXISTS ( SELECT   1
--               FROM     @columns )
--    BEGIN
--        SELECT TOP 1
--                @currentColumn = clmn
--        FROM    @columns;
       
--        SET @statement = 'select
--                     count(1) as Count, ' + @currentColumn
--					+ ' from iehp_pharmacy_providers p (nolock) 
--                     group by ' + @currentColumn + ' 
--					 order by count(1) desc';

--        EXECUTE sp_executesql @statement;

--        DELETE  FROM @columns
--        WHERE   clmn = @currentColumn;
--    END;
--SET NOCOUNT ON;


--USE [Pharmacy]
--GO

--SELECT Pharmacy_Name, COUNT(pharmacy_name) CNT
--FROM dbo.IEHP_Pharmacy_Providers (NOLOCK)
--GROUP BY Pharmacy_Name
--ORDER BY CNT DESC

