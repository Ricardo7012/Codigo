/* Publish to PVSQlPOL01
PROD:
	Sql server			- PVSQlPOL01
	Sql database		- ? (Can we name it 'econsultResources', not the file name 'econsult-resources'? (E:\Data\econsult-resources.mdf)
	mongo source		- mongodb://pvmongond01.iehp.local:27017
	      database		- econsult-resources
	      collection	- consult           

	      Mongo connection string from Istvan N. on 11/04/21:
		  "mongodb://econsult-whk-reporting:jspg3eM5KUHmUQXFDEUAKGXcAT55NH3k@pvmongond01.iehp.org:27017/admin?authSource=econsult-resources&replicaSet=rs0&readPreference=nearest&ssl=true"

DEV:
	Sql server			- DVSQlPOL01
	Sql database		- iehpwebhook
	mongo source		- mongodb://dvmongo02.iehp.local:27017
	      database		- iehpwebhook
	      collection	- econsultdata

Created User: Rose Ting
Created Date: 11/05/21
*/

--:CONNECT DVSQLPOL01
/****************************************************************************************

*** EXECUTE(F5) ONE BATCH AT A TIME ***

  https://docs.microsoft.com/en-us/sql/odbc/reference/develop-app/batches-of-sql-statements?view=sql-server-ver15

****************************************************************************************/
-- https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-mongodb?view=sql-server-ver15
USE [master]
GO

/****** CHANGE THE DATABASE NAME GLOBALLY CTRL+H ******/
CREATE DATABASE [econsultResources]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'econsultResources', FILENAME = N'E:\Data\econsult-resources.mdf' , SIZE = 512MB , MAXSIZE = 1GB, FILEGROWTH = 256MB)
 LOG ON 
( NAME = N'econsultResources_log', FILENAME = N'L:\Log\econsult-resources_log.ldf' , SIZE = 256MB , MAXSIZE = 512MB , FILEGROWTH = 126MB)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [econsultResources] SET ANSI_NULL_DEFAULT OFF 
ALTER DATABASE [econsultResources] SET ANSI_NULLS OFF 
ALTER DATABASE [econsultResources] SET ANSI_PADDING OFF 
ALTER DATABASE [econsultResources] SET ANSI_WARNINGS OFF 
ALTER DATABASE [econsultResources] SET ARITHABORT OFF 
ALTER DATABASE [econsultResources] SET AUTO_CLOSE OFF 
ALTER DATABASE [econsultResources] SET AUTO_SHRINK OFF 
ALTER DATABASE [econsultResources] SET AUTO_UPDATE_STATISTICS ON 
ALTER DATABASE [econsultResources] SET CURSOR_CLOSE_ON_COMMIT OFF 
ALTER DATABASE [econsultResources] SET CURSOR_DEFAULT  GLOBAL 
ALTER DATABASE [econsultResources] SET CONCAT_NULL_YIELDS_NULL OFF 
ALTER DATABASE [econsultResources] SET NUMERIC_ROUNDABORT OFF 
ALTER DATABASE [econsultResources] SET QUOTED_IDENTIFIER OFF 
ALTER DATABASE [econsultResources] SET RECURSIVE_TRIGGERS OFF 
ALTER DATABASE [econsultResources] SET  DISABLE_BROKER 
ALTER DATABASE [econsultResources] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
ALTER DATABASE [econsultResources] SET DATE_CORRELATION_OPTIMIZATION OFF 
ALTER DATABASE [econsultResources] SET ALLOW_SNAPSHOT_ISOLATION OFF 
ALTER DATABASE [econsultResources] SET PARAMETERIZATION SIMPLE 
ALTER DATABASE [econsultResources] SET READ_COMMITTED_SNAPSHOT OFF 
ALTER DATABASE [econsultResources] SET RECOVERY SIMPLE 
ALTER DATABASE [econsultResources] SET  MULTI_USER 
ALTER DATABASE [econsultResources] SET PAGE_VERIFY CHECKSUM  
ALTER DATABASE [econsultResources] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
ALTER DATABASE [econsultResources] SET TARGET_RECOVERY_TIME = 0 SECONDS 
ALTER DATABASE [econsultResources] SET DELAYED_DURABILITY = DISABLED 
ALTER DATABASE [econsultResources] SET ACCELERATED_DATABASE_RECOVERY = ON  
ALTER DATABASE [econsultResources] SET QUERY_STORE = OFF
ALTER DATABASE [econsultResources] SET  READ_WRITE ;
GO

