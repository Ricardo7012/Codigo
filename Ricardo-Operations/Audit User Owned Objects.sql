-- https://sqlnotesfromtheunderground.wordpress.com/2014/06/18/query-to-find-all-dbs-schemas-jobs-objects-owned-by-users-on-an-instance/

/*

Query to Audit User Owned Objects

-- List all Databases owned by a user
-- List all Agent Jobs owned by a user
-- List all Packages owned by a user
-- List all Scheams owned by a user
-- List all Objects owned by a user

-- Edit
		Added logic to test for if SQL version is lower than 2008 for SSIS packages
		Fixed variable issue
		Changed If logic from IF 2008 > stop to only check at SSIS package
		Use sys.databases to clean up working iwth 2005. 2008 2012 instances

*/
IF OBJECT_ID('tempdb..#ownerTable') IS NOT NULL
    DROP TABLE #ownerTable
CREATE TABLE #ownerTable
    (
      [Issue] VARCHAR(100) ,
      [Database] VARCHAR(200) ,
      [Object] VARCHAR(200) ,
      [ObjectType] VARCHAR(200) ,
      [Owner] VARCHAR(200)
    )

/*
-- List all Non SA Database Owners
---------------------------------------------------------------------------------------------------------------------- */
INSERT  INTO #ownerTable
        ( [Issue] ,
          [Database] ,
          [Owner]
        )
        SELECT  'Database Owned by a User' ,
                name AS 'Name' ,
                SUSER_SNAME(owner_sid) AS 'Owner'
        FROM    sys.databases
        WHERE   SUSER_SNAME(owner_sid) <> 'sa';

/*
-- List all Non SA Job Owners
---------------------------------------------------------------------------------------------------------------------- */
INSERT  INTO #ownerTable
        ( [Issue] ,
          [Database] ,
          [Object] ,
          [Owner]
        )
        SELECT  'Agent Job Owned by a User' ,
                'msdb' ,
                s.name AS 'Job Name' ,
                l.name AS ' Owner'
        FROM    msdb..sysjobs s
                LEFT JOIN master.sys.syslogins l ON s.owner_sid = l.sid
        WHERE   l.name <> 'sa';

/*
-- List all Non SA Package Owners
---------------------------------------------------------------------------------------------------------------------- */

DECLARE @v INT
SET @v = CONVERT(INT, LEFT(CONVERT(VARCHAR(MAX), SERVERPROPERTY('ProductVersion')),
                           CONVERT(INT, CHARINDEX('.',
                                                  CONVERT(VARCHAR(MAX), SERVERPROPERTY('ProductVersion'))))
                           - 1))

IF ( @v >= 10 )
    BEGIN
        INSERT  INTO #ownerTable
                ( [Issue] ,
                  [Database] ,
                  [Object] ,
                  [ObjectType] ,
                  [Owner]
                )
                SELECT  'SSIS Packages Owned by a User' ,
                        'msdb' ,
                        s.name AS 'object' ,
                        'Maintenance Plan' ,
                        l.name AS 'Owner'
                FROM    msdb..sysssispackages s
                        LEFT JOIN master.sys.syslogins l ON s.ownersid = l.sid
                WHERE   l.name <> 'sa'
                        OR l.name IS NULL;
    END
ELSE
    BEGIN
        INSERT  INTO #ownerTable
                ( [Issue] ,
                  [Database] ,
                  [Object] ,
                  [ObjectType] ,
                  [Owner]
                )
                SELECT  'SSIS Packages Owned by a User' ,
                        'msdb' ,
                        s.name ,
                        'Maintenance Plan' ,
                        l.name
                FROM    [msdb].[dbo].[sysdtspackages90] AS s
                        LEFT JOIN sysusers l ON s.ownersid = l.sid
                WHERE   l.name <> 'sa'
                        OR l.name IS NULL

    END

/*
-- List all Schemas owned by Users
---------------------------------------------------------------------------------------------------------------------- */
DECLARE @DB_NameSch VARCHAR(100)
DECLARE @CommandSch NVARCHAR(MAX)
DECLARE database_cursor CURSOR
FOR
    SELECT  name
    FROM    sys.databases
	WHERE state_desc = 'ONLINE' AND user_access_desc = 'MULTI_USER'

