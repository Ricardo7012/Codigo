
/***********************************************************************
SINCE ZERTO DOES ITS JOB THIS WONT BE NEEDED. 

DO THIS AS A TEMP MEASURE UNTIL WE HAVE F DRIVE AND SUPPORTING SERVERS AS WELL

DO NOT DO THIS WHEN WE ARE FAILING BACK FROM LV 
************************************************************************/
DECLARE @SQL NVARCHAR(200);
DECLARE @db_name NVARCHAR(200);
 
DECLARE xCursor CURSOR FOR
SELECT name
FROM master.sys.databases
WHERE database_id > 4 -- AND replica_id IS NULL ( ALLWAYS ON )
AND [STATE] = 4
ORDER BY name;
 
OPEN xCursor;
FETCH NEXT FROM xCursor
INTO @db_name;
 
WHILE @@FETCH_STATUS = 0
BEGIN
 
    --ALTER DATABASE [@db_name] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
    ----ALTER DATABASE [@db_name] SET OFFLINE
    --ALTER DATABASE [@db_name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    --DROP DATABASE [@db_name]
 
    FETCH NEXT FROM xCursor
    INTO @db_name;
END;
 
CLOSE xCursor;
DEALLOCATE xCursor;
