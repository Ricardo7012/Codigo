/******************************************************************************
RAP = Risk assessment program (RAP)

RAP as a Service is a delivery experience to enable you to assess your environment at your convenience. 
The data is collected remotely allowing you to maintain the utmost privacy and run the assessment on your 
own schedule. Submission of data through the cloud and viewing results on our online portal uses encryption 
to help protect your data. This enables you to view your results almost immediately. A Microsoft accredited 
engineer will review the findings, provide recommendations and knowledge transfer, and build a remediation 
plan with your staff and your Technical Account Manager (TAM).

RAP as a Service Plus builds on the standard RAP as a Service delivery experience complemented by a two-day 
follow up onsite visit which will focus on additional knowledge transfer, and building a remediation plan 
with your staff and your Technical Account Manager (TAM).

https://services.premier.microsoft.com/assess?Culture=en-US&CultureAutoDetect=true

RICARDO 6-5-2018

******************************************************************************/


---SQL Logins with passwords same as logins
--HSPL|censing_5@637951 
SELECT SERVERPROPERTY('machinename') AS 'Server Name',
       ISNULL(SERVERPROPERTY('instancename'), SERVERPROPERTY('machinename')) AS 'Instance Name',
       name AS 'Login With Password Same As Name'
FROM master.sys.sql_logins
WHERE pwdcompare(NAME, password_hash) = 1
ORDER BY name
OPTION (MAXDOP 1);

/******************************************************************************
--Database(s) identified with recovery model set to Simple
******************************************************************************/

SELECT name,
       recovery_model_desc
FROM sys.databases
WHERE recovery_model_desc = 'SIMPLE';

/******************************************************************************
Databases identified with auto-growth set to percentage growth
******************************************************************************/
USE master;
GO
SELECT
      database_id, db_name(database_id) AS database_name, name AS Filename,
      growth AS Percentage_growth, CAST((size*8) AS FLOAT) /1024 as DB_Size_in_MB, 
      CAST((size*8*growth) AS FLOAT)/100/1024 as next_growth_in_MB,
      type_desc AS Filetype
FROM sys.master_files
WHERE is_percent_growth=1;
GO

/******************************************************************************
--DATABASES IDENTIFIED WITH ONE OR MORE TABLES, WITH INDEXES THAT MAY REQUIRE UPDATE STATISTICS
******************************************************************************/
DECLARE @Major INT,
        @Minor INT,
        @build INT,
        @revision INT,
        @i INT,
        @str NVARCHAR(100),
        @str2 NVARCHAR(10);

SET @str = CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(100));
SET @str2 = LEFT(@str, CHARINDEX('.', @str));
SET @i = LEN(@str);
SET @str = RIGHT(@str, @i - CHARINDEX('.', @str));
SET @Major = CAST(REPLACE(@str2, '.', '') AS INT);
SET @str2 = LEFT(@str, CHARINDEX('.', @str));
SET @i = LEN(@str);
SET @str = RIGHT(@str, @i - CHARINDEX('.', @str));
SET @Minor = CAST(REPLACE(@str2, '.', '') AS INT);
SET @str2 = LEFT(@str, CHARINDEX('.', @str));
SET @i = LEN(@str);
SET @str = RIGHT(@str, @i - CHARINDEX('.', @str));
SET @build = CAST(REPLACE(@str2, '.', '') AS INT);
SET @revision = CAST(@str AS INT);

IF @Major < 10
    SET @i = 1;

ELSE IF @Major > 10
    SET @i = 0;

ELSE IF @Minor = 50
        AND @build >= 4000
    SET @i = 0;

ELSE
    SET @i = 1;



