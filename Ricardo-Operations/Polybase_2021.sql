-- CONFIGURE POLYBASE TO ACCESS EXTERNAL DATA IN HADOOP
-- CREATE A MASTER KEY ON THE DATABASE, IF ONE DOES NOT ALREADY EXIST. THIS IS REQUIRED TO ENCRYPT THE CREDENTIAL SECRET.
 
SELECT *
FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
 
-- Values map to various external data sources.  
-- Example: value 7 stands for Hortonworks HDP 2.1 to 2.6 on Linux,
-- 2.1 to 2.3 on Windows Server, and Azure blob storage  
EXEC sp_configure @configname = 'polybase enabled', @configvalue = 1;
GO
RECONFIGURE
EXEC sp_configure @configname = 'allow polybase export', @configvalue = 1; 
GO
RECONFIGURE
EXEC sp_configure @configname = 'polybase network encryption', @configvalue = 1;
GO
RECONFIGURE
GO
EXEC sp_configure @configname = 'hadoop connectivity', @configvalue = 7;
GO
RECONFIGURE
GO
SELECT *
FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
 
-- https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-hadoop?view=sql-server-ver15 
--YOU MUST RESTART SQL SERVER USING SERVICES.MSC. RESTARTING SQL SERVER RESTARTS THESE SERVICES:
 
SELECT *
FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
 
 
--CREATE A MASTER KEY ON THE DATABASE, IF ONE DOES NOT ALREADY EXIST. THIS IS REQUIRED TO ENCRYPT THE CREDENTIAL SECRET.
SELECT NEWID()

USE PolybaseDev
go
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '206CEFDB-ACCB-426E-9B38-06EAC3E71C36';  
SELECT * FROM sys.certificates
SELECT * FROM sys.symmetric_keys
--DROP MASTER KEY
 
--Is the password that is used to encrypt the master key in the database. password must meet the Windows password policy requirements of the computer that is hosting the instance of SQL Server.
 
--CREATE A DATABASE SCOPED CREDENTIAL FOR KERBEROS-SECURED HADOOP CLUSTERS.
 
 
SELECT * from sys.database_scoped_credentials
GO
-- IDENTITY: the Kerberos user name.  
-- SECRET: the Kerberos password  
USE PolybaseDev
go
CREATE DATABASE SCOPED CREDENTIAL rootusr
WITH IDENTITY = 'root', Secret = 'Letmein99!!';  
 
CREATE DATABASE SCOPED CREDENTIAL hdfs
WITH IDENTITY = 'hdfs', Secret = '';  
 
SELECT * from sys.database_scoped_credentials
GO
--DROP DATABASE SCOPED CREDENTIAL rootusr1;  
--GO  

SELECT * FROM sys.external_data_sources
GO 
USE [PolybaseDev]
GO
--Create an external data source with CREATE EXTERNAL DATA SOURCE.
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=sql-server-ver15
-- LOCATION (Required) : Hadoop Name Node IP address and port.  
-- RESOURCE MANAGER LOCATION (Optional): Hadoop Resource Manager location to enable pushdown computation.  
-- CREDENTIAL (Optional):  the database scoped credential, created above.  
CREATE EXTERNAL DATA SOURCE PVDATLAK01 WITH (  
      TYPE = HADOOP,
      -- [root@name01 ~]# hdfs getconf -confKey fs.default.name
	  LOCATION ='hdfs://pvlakamb01.iehp.local:8020',
	  -- IN AMBARI GO TO YARN > CONFIGS > ADVANCED > ADVANCED YARN-SITE > yarn.resourcemanager.address
	  RESOURCE_MANAGER_LOCATION = 'pvlakamb01.iehp.local:8050',
      CREDENTIAL = hdfs
);  
GO
SELECT * FROM sys.external_data_sources
GO
 