OPEN database_cursor

FETCH NEXT FROM database_cursor INTO @DB_NameSch

WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT  @CommandSch = 'USE [' + @DB_NameSch + '] SELECT ' + ''''
                + 'Schema Owned by a User' + '''' + ', ' + '''' + @DB_NameSch
                + ''''
                + ' as [DatabaseName], name as ''Schema'' , USER_NAME(principal_id) AS ''Owner'' FROM sys.schemas
				WHERE name NOT IN (''TargetServersRole'', ''SQLAgentUserRole'', ''SQLAgentReaderRole'', ''SQLAgentOperatorRole'', ''DatabaseMailUserRole''
, ''db_ssisadmin'', ''db_ssisltduser'', ''db_ssisoperator'', ''RSExecRole'')
AND schema_id > 4
AND schema_id < 16384 AND principal_id <> 1
'
       -- PRINT @CommandSch
		-- List all Non SA Package Owners
        INSERT  INTO #ownerTable
                ( [Issue] ,
                  [Database] ,
                  [Object] ,
                  [Owner]
                )
                EXEC sp_executesql @CommandSch

        FETCH NEXT FROM database_cursor INTO @DB_NameSch
    END

CLOSE database_cursor
DEALLOCATE database_cursor

/*
-- Objects Owned by User
---------------------------------------------------------------------------------------------------------------------- */

DECLARE @DB_NameObj VARCHAR(100)
DECLARE @CommandObj NVARCHAR(MAX)
DECLARE database_cursor CURSOR
FOR
    SELECT  name
    FROM    sys.databases
	WHERE state_desc = 'ONLINE' AND user_access_desc = 'MULTI_USER'

OPEN database_cursor

FETCH NEXT FROM database_cursor INTO @DB_NameObj

WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT  @CommandObj = 'USE [' + @DB_NameObj
                + '] ;
WITH    objects_cte
          AS ( SELECT   o.name ,
                        o.type_desc ,
                        CASE WHEN o.principal_id IS NULL THEN s.principal_id
                             ELSE o.principal_id
                        END AS principal_id
               FROM     sys.objects o
                        INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
               WHERE    o.is_ms_shipped = 0
                        AND o.type IN ( ''U'', ''FN'', ''FS'', ''FT'', ''IF'', ''P'', ''PC'',
                                        ''TA'', ''TF'', ''TR'', ''V'' )
             )
    SELECT 	''Object Owned by User'',
    DB_NAME() AS ''Database'',
	cte.name AS ''Object'',
    cte.type_desc AS ''ObjectType'',
    dp.name AS ''Owner''
    FROM    objects_cte cte
            INNER JOIN sys.database_principals dp ON cte.principal_id = dp.principal_id
    WHERE   dp.name NOT IN ( ''dbo'', ''cdc'');'
        -- PRINT @CommandObj
		-- List all Non SA Package Owners
        INSERT  INTO #ownerTable
                ( [Issue] ,
                  [Database] ,
                  [Object] ,
                  [ObjectType] ,
                  [Owner]
                )
                EXEC sp_executesql @CommandObj

        FETCH NEXT FROM database_cursor INTO @DB_NameObj
    END

CLOSE database_cursor
DEALLOCATE database_cursor

/*
-- Show results
---------------------------------------------------------------------------------------------------------------------- */
SELECT  *
FROM    #ownerTable;

-- drop table
DROP TABLE #ownerTable;

--CHANGE DATABASE OWNER
--USE HSP_Prime
--GO

--EXEC sp_changedbowner 'HSP_dbo'

--ALTER AUTHORIZATION ON SCHEMA::db_owner TO db_owner;

--UPDATE  msdb.dbo.sysssispackages
--SET     [ownersid] = SUSER_SID('_system_admin')
--WHERE   [name] = 'IEHP_AdhocBAKCleanup' 

--ALTER AUTHORIZATION ON OBJECT::uu_LoadClaimCheckServiceAssembly TO dbo;
--GO

--EXEC sp_changeobjectowner 'IEHP_Batch', '_system_admin';  
--GO  