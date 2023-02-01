-- =========================================  
-- #1 Enable Database for CDC template   
-- =========================================
USE HSP_IT_SB;
GO
EXEC sys.sp_cdc_enable_db; 
GO
-- =========================================
-- Disable Database for Change Data Capture template   
-- =========================================
USE HSP_IT_SB;  
GO  
EXEC sys.sp_cdc_disable_db;  
GO  
USE HSP_QA1;  
GO  
EXEC sys.sp_cdc_disable_db;  
GO  

-- =========================================
-- #2 Enable TABLE(S) for CDC    
-- ========================================= 
USE HSP_IT_SB;  
GO  
EXECUTE sys.sp_cdc_enable_table @source_schema = N'dbo',
    @source_name = N'Members', @role_name = NULL;  
GO  

EXECUTE sys.sp_cdc_enable_table @source_schema = N'dbo',
    @source_name = N'MemberCoverages', @role_name = NULL;  
GO  
-- ========================================= 
-- #3 CONFIRM RETENTION   
-- ========================================= 
-- http://www.onlineconversion.com/time.htm 
-- DEFAULT IS 4320 MINUTES 1 DAY =1440
SELECT  [retention]
FROM    [msdb].[dbo].[cdc_jobs]
WHERE   [database_id] = DB_ID()
        AND [job_type] = 'cleanup';


--CHANGE RETENTION IF NEEDED
EXEC sp_cdc_change_job @job_type = 'cleanup', @retention = 1440;
GO


SELECT  *
FROM    [HSP].[cdc].[captured_columns];
SELECT  *
FROM    [HSP_MO].cdc.change_tables;
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  *
FROM    [HSP].[cdc].[dbo_Members_CT];
SELECT  *
FROM    [HSP].[cdc].[dbo_MemberCoverages_CT];
SELECT  *
FROM    [HSP].[cdc].[ddl_history];
SELECT  *
FROM    [HSP].[cdc].[index_columns];
SELECT  *
FROM    [HSP].[cdc].[lsn_time_mapping];

USE HSP;
GO

DECLARE @begin_time DATETIME
   ,@end_time DATETIME
   ,@begin_lsn BINARY(10)
   ,@end_lsn BINARY(10);

SET @begin_time = '2017-02-23 16:00:00.000';
SET @end_time = '2017-02-24 17:00:00.000';

SELECT  @begin_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than',
                                                @begin_time);

SELECT  @end_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal',
                                              @end_time);

SELECT  *
FROM    cdc.fn_cdc_get_all_changes_dbo_Providers(@begin_lsn, @end_lsn, N'all');

USE HSP;  
GO  
DECLARE @from_lsn BINARY(10)
   ,@to_lsn BINARY(10)
   ,@VacationHoursOrdinal INT
   ,@FirstName INT
   ,@NPI INT
   ,@MedicareID INT
   ,@BeginTime DATETIME
   ,@EndTime DATETIME;

SET @BeginTime = '2017-02-27 12:00:00.000';
SET @EndTime = '2017-02-27 16:00:00.000';   
SET @from_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @BeginTime);  
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal',
                                         @EndTime);  
SET @VacationHoursOrdinal = sys.fn_cdc_get_column_ordinal('dbo_Providers',
                                                          'LastName'); 
SET @NPI = sys.fn_cdc_get_column_ordinal('dbo_Providers', 'NPI');
SET @FirstName = sys.fn_cdc_get_column_ordinal('dbo_Providers', 'FirstName');  
SET @MedicareID = sys.fn_cdc_get_column_ordinal('dbo_Providers', 'MedicaidID');  
SELECT  __$start_lsn
       ,sys.fn_cdc_is_bit_set(@VacationHoursOrdinal, __$update_mask) AS 'LastName'
       ,LastName
       ,sys.fn_cdc_is_bit_set(@FirstName, __$update_mask) AS 'FirstName'
       ,FirstName
       ,sys.fn_cdc_is_bit_set(@NPI, __$update_mask) AS 'NPI'
       ,NPI
       ,sys.fn_cdc_is_bit_set(@MedicareID, __$update_mask) AS 'MedicaidID'
       ,MedicaidId
       ,__$operation
       ,CASE __$operation
          WHEN 1 THEN 'Delete'
          WHEN 2 THEN 'Insert'
          WHEN 3 THEN 'Update - Pre'
          WHEN 4 THEN 'Update - Post'
        END AS Operation
       ,LastUpdatedAt
       ,LastUpdatedBy
FROM    cdc.fn_cdc_get_all_changes_dbo_Providers(@from_lsn, @to_lsn,
                                                 'all update old')
WHERE   [__$operation] <> 2
ORDER BY [__$start_lsn]; 

GO


--CHECK WHAT DATABASES IT IS TURNED ON 
DECLARE @sql1 VARCHAR(1000);
DECLARE @sql2 VARCHAR(1000); 
SET @sql2 = 'SELECT  db_name() as dbname, 
		s.name AS Schema_Name ,
        tb.name AS Table_Name ,
        tb.object_id ,
        tb.type ,
        tb.type_desc ,
        tb.is_tracked_by_cdc