SELECT * FROM sys.external_file_formats
GO 
USE [PolybaseDev]
GO
-- CREATE AN EXTERNAL FILE FORMAT 
-- FORMAT TYPE: Type of format in Hadoop (DELIMITEDTEXT,  RCFILE, ORC, PARQUET).
CREATE EXTERNAL FILE FORMAT CSV WITH 
	(  
      FORMAT_TYPE = DELIMITEDTEXT, --[ PARQUET | ORC | RCFILE | DELIMITEDTEXT] Specifies the format of the external data.
	FORMAT_OPTIONS (
		--first_row = '2',
		field_terminator =',',
		string_delimiter ='"',
		date_format = 'MM/dd/yyyy',
		use_type_default = True,
		encoding = 'UTF8'
	)
	)
GO
SELECT * FROM sys.external_file_formats
GO

SELECT * FROM sys.external_tables
GO

USE [PolybaseDev]
GO
-- CREATE AN EXTERNAL TABLE POINTING TO DATA STORED IN HADOOP WITH CREATE EXTERNAL TABLE. IN THIS EXAMPLE, THE EXTERNAL DATA CONTAINS CAR SENSOR DATA.
-- LOCATION: path to file or directory that contains the data (relative to HDFS root).  
-- 
CREATE EXTERNAL TABLE [dbo].[CrimeData2020]
(
		[DR_NO] varchar(11) NULL,
		[Date Rptd] varchar(20) NULL,
		[DATE OCC] varchar(20) NULL,
		[TIME OCC] varchar(4) NULL,
		[AREA] varchar(3) NULL,
		[AREA NAME] varchar(50) NULL,
		[Rpt Dist No] varchar(5) NULL,
		[Part 1-2] varchar(2) NULL,
		[Crm Cd] varchar(4) NULL,
		--[Crm Cd Desc] varchar(25) NULL,
		[Mocodes] varchar(50) NULL,
		[Vict Age] varchar(3) NULL,
		[Vict Sex] varchar(1) NULL,
		[Vict Descent] varchar(1) NULL,
		[Premis Cd] varchar(4) NULL,
		--[Premis Desc] varchar(50) NULL,
		[Weapon Used Cd] varchar(3) NULL,
		--[Weapon Desc] varchar(50) NULL,
		[Status] varchar(2) NULL,
		[Status Desc] varchar(12) NULL,
		[Crm Cd 1] varchar(4) NULL,
		[Crm Cd 2] varchar(4) NULL,
		[Crm Cd 3] varchar(4) NULL,
		[Crm Cd 4] varchar(4) NULL,
		[LOCATION] varchar(50) NULL,
		[Cross Street] varchar(50) NULL,
		[LAT] varchar(12) NULL,
		[LON] varchar(12) NULL
)
WITH (
	DATA_SOURCE = [PVDATLAK01]
	,LOCATION = N'/data/staged_dev/crimedata/'
	,FILE_FORMAT = CSV 
	,REJECT_TYPE = VALUE
	,REJECT_VALUE = 0
	)
GO

SELECT * FROM sys.external_tables -- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/external-operations-catalog-views-transact-sql?view=sql-server-ver15
GO
 
--CREATE STATISTICS ON AN EXTERNAL TABLE.
CREATE STATISTICS StatsForCrime on CrimeData2020([DR_NO])  
GO
PRINT 'STATS DONE'
GO
 
/*************************************************************************
TEST
*************************************************************************/
SELECT * FROM [PolybaseDev].[dbo].[CrimeData2020] ORDER BY [Date Rptd] DESC 
GO

 
SELECT * FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
SELECT * FROM sys.certificates
SELECT * FROM sys.symmetric_keys
SELECT * FROM sys.database_scoped_credentials
 
SELECT * FROM sys.external_data_sources;   
SELECT * FROM sys.external_file_formats;  
SELECT * FROM sys.external_tables;  
 

-- PolyBase data movement log files:
--    __Dms_errors.log
--    __Dms_movement.log

--PolyBase engine service log files:
--    __DWEngine_errors.log
--    __DWEngine_movement.log
--    __DWEngine_server.log

--In Windows, PolyBase Java log files:
--    Dms polybase.log
--    _DWEngine_polybase.log

--In Linux, PolyBase Java log files:
--    /var/opt/mssql-extensibility/hdfs_bridge/log/hdfs_bridge_pdw.log
--    /var/opt/mssql-extensibility/hdfs_bridge/log/hdfs_bridge_dms.log
