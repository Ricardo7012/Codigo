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
-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/polybase-connectivity-configuration-transact-sql?view=sql-server-ver15
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

--CONFIRM VALUE IN USE

--SQL SERVER POLYBASE DATA MOVEMENT SERVICE
--SQL SERVER POLYBASE ENGINE

--FIND THE FILE YARN-SITE.XML IN THE INSTALLATION PATH OF SQL SERVER. TYPICALLY, THE PATH IS:
--C:\PROGRAM FILES\MICROSOFT SQL SERVER\MSSQL13.MSSQLSERVER\MSSQL\BINN\POLYBASE\HADOOP\CONF\  

--ON THE HADOOP MACHINE, FIND THE ANALOGOUS FILE IN THE HADOOP CONFIGURATION DIRECTORY. IN THE FILE, FIND AND COPY THE VALUE OF THE CONFIGURATION 

--KEY YARN.APPLICATION.CLASSPATH.

--ON THE SQL SERVER MACHINE, IN THE YARN-SITE.XML FILE, FIND THE YARN.APPLICATION.CLASSPATH PROPERTY. PASTE THE VALUE FROM THE HADOOP MACHINE INTO THE VALUE ELEMENT.

--FOR ALL CDH 5.X VERSIONS, YOU WILL NEED TO ADD THE MAPREDUCE.APPLICATION.CLASSPATH CONFIGURATION PARAMETERS EITHER TO THE END OF YOUR YARN-SITE.XML FILE OR INTO THE MAPRED-SITE.XML FILE. HORTONWORKS INCLUDES THESE CONFIGURATIONS WITHIN THE YARN.APPLICATION.CLASSPATH CONFIGURATIONS. SEE POLYBASE CONFIGURATION FOR EXAMPLES.

--CONFIGURE AN EXTERNAL TABLE
--TO QUERY THE DATA IN YOUR HADOOP DATA SOURCE, YOU MUST DEFINE AN EXTERNAL TABLE TO USE IN TRANSACT-SQL QUERIES. THE FOLLOWING STEPS DESCRIBE HOW TO CONFIGURE THE EXTERNAL TABLE.

--CREATE A MASTER KEY ON THE DATABASE, IF ONE DOES NOT ALREADY EXIST. THIS IS REQUIRED TO ENCRYPT THE CREDENTIAL SECRET.

USE PolybaseDev
go
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'OPIZXO#$#$%@#$@234234SDFSDFS';  
SELECT * FROM sys.certificates
SELECT * FROM sys.symmetric_keys
--DROP MASTER KEY

--Is the password that is used to encrypt the master key in the database. password must meet the Windows password policy requirements of the computer that is hosting the instance of SQL Server.

--CREATE A DATABASE SCOPED CREDENTIAL FOR KERBEROS-SECURED HADOOP CLUSTERS.


-- IDENTITY: the Kerberos user name.  
-- SECRET: the Kerberos password  
USE PolybaseDev
go
CREATE DATABASE SCOPED CREDENTIAL rootusr1
WITH IDENTITY = 'root', Secret = '#@$2#$EdfgDG';  

SELECT * from sys.database_scoped_credentials
GO
--DROP DATABASE SCOPED CREDENTIAL rootusr1;  
--GO  

USE [PolybaseDev]
GO
--Create an external data source with CREATE EXTERNAL DATA SOURCE.
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=sql-server-ver15
-- LOCATION (Required) : Hadoop Name Node IP address and port.  
-- RESOURCE MANAGER LOCATION (Optional): Hadoop Resource Manager location to enable pushdown computation.  
-- CREDENTIAL (Optional):  the database scoped credential, created above.  
CREATE EXTERNAL DATA SOURCE DVLAKAMB01 WITH (  
      TYPE = HADOOP,	--TYPE = [ HADOOP | BLOB_STORAGE ]
      LOCATION ='hdfs://172.18.204.225:8080',		--- [root@name01 ~]# hdfs getconf -confKey fs.default.name
      RESOURCE_MANAGER_LOCATION = 'name01.iehp.local:50070',	--- IN AMBARI GO TO YARN > CONFIGS > ADVANCED > ADVANCED YARN-SITE > yarn.resourcemanager.address
      CREDENTIAL = rootusr1
);  
GO
SELECT * FROM sys.external_data_sources
GO


USE [PolybaseDev]
GO
--DROP EXTERNAL DATA SOURCE [DVLAKAMB01]
--GO
--DROP EXTERNAL TABLE [dbo].[RicardoTest]
--GO
--DROP EXTERNAL FILE FORMAT [CSV]
--GO