--CREATE NEW PASSWORD ADD TO Master key servername.databasename  [PVSQLPOL01].[econsultResources]
--1DB41868-94FB-46D2-89E1-E76061C105D2
SELECT NEWID(); 
GO


USE [econsultResources]
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = ''   --set password
SELECT * FROM sys.symmetric_keys;
GO

/*1) Create a database scoped credential for accessing the MongoDB source.*/
-- Need to request SECRET (for user 'PPOLYBASE01' or 'econsult-whk-reporting'?) from John S./Istvan N.
-- See MONGODB PRE-REQ below 
CREATE DATABASE SCOPED CREDENTIAL PVMONGOCRED WITH IDENTITY = 'PPOLYBASE01',SECRET='';	 
GO

--CREATE DATABASE SCOPED CREDENTIAL PVMONGOCRED WITH IDENTITY = 'econsult-whk-reporting',SECRET='jspg3eM5KUHmUQXFDEUAKGXcAT55NH3k'; --just an example
/* MONGODB PRE-REQ - PROD
--econsult-resources.consult
 db.createUser(
{​​​​​​​​   user: "{econsult-whk-reporting",    
    pwd: "jspg3eM5KUHmUQXFDEUAKGXcAT55NH3k",
    roles:[{​​​​​​​​role: "read" , db:"econsult-resources"}​​​​​​​​]}​​​​​​​​)
*/

--CREATE DATABASE SCOPED CREDENTIAL DVMONGOCRED WITH IDENTITY = 'DPOLYBASE01',SECRET='yJ119DQj1voRBJiHHfSo';  --DEV
/* MONGODB PRE-REQ - DEV
--iehpwebhook.econsultdata
 db.createUser(
{​​​​​​​​   user: "DPOLYBASE01",    
    pwd: "yJ119DQj1voRBJiHHfSo",
    roles:[{​​​​​​​​role: "read" , db:"iehpwebhook"}​​​​​​​​]}​​​​​​​​)
*/
GO



/* 2) Create an external data source
--LOCATION= TO CONNECT TO PRIMARY NODE readPreference=primary  */

--Mongo Production connection string from Istvan N. on 11/4/21:
--  "mongodb://econsult-whk-reporting:jspg3eM5KUHmUQXFDEUAKGXcAT55NH3k@pvmongond01.iehp.org:27017/admin?authSource=econsult-resources&replicaSet=rs0&readPreference=nearest&ssl=true”

--PROD
create external data source PVMONGO00DS with
	(LOCATION='mongodb://pvmongond01.iehp.org:27017', 
	CONNECTION_OPTIONS = 'replicaSet=rs0; ssl=true; readPreference=primary',
	credential=PVMONGOCRED);
--Dev
--create external data source DVMONGO00DS with
--	(LOCATION='mongodb://dvmongo02.iehp.local:27017', 
--	CONNECTION_OPTIONS = 'replicaSet=rs1; tls=false; ssl=false; readPreference=primary',
--	credential=DVMONGOCRED);
GO