IF @i = 1
BEGIN

    EXEC sp_executesql N';WITH StatTables AS(
            SELECT     so.schema_id AS ''schema_id'',     
                            so.name  AS ''TableName'',
                so.object_id AS ''object_id'',
                CASE indexproperty(so.object_id, dmv.name, ''IsStatistics'')
                                WHEN 0 THEN dmv.rows
                                ELSE (SELECT TOP 1 row_count FROM sys.dm_db_partition_stats ps (NOLOCK) WHERE ps.object_id=so.object_id AND ps.index_id in (1,0))
                    END AS ''ApproximateRows'',
                     dmv.rowmodctr AS ''RowModCtr''
            FROM sys.objects so (NOLOCK)
                JOIN sysindexes dmv (NOLOCK) ON so.object_id = dmv.id
                LEFT JOIN sys.indexes si (NOLOCK) ON so.object_id = si.object_id AND so.type in (''U'',''V'') AND si.index_id  = dmv.indid
            WHERE so.is_ms_shipped = 0
                AND dmv.indid<>0
                AND so.object_id not in (SELECT major_id FROM sys.extended_properties (NOLOCK) WHERE name = N''microsoft_database_tools_support'')
        ),
        StatTableGrouped AS
        (
        SELECT 
            ROW_NUMBER() OVER(ORDER BY TableName) AS seq1,
            ROW_NUMBER() OVER(ORDER BY TableName DESC) AS seq2,
            TableName,
            cast(Max(ApproximateRows) AS bigint) AS ApproximateRows,
            cast(Max(RowModCtr) AS bigint) AS RowModCtr,
            schema_id,object_id
        FROM StatTables st
        GROUP BY schema_id,object_id,TableName
        HAVING (Max(ApproximateRows) > 500 AND Max(RowModCtr) > (Max(ApproximateRows)*0.2 + 500 ))
        )
        SELECT
            @@SERVERNAME AS InstanceName,
            seq1 + seq2 - 1 AS NbOccurences,
            SCHEMA_NAME(stg.schema_id) AS ''SchemaName'', 
            stg.TableName,
            CASE OBJECTPROPERTY(stg.object_id, ''TableHasClustIndex'')
                           WHEN 1 THEN ''Clustered''
                           WHEN 0 THEN ''Heap''
                           ELSE ''Indexed View''
                     END AS ClusteredHeap,
            CASE objectproperty(stg.object_id, ''TableHasClustIndex'')
                            WHEN 0 THEN (SELECT count(*) FROM sys.indexes i (NOLOCK) where i.object_id= stg.object_id) - 1
                            ELSE (SELECT count(*) FROM sys.indexes i  (NOLOCK) where i.object_id= stg.object_id)
                END AS IndexCount,
            (SELECT count(*) FROM sys.columns c (NOLOCK) WHERE c.object_id = stg.object_id ) AS ColumnCount ,
            (SELECT count(*) FROM sys.stats s (NOLOCK) WHERE s.object_id = stg.object_id) AS StatCount ,
            stg.ApproximateRows,
            stg.RowModCtr,
            stg.schema_id,
            stg.object_id
        FROM StatTableGrouped stg';
END;
ELSE
BEGIN
    EXEC sp_executesql N';WITH StatTables AS(
            SELECT     so.schema_id AS ''schema_id'',     
                            so.name  AS ''TableName'',
                so.object_id AS ''object_id''
                , ISNULL(sp.rows,0) AS ''ApproximateRows''
                , ISNULL(sp.modification_counter,0) AS ''RowModCtr''
            FROM sys.objects so (NOLOCK)
                JOIN sys.stats st (NOLOCK) ON so.object_id=st.object_id
                CROSS APPLY sys.dm_db_stats_properties(so.object_id, st.stats_id) AS sp
            WHERE so.is_ms_shipped = 0
                AND st.stats_id<>0
                AND so.object_id not in (SELECT major_id FROM sys.extended_properties (NOLOCK) WHERE name = N''microsoft_database_tools_support'')
        ),
        StatTableGrouped AS
        (
        SELECT 
            ROW_NUMBER() OVER(ORDER BY TableName) AS seq1,
            ROW_NUMBER() OVER(ORDER BY TableName DESC) AS seq2,
            TableName,
            cast(Max(ApproximateRows) AS bigint) AS ApproximateRows,
            cast(Max(RowModCtr) AS bigint) AS RowModCtr,
            count(*) AS StatCount,
            schema_id,object_id
        FROM StatTables st
        GROUP BY schema_id,object_id,TableName
        HAVING (Max(ApproximateRows) > 500 AND Max(RowModCtr) > (Max(ApproximateRows)*0.2 + 500 ))
        )
        SELECT
            @@SERVERNAME AS InstanceName,
            seq1 + seq2 - 1 AS NbOccurences,
            SCHEMA_NAME(stg.schema_id) AS ''SchemaName'', 
            stg.TableName,
            CASE OBJECTPROPERTY(stg.object_id, ''TableHasClustIndex'')
                           WHEN 1 THEN ''Clustered''
                           WHEN 0 THEN ''Heap''
                           ELSE ''Indexed View''
                     END AS ClusteredHeap,
            CASE objectproperty(stg.object_id, ''TableHasClustIndex'')
                            WHEN 0 THEN (SELECT count(*) FROM sys.indexes i (NOLOCK) where i.object_id= stg.object_id) - 1
                            ELSE (SELECT count(*) FROM sys.indexes i (NOLOCK) where i.object_id= stg.object_id)
                END AS IndexCount,
            (SELECT count(*) FROM sys.columns c (NOLOCK) WHERE c.object_id = stg.object_id ) AS ColumnCount ,
            stg.StatCount,
            stg.ApproximateRows,
            stg.RowModCtr,
            stg.schema_id,
            stg.object_id
        FROM StatTableGrouped stg';
END;

/******************************************************************************
******************************************************************************/
--DATABASES IDENTIFIED WITH AUTO-GROWTH SET TO PERCENTAGE GROWTH
USE master;
GO