FROM    sys.tables tb
        INNER JOIN sys.schemas s ON s.schema_id = tb.schema_id
WHERE   tb.is_tracked_by_cdc = 1;';

SELECT  @sql1 = 'USE [?]
IF ''?'' <> ''master'' AND ''?'' <> ''model'' AND ''?'' <> ''msdb'' AND ''?'' <> ''tempdb'' AND ''?'' <> ''HSPLicensing''
BEGIN
USE [?] 
' + @sql2 + 'END';
EXEC sp_MSforeachdb @sql1; 
PRINT @sql1; 
PRINT @sql2;



-- RESTORING A SQL SERVER DATABASE THAT USES CHANGE DATA CAPTURE
-- https://www.mssqltips.com/sqlservertip/2421/restoring-a-sql-server-database-that-uses-change-data-capture/
--RESTORING ON A DIFFERENT INSTANCE WITH SAME DATABASE NAME
RESTORE DATABASE HSP FROM DISK = N'C:\HSP.bak', KEEP_CDC
WITH 
	FILE = 1, 
	NOUNLOAD, 
	REPLACE, 
	STATS = 5;
GO

USE HSP_IT_SB;
EXEC sys.sp_cdc_add_job 'capture';
GO
EXEC sys.sp_cdc_add_job 'cleanup';
GO

SELECT [database_id]
      ,[job_type]
      ,[job_id]
      ,[maxtrans]
      ,[maxscans]
      ,[continuous]
      ,[pollinginterval]
      ,[retention]
      ,[threshold]
  FROM [msdb].[dbo].[cdc_jobs]


  -- 05092017 HSP3S1A 
  -- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sys-sp-cdc-enable-table-transact-sql

USE HSP_IT_SB;  
GO  
EXEC sys.sp_cdc_disable_db;  
GO  
EXEC sys.sp_cdc_enable_db
GO
EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'dbo'  
  , @source_name =  'MemberCoverages'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  0   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  --, @captured_column_list =  NULL   
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO
SELECT * FROM cdc.change_tables
GO


EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'dbo'  
  , @source_name =  'BenefitCoverages'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  0   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  --, @captured_column_list =  ''  
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO
SELECT * FROM cdc.change_tables
GO

USE HSP_QA1
GO
EXEC sys.sp_cdc_disable_db;  
GO  
EXEC sys.sp_cdc_enable_db
GO
EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'dbo'  
  , @source_name =  'BenefitCoverages'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  1   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  --, @captured_column_list =  ''  
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO
SELECT * FROM cdc.change_tables
GO


EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'dbo'  
  , @source_name =  'MemberCoverages'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  1   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  --, @captured_column_list =  NULL   
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO
SELECT * FROM cdc.change_tables
GO


USE HSP_IT_SB
GO
SELECT * FROM cdc.change_tables
GO
USE HSP_QA1
GO
SELECT * FROM cdc.change_tables
GO


SELECT * FROM cdc.change_tables

-- https://docs.microsoft.com/en-us/sql/relational-databases/track-changes/administer-and-monitor-change-data-capture-sql-server

-- =====  
-- Disable a Capture Instance for a Table template   
-- =====  
USE Diam_725_App  
GO  
EXEC sys.sp_cdc_disable_table  
@source_schema = N'diamond',  
@source_name   = N'JAFFILM0_DAT',  
@capture_instance = N'diamond_JAFFILM0_DAT'  
GO  

GO
EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'diamond'  
  , @source_name =  'JAFFILM0_DAT'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  1   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  , @captured_column_list = 'INSUBNO, INPERSNO, INAFFILCD, INEFFDT, INTERMDT'  
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO

-- TWO SERVERS ENABLED FOR CDC 
--USE HSP_MO	--HSP2S1A
--GO
USE HSP_MO	--HSP4S1A
GO

--08-20-2017
-- =========================================  
-- #1 Enable Database for CDC template   
-- =========================================
EXEC sys.sp_cdc_enable_db; 
GO
SELECT * FROM cdc.change_tables
GO

-- =========================================
-- Disable Database for Change Data Capture template   
-- =========================================
--DROP USER [cdc]
--GO

--EXEC sys.sp_cdc_disable_db;  
--GO  

-- =========================================
-- #2 Enable TABLE(S) for CDC    
-- ========================================= 
EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'dbo'  
  , @source_name =  'BenefitCoverages'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  0   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  --, @captured_column_list =  ''  
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO
--SELECT * FROM cdc.change_tables
--GO


EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'dbo'  
  , @source_name =  'MemberCoverages'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  0   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  --, @captured_column_list =  NULL   
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO
SELECT * FROM cdc.change_tables
GO
-- ========================================= 
-- #3 CONFIRM RETENTION   
-- ========================================= 
-- http://www.onlineconversion.com/time.htm 
-- DEFAULT IS 4320 MINUTES 1 DAY =1440
SELECT  [retention]
FROM    [msdb].[dbo].[cdc_jobs]
WHERE   [database_id] = DB_ID()
        AND [job_type] = 'cleanup';


--CHANGE RETENTION IF NEEDED
EXEC sp_cdc_change_job @job_type = 'cleanup', @retention = 1440;
GO
