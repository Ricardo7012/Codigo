--:CONNECT DVSQLPOL01
/****************************************************************************************

*** EXECUTE(F5) ONE BATCH AT A TIME ***

  https://docs.microsoft.com/en-us/sql/odbc/reference/develop-app/batches-of-sql-statements?view=sql-server-ver15

****************************************************************************************/
-- https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-mongodb?view=sql-server-ver15
USE [master]
GO

/****** CHANGE THE DATABASE NAME GLOBALLY CTRL+H ******/
CREATE DATABASE [iehpwebhook2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'iehpwebhook2', FILENAME = N'E:\Data\iehpwebhook2.mdf' , SIZE = 512MB , MAXSIZE = 1GB, FILEGROWTH = 256MB)
 LOG ON 
( NAME = N'iehpwebhook2_log', FILENAME = N'L:\Log\iehpwebhook2_log.ldf' , SIZE = 256MB , MAXSIZE = 512MB , FILEGROWTH = 126MB)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [iehpwebhook2] SET ANSI_NULL_DEFAULT OFF 
ALTER DATABASE [iehpwebhook2] SET ANSI_NULLS OFF 
ALTER DATABASE [iehpwebhook2] SET ANSI_PADDING OFF 
ALTER DATABASE [iehpwebhook2] SET ANSI_WARNINGS OFF 
ALTER DATABASE [iehpwebhook2] SET ARITHABORT OFF 
ALTER DATABASE [iehpwebhook2] SET AUTO_CLOSE OFF 
ALTER DATABASE [iehpwebhook2] SET AUTO_SHRINK OFF 
ALTER DATABASE [iehpwebhook2] SET AUTO_UPDATE_STATISTICS ON 
ALTER DATABASE [iehpwebhook2] SET CURSOR_CLOSE_ON_COMMIT OFF 
ALTER DATABASE [iehpwebhook2] SET CURSOR_DEFAULT  GLOBAL 
ALTER DATABASE [iehpwebhook2] SET CONCAT_NULL_YIELDS_NULL OFF 
ALTER DATABASE [iehpwebhook2] SET NUMERIC_ROUNDABORT OFF 
ALTER DATABASE [iehpwebhook2] SET QUOTED_IDENTIFIER OFF 
ALTER DATABASE [iehpwebhook2] SET RECURSIVE_TRIGGERS OFF 
ALTER DATABASE [iehpwebhook2] SET  DISABLE_BROKER 
ALTER DATABASE [iehpwebhook2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
ALTER DATABASE [iehpwebhook2] SET DATE_CORRELATION_OPTIMIZATION OFF 
ALTER DATABASE [iehpwebhook2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
ALTER DATABASE [iehpwebhook2] SET PARAMETERIZATION SIMPLE 
ALTER DATABASE [iehpwebhook2] SET READ_COMMITTED_SNAPSHOT OFF 
ALTER DATABASE [iehpwebhook2] SET RECOVERY SIMPLE 
ALTER DATABASE [iehpwebhook2] SET  MULTI_USER 
ALTER DATABASE [iehpwebhook2] SET PAGE_VERIFY CHECKSUM  
ALTER DATABASE [iehpwebhook2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
ALTER DATABASE [iehpwebhook2] SET TARGET_RECOVERY_TIME = 0 SECONDS 
ALTER DATABASE [iehpwebhook2] SET DELAYED_DURABILITY = DISABLED 
ALTER DATABASE [iehpwebhook2] SET ACCELERATED_DATABASE_RECOVERY = ON  
ALTER DATABASE [iehpwebhook2] SET QUERY_STORE = OFF
ALTER DATABASE [iehpwebhook2] SET  READ_WRITE ;
GO
select newid()

USE [iehpwebhook2]
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '206CEFDB-ACCB-426E-9B38-06EAC3E71C36';  
SELECT * FROM sys.symmetric_keys;
GO

CREATE DATABASE SCOPED CREDENTIAL DVMONGOCRED WITH IDENTITY = 'DPOLYBASE01',SECRET='yJ119DQj1voRBJiHHfSo';
GO

--LOCATION= TO CONNECT TO PRIMARY NODE readPreference=primary
create external data source DVMONGO00DS with
	(LOCATION='mongodb://dvmongo02.iehp.local:27017', 
	CONNECTION_OPTIONS = 'replicaSet=rs1; tls=false; ssl=false; readPreference=primary',
	credential=DVMONGOCRED);
GO

-- RUN CHECKS
SELECT * FROM sys.database_scoped_credentials;
GO
SELECT * FROM sys.external_data_sources;
GO
SELECT * FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
GO

/*** SECTION 2 ***/
USE [iehpwebhook2]
GO
CREATE SCHEMA [MongoData];
GO
-- WHEN YOU CREATE AN EXTERNAL TABLE USE MATCHING CASE AND DATATYPE
-- THE TRICK IS TO ERROR IT ONCE TO SEE THE CORRECT COLUMN NAMES AND DATATYPES
-- NOTE: ONLY BRING IN WHAT YOU NEED
USE [iehpwebhook2]
GO
CREATE EXTERNAL TABLE MongoData.eConsultData(
    _id NVARCHAR(100) NOT NULL,
    _t NVARCHAR(20) NULL,
    MessageDeliveryDate DATETIME NULL,
	[ClosedCode_Code] NVARCHAR(20),
	[econsultdata_Dialog_Recipient_Facility_PostalCode] NVARCHAR(MAX)
) 
WITH (
LOCATION='iehpwebhook.econsultdata',
DATA_SOURCE= DVMONGO00DS
);
GO

-- https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-mongodb?view=sql-server-ver15#configure-a-mongodb-external-data-source
-- CREATE STATISTICS
-- WE RECOMMEND CREATING STATISTICS ON EXTERNAL TABLE COLUMNS, ESPECIALLY THE ONES USED FOR JOINS, FILTERS AND AGGREGATES, FOR OPTIMAL QUERY PERFORMANCE.
CREATE STATISTICS _id ON MongoData.eConsultData (_id) WITH FULLSCAN;
GO

--USE [iehpwebhook]
--GO
--DROP STATISTICS [MongoData].[eConsultData].[_id]
--GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SET STATISTICS TIME, IO ON;
GO
SELECT [_id]
      ,[_t]
      ,[MessageDeliveryDate]
      ,[ClosedCode_Code]
	  ,[econsultdata_Dialog_Recipient_Facility_PostalCode] 
  FROM [iehpwebhook2].[MongoData].[eConsultData]
  ORDER BY [MessageDeliveryDate] DESC;
  GO

----The EXECUTE permission WILL BE denied on the object - SEND CODE TO A DBA TO EXECUTE THIS
----EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'iehpwebhook2'
----GO
--USE [master]
--GO
--ALTER DATABASE [iehpwebhook2] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
--GO
--USE [master]
--GO
--DROP DATABASE [iehpwebhook2];
--GO