SELECT database_id,
       DB_NAME(database_id) AS database_name,
       name AS Filename,
       growth AS Percentage_growth,
       CAST((size * 8) AS FLOAT) / 1024 AS DB_Size_in_MB,
       CAST((size * 8 * growth) AS FLOAT) / 100 / 1024 AS next_growth_in_MB,
       type_desc AS Filetype
FROM sys.master_files
WHERE is_percent_growth = 1;

GO
/******************************************************************************
******************************************************************************/
--Review remote connections using NTLM Authentication
--YOU CAN VERIFY WHICH REMOTE CONNECTIONS ARE USING NTLM WITH THE FOLLOWING QUERy.
SELECT *
FROM sys.dm_exec_connections
WHERE auth_scheme = 'NTLM'
      AND net_transport <> 'Shared Memory';

--YOU CAN ALSO CHECK IF ANY CONNECTION IS ALREADY USING KERBEROS AUTHENTICATION WITH THE FOLLOWING QUERY.
SELECT *
FROM sys.dm_exec_connections
WHERE auth_scheme = 'KERBEROS';

/******************************************************************************
******************************************************************************/
-- SQL SERVER IS NOT USING ALL CPUS AVAILABLE IN THE SYSTEM
SELECT @@SERVERNAME AS SERVERNAME,
       *
FROM sys.dm_os_schedulers;

SELECT SERVERPROPERTY('Edition');
--and you should get the following results:
--Enterprise Edition: Core-based Licensing (64-bit)

/******************************************************************************
******************************************************************************/
-- The Value configured for SQL Server Configuration, Max Degree of parallelism may impact your SQL Server instance performance.

/******************************************************************************
******************************************************************************/
--
SELECT p.name AS [Name]
FROM sys.server_principals r
    INNER JOIN sys.server_role_members m
        ON r.principal_id = m.role_principal_id
    INNER JOIN sys.server_principals p
        ON p.principal_id = m.member_principal_id
WHERE r.type = 'R'
      AND r.name = N'sysadmin';


EXEC msdb..sp_delete_backuphistory 'Nov 4 2009 12:00AM'
EXEC msdb..sp_purge_jobhistory @oldest_date = 'Nov 4 2009 12:00AM'

/******************************************************************************
******************************************************************************/
--APPLICATION EVENT LOG: MSSQLSERVER: 833: SQL SERVER HAS ENCOUNTERED OCCURRENCES OF I/O REQUESTS TAKING LONGER THAN 15 SECONDS TO COMPLETE ON A FILE IN DATABASE.
SELECT SUM(pending_disk_io_count) AS [Number of pending I/Os]
FROM sys.dm_os_schedulers;

SELECT *
FROM sys.dm_io_pending_io_requests;

SELECT DB_NAME(database_id) AS [Database],
       [file_id],
       [io_stall_read_ms],
       [io_stall_write_ms],
       [io_stall]
FROM sys.dm_io_virtual_file_stats(NULL, NULL);

/******************************************************************************
******************************************************************************/
--Non-Default users are provisioned to db_owner database role.
SET NOCOUNT ON;

DECLARE @dbname sysname;

CREATE TABLE #SQLRAP_DBSecurityCheck
(
    DatabaseName sysname,
    UserName sysname,
    RoleName NVARCHAR(10)
);

DECLARE GetTheDatabases CURSOR FOR
SELECT name
FROM master.sys.databases
WHERE state_desc = N'ONLINE'
      AND is_distributor = 0
ORDER BY database_id
OPTION (MAXDOP 1);

OPEN GetTheDatabases;

FETCH NEXT FROM GetTheDatabases
INTO @dbname;

WHILE @@fetch_status = 0
BEGIN

    EXEC ('USE [' + @dbname + '];
            INSERT #SQLRAP_DBSecurityCheck (DatabaseName, UserName, RoleName)
            SELECT db_name(),
                member.name,
                [role].name
                FROM sys.database_principals member
                JOIN sys.database_role_members rm ON member.principal_id = rm.member_principal_id
                JOIN sys.database_principals [role] ON [role].principal_id = rm.role_principal_id
                       AND [role].name in (''dbo'',''db_owner'') AND member.name not in (''db'',''db_owner'')
                WHERE member.name not in (''dbo'')
                ORDER BY member.name, [role].name
                OPTION (MAXDOP 1)');
    FETCH NEXT FROM GetTheDatabases
    INTO @dbname;

END;

CLOSE GetTheDatabases;

DEALLOCATE GetTheDatabases;

SELECT DatabaseName AS 'Database Name',
       UserName AS 'User With Elevated Privilege',
       RoleName AS 'Privilege Held By Credential'
FROM #SQLRAP_DBSecurityCheck
ORDER BY DatabaseName,
         UserName
OPTION (MAXDOP 1);

DROP TABLE #SQLRAP_DBSecurityCheck;