-- RUN CHECKS
SELECT * FROM sys.database_scoped_credentials;
GO
SELECT * FROM sys.external_data_sources;
GO
SELECT * FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
GO
 

 
/*** SECTION 2 ***/
USE [econsultResources]
GO
CREATE SCHEMA [MongoData];
GO
-- WHEN YOU CREATE AN EXTERNAL TABLE USE MATCHING CASE AND DATATYPE
-- THE TRICK IS TO ERROR IT ONCE TO SEE THE CORRECT COLUMN NAMES AND DATATYPES
-- NOTE: ONLY BRING IN WHAT YOU NEED
USE [econsultResources]
GO
/**********************************************
(1) PARENT TABLE
--BEGIN tran
--DROP EXTERNAL TABLE MongoData.eConsult
--COMMIT;
***********************************************/
CREATE EXTERNAL TABLE MongoData.eConsult(
    _id NVARCHAR(24) NOT NULL,
    _t NVARCHAR(20) NULL,
    MessageDeliveryDate DATETIME NULL,
	AddNotes NVARCHAR(MAX) NULL,
	ClinicalQuestion NVARCHAR(MAX) NULL,
	ClosedCode_Code NVARCHAR(20) NULL,
	ClosedCode_Text NVARCHAR(50) NULL,
	ClosedCode_Urgency NVARCHAR(50) NULL,
 	ClosedDate DATETIME NULL,
	CreatedDate DATETIME NULL,
	DialogRequired BIT, 
	EConsultId BIGINT,
	Patient_DateOfBirth DATETIME NULL,
	Patient_FirstName NVARCHAR(50) NULL,
	Patient_Gender INT NULL,
	Patient_LastName NVARCHAR(50) NULL,
	Patient_MemberId NVARCHAR(20) NULL,
	Reviewer_Facility_Address NVARCHAR(50) NULL,
	Reviewer_Facility_City NVARCHAR(20) NULL,
	Reviewer_Facility__id BIGINT,
	Reviewer_Facility_Name NVARCHAR(50) NULL,
	Reviewer_Facility_PostalCode NVARCHAR(20) NULL,
	Reviewer_Facility_State NVARCHAR(20) NULL,
	Reviewer_Facility_TaxId NVARCHAR(20) NULL,
	Reviewer_FirstName NVARCHAR(50) NULL,
	Reviewer_LastName NVARCHAR(50) NULL,
	Reviewer_Npi NVARCHAR(20) NULL,
	Reviewer_Role INT NULL, 
	Specialty_Code NVARCHAR(20) NULL,
	Specialty_Text NVARCHAR(50) NULL,
	StatusDate DATETIME NULL,
	SubmittedDate DATETIME NULL,
	Submittor_Facility_Address NVARCHAR(50) NULL,
	Submittor_Facility_City NVARCHAR(20) NULL,
	Submittor_Facility__id BIGINT NULL, 
	Submittor_Facility_Name NVARCHAR(50) NULL,
	Submittor_Facility_PostalCode NVARCHAR(20) NULL,
	Submittor_Facility_State NVARCHAR(20) NULL,
	Submittor_Facility_TaxId NVARCHAR(20) NULL,
	Submittor_FirstName NVARCHAR(50) NULL,
	Submittor_LastName NVARCHAR(50) NULL,
	Submittor_Npi NVARCHAR(20) NULL,
	Submittor_Role INT NULL
) 
WITH (
LOCATION='econsultResources.consult',
DATA_SOURCE= PVMONGO00DS
);
GO
 
/**********************************************
(2) CHILD 1 Diagnosis
--BEGIN tran
--DROP EXTERNAL TABLE MongoData.eConsult_Diagnosis
--COMMIT;
***********************************************/ 
 CREATE EXTERNAL TABLE MongoData.eConsult_Diagnosis(
    _id NVARCHAR(100) NOT NULL,
    MessageDeliveryDate DATETIME NULL,
	EConsultId BIGINT, 
	[econsultdata_Diagnosis_Code] NVARCHAR(20),
	[econsultdata_Diagnosis_Text] NVARCHAR(50)
) 
WITH (
LOCATION='econsultResources.consult',
DATA_SOURCE= PVMONGO00DS
);
GO


/**********************************************
(3) CHILD 2 Dialog
--BEGIN tran
--DROP EXTERNAL TABLE MongoData.eConsult_Dialog
--COMMIT;
***********************************************/ 
CREATE EXTERNAL TABLE MongoData.eConsult_Dialog(
    _id NVARCHAR(100) NOT NULL,
    MessageDeliveryDate DATETIME NULL,
	EConsultId BIGINT, 
	[econsultdata_Dialog_CloseCode] NVARCHAR(20) NULL,
	[econsultdata_Dialog_CloseCodeText] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Dialog__id] BIGINT, 
	[econsultdata_Dialog_Message] NVARCHAR(MAX) NULL,
	[econsultdata_Dialog_Recipient_Facility_Address] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Recipient_Facility_City] NVARCHAR(20) NULL,
	[econsultdata_Dialog_Recipient_Facility__id] BIGINT NULL,
	[econsultdata_Dialog_Recipient_Facility_Name] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Recipient_Facility_PostalCode] NVARCHAR(10) NULL,
	[econsultdata_Dialog_Recipient_Facility_State] NVARCHAR(10) NULL,
	[econsultdata_Dialog_Recipient_Facility_TaxId] NVARCHAR(20) NULL,
	[econsultdata_Dialog_Recipient_FirstName] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Recipient_LastName] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Recipient_Npi] NVARCHAR(20) NULL,
	[econsultdata_Dialog_Recipient_Role] INT NULL, 
	[econsultdata_Dialog_Sender_Facility_Address] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Sender_Facility_City] NVARCHAR(20) NULL,
	[econsultdata_Dialog_Sender_Facility__id] BIGINT NULL, 
	[econsultdata_Dialog_Sender_Facility_Name] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Sender_Facility_PostalCode] NVARCHAR(10) NULL,
	[econsultdata_Dialog_Sender_Facility_State] NVARCHAR(10) NULL,
	[econsultdata_Dialog_Sender_Facility_TaxId] NVARCHAR(20) NULL,
	[econsultdata_Dialog_Sender_FirstName] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Sender_LastName] NVARCHAR(50) NULL,
	[econsultdata_Dialog_Sender_Npi] NVARCHAR(20) NULL,
	[econsultdata_Dialog_Sender_Role] INT NULL,
	[econsultdata_Dialog_SentDate] DATETIME NULL
) 
WITH (
LOCATION='econsultResources.consult',
DATA_SOURCE= PVMONGO00DS 
);
GO

