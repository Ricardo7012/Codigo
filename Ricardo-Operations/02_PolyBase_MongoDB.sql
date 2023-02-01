--:CONNECT DVSQLPOL01
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SET STATISTICS TIME, IO ON;
GO

USE [iehpwebhook]
GO
CREATE SCHEMA [MongoData]
GO
-- WHEN YOU CREATE AN EXTERNAL TABLE USE MATCHING CASE AND DATATYPE
-- THE TRICK IS TO ERROR IT ONCE TO SEE THE CORRECT COLUMN NAMES AND DATATYPES
-- NOTE: ONLY BRING IN WHAT YOU NEED
USE [iehpwebhook]
GO
CREATE EXTERNAL TABLE MongoData.eConsultData2(
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

-- https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-mongodb?view=sql-server-ver15#configure-a-mongodb-external-data-source
-- CREATE STATISTICS
-- WE RECOMMEND CREATING STATISTICS ON EXTERNAL TABLE COLUMNS, ESPECIALLY THE ONES USED FOR JOINS, FILTERS AND AGGREGATES, FOR OPTIMAL QUERY PERFORMANCE.
CREATE STATISTICS _id ON MongoData.eConsultData (_id) WITH FULLSCAN;
go

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
  FROM [iehpwebhook].[MongoData].[eConsultData2]
  ORDER BY [MessageDeliveryDate] DESC