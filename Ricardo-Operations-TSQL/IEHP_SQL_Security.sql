-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67853 
-- ------------------------------------------------------------------------------------------------

USE master
GO
-- FIND THE SA
SELECT name FROM master..syslogins WHERE sid = 1
--FIND ALL SA's
SELECT [name] FROM master..syslogins WHERE sysadmin = 1

CREATE LOGIN [IEHP\_sqladmins] FROM WINDOWS WITH DEFAULT_DATABASE=master;
GO

EXEC master..sp_addsrvrolemember @loginame = N'IEHP\_sqladmins', @rolename = N'sysadmin'
GO

ALTER LOGIN sa WITH PASSWORD=N'xxx';
GO

ALTER LOGIN sa WITH NAME = _system_admin;
GO

ALTER LOGIN _system_admin DISABLE;

--ALTER LOGIN [_system_admin] ENABLE

-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67361
-- ------------------------------------------------------------------------------------------------
--CREATE A DATABASE ROLE SPECIFICALLY FOR AUDIT MAINTAINERS, AND GIVE IT PERMISSION TO MAINTAIN AUDITS, WITHOUT GRANTING IT UNNECESSARY PERMISSIONS: 
-- ------------------------------------------------------------------------------------------------

USE master
GO

CREATE ROLE DATABASE_AUDIT_MAINTAINERS; 
GO 

GRANT ALTER ANY DATABASE AUDIT TO DATABASE_AUDIT_MAINTAINERS; 
GO 

--(THE ROLE NAME USED HERE IS AN EXAMPLE; OTHER NAMES MAY BE USED.) 
--USE REVOKE AND/OR DENY AND/OR ALTER ROLE ... DROP MEMBER ... STATEMENTS TO REMOVE THE ALTER ANY DATABASE AUDIT PERMISSION FROM ALL USERS. 
--THEN, FOR EACH AUTHORIZED DATABASE USER, RUN THE STATEMENT: 

--ALTER ROLE DATABASE_AUDIT_MAINTAINERS ADD MEMBER;
--GO 

-- NEXT 3 WILL BE SATISFIED WITH IBM GUARDIUM
-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67365
-- TIMED JOB OR SOME OTHER METHOD IS NOT IMPLEMENTED TO CHECK FOR FUNCTIONS BEING MODIFIED
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67367
-- TIMED JOB OR SOME OTHER METHOD IS NOT IMPLEMENTED TO CHECK FOR TRIGGERS BEING MODIFIED
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67369
-- TIMED JOB OR SOME OTHER METHOD IS NOT IMPLEMENTED TO CHECK FOR STORED PROCEDURES BEING MODIFIED
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67369
-- TIMED JOB OR SOME OTHER METHOD IS NOT IMPLEMENTED TO CHECK FOR STORED PROCEDURES BEING MODIFIED
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67371
-- identify SQL Server accounts authorized to own database objects
-- ------------------------------------------------------------------------------------------------
USE master
GO
SELECT DISTINCT
        S.[Schema/Owner] AS Owner ,
        O.[Schema/Owner] AS [Schema] ,
        O.Securable
FROM    STIG.database_permissions O
        INNER JOIN STIG.database_permissions S ON S.Securable = O.[Schema/Owner]
                                                  AND O.[Securable Type or Class] = 'OBJECT_OR_COLUMN'
                                                  AND S.[Securable Type or Class] = 'SCHEMA'
WHERE   S.[Schema/Owner] NOT IN ( 'dbo', 'sys', 'INFORMATION_SCHEMA' ) 


-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67359
-- SQL Server must generate Trace or Audit records for organization-defined auditable events.
-- ------------------------------------------------------------------------------------------------
SELECT * FROM sys.traces; 
GO
SELECT DISTINCT(eventid) FROM sys.fn_trace_geteventinfo(1); 
GO


-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67373
-- In a database owned by a login not having administrative privileges at the instance level, 
-- the database property TRUSTWORTHY must be OFF unless required and authorized.
-- ------------------------------------------------------------------------------------------------
USE master; 
GO 

SELECT  DB_NAME() AS [Database] ,
        SUSER_SNAME(D.owner_sid) AS [Database Owner] ,
        CASE WHEN D.is_trustworthy_on = 1 THEN 'ON'
             ELSE 'off'
        END AS [Trustworthy]
FROM    sys.databases D
WHERE   D.[name] = DB_NAME()
        AND DB_NAME() <> 'msdb'
        AND D.is_trustworthy_on = 1; 
GO 
--FIX
USE [master]; 
GO 
ALTER DATABASE SET TRUSTWORTHY OFF; 
GO


-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67375
-- In a database owned by [sa], or by any other login having administrative privileges at the instance level, the database property TRUSTWORTHY must be OFF.
-- 
-- ------------------------------------------------------------------------------------------------
USE master
GO

