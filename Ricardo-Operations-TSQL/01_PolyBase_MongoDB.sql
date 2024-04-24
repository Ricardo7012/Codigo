-- https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-mongodb?view=sql-server-ver15

/* MONGODB PRE-REQ
--iehpwebhook.econsultdata
 db.createUser(
{	user: "DPOLYBASE01",
	pwd: "yJ119DQj1voRBJiHHfSo",

	roles:[{role: "read" , db:"iehpwebhook"}]})
*/

SELECT *
FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
 

USE [iehpwebhook]
GO
SELECT * FROM sys.certificates
SELECT * FROM sys.symmetric_keys
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = '206CEFDB-ACCB-426E-9B38-06EAC3E71C36';  
--SELECT * FROM sys.certificates
--SELECT * FROM sys.symmetric_keys

-- IDENTITY: the Kerberos user name.  
-- SECRET: the Kerberos password  
CREATE DATABASE SCOPED CREDENTIAL DVMONGOCRED WITH IDENTITY = 'DPOLYBASE01',SECRET='yJ119DQj1voRBJiHHfSo';


--DROP DATABASE SCOPED CREDENTIAL DVMONGOCRED;  
--GO  

--FIX THIS LOCATION= TO CONNECT TO PRIMARY NODE readPreference=primary
create external data source DVMONGO00DS with
	(LOCATION='mongodb://dvmongo02.iehp.local:27017', 
	CONNECTION_OPTIONS = 'replicaSet=rs1; tls=false; ssl=false; readPreference=primary',
	credential=DVMONGOCRED);
go

--USE [iehpwebhook]
--GO
--DROP EXTERNAL DATA SOURCE [DVMONGO02DS]
--GO


SELECT * FROM sys.database_scoped_credentials;
GO
SELECT * FROM sys.external_data_sources;
GO
SELECT * FROM sys.configurations where name like '%polybase%' or name like '%hadoop%' ORDER BY NAME;
GO

-- https://www.sqlshack.com/enhanced-polybase-sql-2019-mongodb-and-external-table/