/****************************************************************
CHILD 3 Procedures
--BEGIN tran
--DROP EXTERNAL TABLE MongoData.eConsult_Procedure  
--COMMIT;
****************************************************************/
CREATE EXTERNAL TABLE MongoData.eConsult_Procedure(
    _id NVARCHAR(100) NOT NULL,
    MessageDeliveryDate DATETIME NULL,
	EConsultId BIGINT, 
	[econsultdata_Procedures_Code] NVARCHAR(50) NULL,
	[econsultdata_Procedures_Desc] NVARCHAR(200) NULL,
	[econsultdata_Procedures_Modifier] NVARCHAR(50) NULL,
	[econsultdata_Procedures_Quantity] BIGINT NULL
) 
WITH (
LOCATION='econsultResources.consult',
DATA_SOURCE= PVMONGO00DS 
);
GO

/****************************************************************
CHILD 4 Status
--BEGIN tran
--DROP EXTERNAL TABLE MongoData.eConsult_Status
--COMMIT;
****************************************************************/
CREATE EXTERNAL TABLE MongoData.eConsult_Status(
    _id NVARCHAR(100) NOT NULL,
    MessageDeliveryDate DATETIME NULL,
	EConsultId BIGINT, 
	[econsultdata_Status_Code] NVARCHAR(20) NULL,
	[econsultdata_Status_Desc] NVARCHAR(50) NULL,
	[econsultdata_Status_StatusBy_Facility_Address] NVARCHAR(50) NULL,
	[econsultdata_Status_StatusBy_Facility_City] NVARCHAR(20) NULL,
	[econsultdata_Status_StatusBy_Facility__id] BIGINT, 
	[econsultdata_Status_StatusBy_Facility_Name] NVARCHAR(50) NULL,
	[econsultdata_Status_StatusBy_Facility_PostalCode] NVARCHAR(10) NULL,
	[econsultdata_Status_StatusBy_Facility_State] NVARCHAR(10) NULL, 
	[econsultdata_Status_StatusBy_Facility_TaxId] NVARCHAR(20) NULL, 
	[econsultdata_Status_StatusBy_FirstName] NVARCHAR(50) NULL,
	[econsultdata_Status_StatusBy_LastName] NVARCHAR(50) NULL,
	[econsultdata_Status_StatusBy_Npi] NVARCHAR(20) NULL,
	[econsultdata_Status_StatusBy_Role] INT NULL
) 
WITH (
LOCATION='econsultResources.consult',
DATA_SOURCE= PVMONGO00DS 
);
GO
/* ------------------------------------------ End SECTION 2 -------------------------------------------------*/



-- https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-mongodb?view=sql-server-ver15#configure-a-mongodb-external-data-source
-- CREATE STATISTICS
-- WE RECOMMEND CREATING STATISTICS ON EXTERNAL TABLE COLUMNS, ESPECIALLY THE ONES USED FOR JOINS, FILTERS AND AGGREGATES, FOR OPTIMAL QUERY PERFORMANCE.
/* 3. Optional: Create statistics on an external table. */
BEGIN tran
CREATE STATISTICS eConsult_id_EConsultId ON MongoData.eConsult (_id, EConsultId) WITH FULLSCAN;
GO
CREATE STATISTICS eConsult_Diagnosis_id_EConsultId ON MongoData.eConsult_Diagnosis (_id, EConsultId) WITH FULLSCAN;
GO
CREATE STATISTICS eConsult_Dialog_id_EConsultId ON MongoData.eConsult_Dialog (_id, EConsultId) WITH FULLSCAN;
GO
CREATE STATISTICS eConsult_Procedure_id_EConsultId ON MongoData.eConsult_Procedure (_id, EConsultId) WITH FULLSCAN;
GO
CREATE STATISTICS eConsult_Status_id_EConsultId ON MongoData.eConsult_Status (_id, EConsultId) WITH FULLSCAN;
GO
COMMIT;

