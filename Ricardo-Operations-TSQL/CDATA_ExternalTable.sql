USE [PolybaseDev]
GO

--CREATE DATABASE SCOPED CREDENTIAL hbase_creds
--WITH IDENTITY = 'hbase', SECRET = 'hbase';

--Create an external data source with CREATE EXTERNAL DATA SOURCE.
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=sql-server-ver15
-- LOCATION (Required) : Hadoop Name Node IP address and port.  
-- RESOURCE MANAGER LOCATION (Optional): Hadoop Resource Manager location to enable pushdown computation.  
-- CREDENTIAL (Optional):  the database scoped credential, created above.  
CREATE EXTERNAL DATA SOURCE DVLAKAMB01_CDATA64
	WITH (  
      LOCATION = 'odbc://name01.iehp.local:8086', 
	  CONNECTION_OPTIONS = 'DSN=DVLAKAMB01_CDATA64',
      CREDENTIAL = hbase_creds
	);  
GO
SELECT * FROM sys.external_data_sources
GO

USE [PolybaseDev]
GO
-- CREATE AN EXTERNAL TABLE POINTING TO DATA STORED IN HADOOP WITH CREATE EXTERNAL TABLE. IN THIS EXAMPLE, THE EXTERNAL DATA CONTAINS CAR SENSOR DATA.
-- LOCATION: path to file or directory that contains the data (relative to HDFS root).  
CREATE EXTERNAL TABLE [dbo].[RicardoTest3HBASE]
(
 [RowKey] NVARCHAR(255)  NOT NULL,
 [gender]		    NVARCHAR(255) ,
 [marital_status] 	NVARCHAR(4000), 
 [name] 			NVARCHAR(4000), 
 [spouse] 		    NVARCHAR(4000), 
 [education_level]  NVARCHAR(4000), 
 [employed] 		NVARCHAR(4000), 
 [field] 			NVARCHAR(4000)
)
WITH (
	LOCATION = N'census'
	,DATA_SOURCE = [DVLAKAMB01_CDATA64]
	)
GO
SELECT * FROM sys.external_tables -- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/external-operations-catalog-views-transact-sql?view=sql-server-ver15
GO
SELECT * FROM [RicardoTest3HBASE] --sys.external_tables 
GO