USE [PolybaseDev]
GO
-- CREATE AN EXTERNAL FILE FORMAT 
-- FORMAT TYPE: Type of format in Hadoop (DELIMITEDTEXT,  RCFILE, ORC, PARQUET).
CREATE EXTERNAL FILE FORMAT CSV WITH 
	(  
      FORMAT_TYPE = DELIMITEDTEXT, --[ PARQUET | ORC | RCFILE | DELIMITEDTEXT] Specifies the format of the external data.
		FORMAT_OPTIONS (
			--first_row = 2,
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

USE [PolybaseDev]
GO
-- CREATE AN EXTERNAL TABLE POINTING TO DATA STORED IN HADOOP WITH CREATE EXTERNAL TABLE. IN THIS EXAMPLE, THE EXTERNAL DATA CONTAINS CAR SENSOR DATA.
-- LOCATION: path to file or directory that contains the data (relative to HDFS root).  
CREATE EXTERNAL TABLE [dbo].[RicardoTest]
(
	[DRNumber] [nvarchar](50) NULL,
	[AreaID] [nvarchar](50) NULL,
	[AreaName] [nvarchar](500) NULL,
	[ReportingDistrict] [nvarchar](50)  NULL,
	[CrimeCode] [nvarchar](14)  NULL,
	[CrimeCodeDescription] [nvarchar](500) NULL,
	[VictimAge] [nvarchar](14)  NULL,
	[VictimSex] [nvarchar](14) NULL,
	[VictimDescent] [nvarchar](14) NULL,
	[Location] [nvarchar](50) NULL
)
WITH (
	DATA_SOURCE = [DVLAKAMB01]
	,LOCATION = N'/ricardo/'
	,FILE_FORMAT = CSV 
	,REJECT_TYPE = VALUE
	,REJECT_VALUE = 0
	)
GO
SELECT * FROM sys.external_tables -- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/external-operations-catalog-views-transact-sql?view=sql-server-ver15
GO

--CREATE STATISTICS ON AN EXTERNAL TABLE.
CREATE STATISTICS StatsForCrime on RicardoTest(DRNumber, AreaID)  
GO
PRINT 'STATS DONE'
GO

/*************************************************************************
TEST
*************************************************************************/

USE [PolybaseDev]
GO

SELECT [DRNumber]
      ,[AreaID]
      ,[AreaName]
      ,[ReportingDistrict]
      ,[CrimeCode]
      ,[CrimeCodeDescription]
      ,[VictimAge]
      ,[VictimSex]
      ,[VictimDescent]
      ,[Location]
  FROM [dbo].[RicardoTest]
GO

SELECT * FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
SELECT * FROM sys.certificates
SELECT * FROM sys.symmetric_keys
SELECT * FROM sys.database_scoped_credentials

SELECT * FROM sys.external_data_sources;   
SELECT * FROM sys.external_file_formats;  
SELECT * FROM sys.external_tables;  


CREATE EXTERNAL TABLE [dbo].[CrimeData2020]
(
		[DR_NO] varchar(10) NULL,
		[Date Rptd] datetime NULL,
		[DATE OCC] datetime NULL,
		[TIME OCC] varchar(4) NULL,
		[AREA] varchar(2) NULL,
		[AREA NAME] varchar(50) NULL,
		[Rpt Dist No] varchar(4) NULL,
		[Part 1-2] varchar(2) NULL,
		[Crm Cd] varchar(3) NULL,
		[Crm Cd Desc] varchar(25) NULL,
		[Mocodes] varchar(9) NULL,
		[Vict Age] varchar(3) NULL,
		[Vict Sex] varchar(1) NULL,
		[Vict Descent] varchar(1) NULL,
		[Premis Cd] varchar(3) NULL,
		[Premis Desc] varchar(50) NULL,
		[Weapon Used Cd] varchar(3) NULL,
		[Weapon Desc] varchar(50) NULL,
		[Status] varchar(2) NULL,
		[Status Desc] varchar(50) NULL,
		[Crm Cd 1] varchar(3) NULL,
		[Crm Cd 2] varchar(3) NULL,
		[Crm Cd 3] varchar(3) NULL,
		[Crm Cd 4] varchar(3) NULL,
		[LOCATION] varchar(50) NULL,
		[Cross Street] varchar(50) NULL,
		[LAT] varchar(8) NULL,
		[LON] varchar(8) NULL
)
WITH (
	DATA_SOURCE = [PVDATLAK01_2]
	,LOCATION = N'/data/staged_dev/crimedata/'
	,FILE_FORMAT = CSV 
	,REJECT_TYPE = VALUE
	,REJECT_VALUE = 0
	)
GO