--USE [econsultResources]
--GO
--DROP STATISTICS [MongoData].[eConsult].[eConsult_id_EConsultId]
--GO
--DROP STATISTICS [MongoData].[eConsult_Diagnosis].[eConsult_Diagnosis_id_EConsultId]
--GO
--DROP STATISTICS [MongoData].[eConsult_Dialog].[eConsult_Dialog_id_EConsultId]
--GO
--DROP STATISTICS [MongoData].[eConsult_Procedure].[eConsult_Procedure_id_EConsultId]
--GO
--DROP STATISTICS [MongoData].[eConsult_Status].[eConsult_Status_id_EConsultId]
--GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SET STATISTICS TIME, IO ON;
GO

--TEST PROD
USE [econsultResources]
GO

SELECT TOP 100
       [_id],
       [_t],
       [MessageDeliveryDate],
       [ClosedCode_Code],
       [EConsultId],
       [Patient_MemberId]
FROM [MongoData].[eConsult]
ORDER BY [MessageDeliveryDate] DESC;
GO



SELECT TOP 100 
	[_id],
	[MessageDeliveryDate],
	[EConsultId],
	[econsultdata_Diagnosis_Code],
	[econsultdata_Diagnosis_Text]
FROM [MongoData].[eConsult_Diagnosis] 
WHERE EConsultId = 22786596 
	 AND _id = '606e05cf77b87d04a83e77a2'
	 
SELECT TOP 100 
	[_id],
	[MessageDeliveryDate],
	[EConsultId],
	[econsultdata_Dialog_CloseCode],
	[econsultdata_Dialog_CloseCodeText],
	[econsultdata_Dialog_Dialog__id],
	[econsultdata_Dialog_Message],
	[econsultdata_Dialog_Recipient_Facility_Address]
FROM [MongoData].[eConsult_Dialog] 
WHERE EConsultId =  22786596 
	 AND _id = '606e05cf77b87d04a83e77a2'

SELECT TOP 100 
	[_id],
	[MessageDeliveryDate],
	[EConsultId],
	[econsultdata_Procedures_Code],
	[econsultdata_Procedures_Desc],
	[econsultdata_Procedures_Modifier],
	[econsultdata_Procedures_Quantity]
FROM [MongoData].[eConsult_Procedure] 
WHERE [EConsultId] = 22786596 
	 AND [_id] = '606e05cf77b87d04a83e77a2'

SELECT TOP 100 
	[_id],
	[MessageDeliveryDate],
	[EConsultId],
	[econsultdata_Status_Code],
	[econsultdata_Status_Desc],
	[econsultdata_Status_StatusBy_Facility_Address],
	[econsultdata_Status_StatusBy_Facility_City],
	[econsultdata_Status_StatusBy_Facility__id],
	[econsultdata_Status_StatusBy_Facility_Name],
	[econsultdata_Status_StatusBy_Facility_PostalCode],
	[econsultdata_Status_StatusBy_Facility_State],
	[econsultdata_Status_StatusBy_Facility_TaxId], 
	[econsultdata_Status_StatusBy_FirstName],
	[econsultdata_Status_StatusBy_LastName],
	[econsultdata_Status_StatusBy_Npi],
	[econsultdata_Status_StatusBy_Role] 
FROM [MongoData].[eConsult_Status] 
WHERE [EConsultId] = 22786596 
	 AND [_id] = '606e05cf77b87d04a83e77a2'
 

/*DO NOT RUN
----The EXECUTE permission WILL BE denied on the object - SEND CODE TO A DBA TO EXECUTE THIS
----EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'econsultResources'
----GO
*/
--USE [master]
--GO
--ALTER DATABASE [econsultResources] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
--GO
--USE [master]
--GO
--DROP DATABASE [econsultResources];
--GO