WITH    FixedServerRoles ( RoleName )
          AS ( SELECT   'sysadmin'
               UNION
               SELECT   'securityadmin'
               UNION
               SELECT   'serveradmin'
               UNION
               SELECT   'setupadmin'
               UNION
               SELECT   'processadmin'
               UNION
               SELECT   'diskadmin'
               UNION
               SELECT   'dbcreator'
               UNION
               SELECT   'bulkadmin'
             )
    SELECT  DB_NAME() AS [Database] ,
            SUSER_SNAME(D.owner_sid) AS [Database Owner] ,
            F.RoleName AS [Fixed Server Role] ,
            CASE WHEN D.is_trustworthy_on = 1 THEN 'ON'
                 ELSE 'off'
            END AS [Trustworthy]
    FROM    FixedServerRoles F
            INNER JOIN sys.databases D ON D.name = DB_NAME()
    WHERE   IS_SRVROLEMEMBER(F.RoleName, SUSER_SNAME(D.owner_sid)) = 1
            AND DB_NAME() <> 'msdb'
            AND D.is_trustworthy_on = 1; 
GO

-- FIX TEXT
-- To set the TRUSTWORTHY property OFF: 
USE [master]; 
GO 
ALTER DATABASE SET TRUSTWORTHY OFF; 
GO 
--Verify that this produced the intended result by re-running the query specified in the Check. 


-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67379
-- The Database Master Key encryption password must meet DoD password complexity requirements. 
-- 
-- ------------------------------------------------------------------------------------------------
SELECT  name
FROM    [master].sys.databases
WHERE   state = 0 

--Repeat for each database: 
--From the query prompt: 

DECLARE @command VARCHAR(1000) 
SELECT  @command = 'USE ? SELECT  COUNT(name)
FROM    sys.symmetric_keys s ,
        sys.key_encryptions k
WHERE   s.name = ''##MS_DatabaseMasterKey##''
        AND s.symmetric_key_id = k.key_id
        AND k.crypt_type = ''ESKP'' ' 
EXEC sp_MSforeachdb @command 
-- FIX TEXT 
-- TO CHANGE THE DATABASE MASTER KEY ENCRYPTION PASSWORD: 
USE [database name]; 
ALTER MASTER KEY REGENERATE WITH ENCRYPTION BY PASSWORD = '[new STRONG password]'; 

-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67381
-- The Database Master Key must be encrypted by the Service Master Key, where a Database Master Key  
-- is required and another encryption method has not been specified.
-- ------------------------------------------------------------------------------------------------
SELECT  name
FROM    [master].sys.databases
WHERE   is_master_key_encrypted_by_server = 1
        AND owner_sid <> 1
        AND state = 0; 

-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67383
-- Database Master Key passwords must not be stored in credentials within the database. 
-- 
-- ------------------------------------------------------------------------------------------------
SELECT  COUNT(credential_id)
FROM    [master].sys.master_key_passwords 


-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67385
--  
-- 
-- ------------------------------------------------------------------------------------------------
SELECT  s.name ,
        k.crypt_type_desc
FROM    sys.symmetric_keys s ,
        sys.key_encryptions k
WHERE   s.symmetric_key_id = k.key_id
        AND k.crypt_type IN ( 'ESKP', 'ESKS' )
ORDER BY s.name ,
        k.crypt_type_desc; 

-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67417
-- SQL Server must generate Trace or Audit records when privileges/permissions are modified via locally-defined security objects. 
-- 
-- ------------------------------------------------------------------------------------------------
SELECT * FROM sys.traces; 
SELECT DISTINCT(eventid) FROM sys.fn_trace_geteventinfo(2); 
-- ------------------------------------------------------------------------------------------------
-- Vuln ID:	V-67419
--  
-- 
-- ------------------------------------------------------------------------------------------------
USE [master]; 
GO 

SELECT * FROM :: fn_trace_getinfo(default)
GO
SELECT count(*) FROM :: fn_trace_getinfo(default) WHERE property = 5 and value = 1;
GO
sp_trace_setstatus 1, @status = 0; --to stop the trace.
GO
sp_trace_setstatus 1, @status = 2; --to close the trace and delete its information from the server.
GO

SELECT * FROM sys.traces -- WHERE is_default = 1; 
GO
SELECT DISTINCT(eventid) FROM sys.fn_trace_geteventinfo(1); 
GO
-- OR 
SELECT DISTINCT
        eventid ,
        name
FROM    fn_trace_geteventinfo (1) EI
        JOIN sys.trace_events TE ON EI.eventid = TE.trace_event_id

SELECT  *
FROM    sys.server_audit_specification_details
WHERE   server_specification_id = ( SELECT  server_specification_id
                                    FROM    sys.server_audit_specifications
                                    WHERE   [name] = ''
                                  )
        AND audit_action_name = 'SCHEMA_OBJECT_ACCESS_GROUP'; 

