/*
http://blogs.msdn.com/b/sqlserverfaq/archive/2010/02/09/drop-failed-for-login-since-it-has-granted-one-or-more-permission-s.aspx
DROP FAILED FOR LOGIN SINCE IT HAS GRANTED ONE OR MORE PERMISSION(S)
*/

/****** Object:  Login [domain\user]    Script Date: 11/01/2011 14:43:10 ******/
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'domain\user')
DROP LOGIN [domain\user]
GO


Select * 
From sys.server_permissions 
Where grantee_principal_id = (Select principal_id From sys.server_principals Where Name = N'domain\user')

Select name From sys.server_principals Where principal_id In (267)

Use master
Go
exec sp_helprotect --@username = [domain\user]
go
USE MASTER 
GO
sp_helplogins 'domain\user'
GO

Select * from sys.server_permissions 

where grantor_principal_id = 

(Select principal_id from sys.server_principals where name = N'domain\user') 
Select name From sys.server_principals Where principal_id In (267)
Select name From sys.server_principals Where principal_id In (268)


SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO
SELECT dpm.class_desc as [AccessLevel], 
ISNULL(OBJECT_NAME(dpm.major_id), 'N/A')
as [ObjectName], dpr1.name AS [GrantedTo], dpr2.name AS [GrantedBy],
CASE dpm.type 
WHEN 'AL' THEN 'ALTER'
WHEN 'ALAK' THEN 'ALTER ANY ASYMMETRIC KEY'
WHEN 'ALAR' THEN 'ALTER ANY APPLICATION ROLE' 
WHEN 'ALAS' THEN 'ALTER ANY ASSEMBLY' 
WHEN 'ALCF' THEN 'ALTER ANY CERTIFICATE' 
WHEN 'ALDS' THEN 'ALTER ANY DATASPACE' 
WHEN 'ALED' THEN 'ALTER ANY DATABASE EVENT NOTIFICATION' 
WHEN 'ALFT' THEN 'ALTER ANY FULLTEXT CATALOG' 
WHEN 'ALMT' THEN 'ALTER ANY MESSAGE TYPE' 
WHEN 'ALRL' THEN 'ALTER ANY ROLE' 
WHEN 'ALRT' THEN 'ALTER ANY ROUTE' 
WHEN 'ALSB' THEN 'ALTER ANY REMOTE SERVICE BINDING' 
WHEN 'ALSC' THEN 'ALTER ANY REMOTE SERVICE BINDING' 
WHEN 'ALSC' THEN 'ALTER ANY CONTRACT' 
WHEN 'ALSK' THEN 'ALTER ANY SYMMETRIC KEY' 
WHEN 'ALSM' THEN 'ALTER ANY SCHEMA' 
WHEN 'ALSV' THEN 'ALTER ANY SERVICE' 
WHEN 'ALTG' THEN 'ALTER ANY DATABASE DDL TRIGGER' 
WHEN 'ALUS' THEN 'ALTER ANY USER' 
WHEN 'AUTH' THEN 'AUTHENTICATE' 
WHEN 'BADB' THEN 'BACKUP DATABASE' 
WHEN 'BALO' THEN 'BACKUP LOG' 
WHEN 'CL' THEN 'CONTROL' 
WHEN 'CO' THEN 'CONNECT' 
WHEN 'CORP' THEN 'CONNECT REPLICATION' 
WHEN 'CP' THEN 'CHECKPOINT' 
WHEN 'CRAG' THEN 'CREATE AGGREGATE' 
WHEN 'CRAK' THEN 'CREATE ASYMMETRIC KEY'
WHEN 'CRAS' THEN 'CREATE ASSEMBLY' 
WHEN 'CRCF' THEN 'CREATE CERTIFICATE' 
WHEN 'CRDB' THEN 'CREATE DATABASE' 
WHEN 'CRDF' THEN 'CREATE DEFAULT'
WHEN 'CRED' THEN 'CREATE DATABASE DDL EVENT NOTIFICATION' 
WHEN 'CRFN' THEN 'CREATE FUNCTION' 
WHEN 'CRFT' THEN 'CREATE FULLTEXT CATALOG' 
WHEN 'CRMT' THEN 'CREATE MESSAGE TYPE' 
WHEN 'CRPR' THEN 'CREATE PROCEDURE' 
WHEN 'CRQU' THEN 'CREATE QUEUE' 
WHEN 'CRRL' THEN 'CREATE ROLE' 
WHEN 'CRRT' THEN 'CREATE ROUTE' 
WHEN 'CRRU' THEN 'CREATE RULE'
WHEN 'CRSB' THEN 'CREATE REMOTE SERVICE BINDING'
WHEN 'CRSC' THEN 'CREATE CONTRACT' 
WHEN 'CRSK' THEN 'CREATE SYMMETRIC KEY' 
WHEN 'CRSM' THEN 'CREATE SCHEMA' 
WHEN 'CRSN' THEN 'CREATE SYNONYM' 
WHEN 'CRSV' THEN 'CREATE SERVICE' 
WHEN 'CRTB' THEN 'CREATE TABLE' 
WHEN 'CRTY' THEN 'CREATE TYPE' 
WHEN 'CRVW' THEN 'CREATE VIEW' 
WHEN 'CRXS' THEN 'CREATE XML SCHEMA COLLECTION' 
WHEN 'DL' THEN 'DELETE' 
WHEN 'EX' THEN 'EXECUTE' 
WHEN 'IM' THEN 'IMPERSONATE' 
WHEN 'IN' THEN 'INSERT' 
WHEN 'RC' THEN 'RECEIVE' 
WHEN 'RF' THEN 'REFERENCES' 
WHEN 'SL' THEN 'SELECT' 
WHEN 'SN' THEN 'SEND' 
WHEN 'SPLN' THEN 'SHOWPLAN' 
WHEN 'SUQN' THEN 'SUBSCRIBE QUERY NOTIFICATIONS' 
WHEN 'TO' THEN 'TAKE OWNERSHIP' 
WHEN 'UP' THEN 'UPDATE'
WHEN 'VW' THEN 'VIEW DEFINITION'
WHEN 'VWDS' THEN 'VIEW DATABASE STATE'
END As PermissionType
FROM sys.database_permissions dpm INNER JOIN sys.database_principals dpr1
ON dpm.grantee_principal_id = dpr1.principal_id INNER JOIN sys.database_principals dpr2
ON dpm.grantor_principal_id = dpr2.principal_id
WHERE dpr1.principal_id NOT IN (0,1,2,3,4,16384,16385,16386,16387,16388,16389,16390,16391,16392,16393)