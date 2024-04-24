-- [-- DB CONTEXT --] --
USE [Logging]
 
-- [-- DB USERS --] --
 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CIAUser') BEGIN CREATE USER  [CIAUser] FOR LOGIN [CIAUser] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'dbo') BEGIN CREATE USER  [dbo] FOR LOGIN [sa] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'guest') BEGIN CREATE USER  [guest] WITHOUT LOGIN WITH DEFAULT_SCHEMA = [guest] , SID = 0x00  END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\ArchDevAdmin') BEGIN CREATE USER  [IEHP\ArchDevAdmin] FOR LOGIN [IEHP\ArchDevAdmin] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\ArchDevUser') BEGIN CREATE USER  [IEHP\ArchDevUser] FOR LOGIN [IEHP\ArchDevUser] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\c1243') BEGIN CREATE USER  [IEHP\c1243] FOR LOGIN [IEHP\c1243] WITH DEFAULT_SCHEMA = [IEHP\c1243] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\DataScience_Admin') BEGIN CREATE USER  [IEHP\DataScience_Admin] FOR LOGIN [IEHP\DataScience_Admin] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\HAR_Admin') BEGIN CREATE USER  [IEHP\HAR_Admin] FOR LOGIN [IEHP\HAR_Admin] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\HAR_Analyst') BEGIN CREATE USER  [IEHP\HAR_Analyst] FOR LOGIN [IEHP\HAR_Analyst] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\i1782') BEGIN CREATE USER  [IEHP\i1782] FOR LOGIN [IEHP\i1782] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\i7574') BEGIN CREATE USER  [IEHP\i7574] FOR LOGIN [IEHP\i7574] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\IT_DataMgmt_Admin') BEGIN CREATE USER  [IEHP\IT_DataMgmt_Admin] FOR LOGIN [IEHP\IT_DataMgmt_Admin] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\IT_QA_User') BEGIN CREATE USER  [IEHP\IT_QA_User] FOR LOGIN [IEHP\IT_QA_User] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHP\TitanDataReader') BEGIN CREATE USER  [IEHP\TitanDataReader] FOR LOGIN [IEHP\TitanDataReader] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'IEHPBusinessApp') BEGIN CREATE USER  [IEHPBusinessApp] FOR LOGIN [IEHPBusinessApp] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'LoggingUser') BEGIN CREATE USER  [LoggingUser] FOR LOGIN [LoggingUser] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'LSUser_ReadOnly') BEGIN CREATE USER  [LSUser_ReadOnly] FOR LOGIN [LSUser_ReadOnly] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'ProviderSearchUser') BEGIN CREATE USER  [ProviderSearchUser] FOR LOGIN [ProviderSearchUser] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'Vega01\Logging_R') BEGIN CREATE USER  [Vega01\Logging_R] FOR LOGIN [Vega01\Logging_R] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'Vega01\Logging_W') BEGIN CREATE USER  [Vega01\Logging_W] FOR LOGIN [Vega01\Logging_W] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'Web_Prov') BEGIN CREATE USER  [Web_Prov] FOR LOGIN [Web_Prov] WITH DEFAULT_SCHEMA = [dbo] END; 
-- [-- ORPHANED USERS --] --
-- [-- DB ROLES --] --
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'IEHP\DataScience_Admin'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'IEHP\i7574'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'IEHP\IT_DataMgmt_Admin'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'IEHP\IT_QA_User'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'IEHP\TitanDataReader'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'LSUser_ReadOnly'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'Vega01\Logging_R'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'Vega01\Logging_W'
EXEC sp_addrolemember @rolename = 'db_datawriter', @membername = 'Vega01\Logging_W'
EXEC sp_addrolemember @rolename = 'db_executor', @membername = 'Vega01\Logging_W'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'CIAUser'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'IEHP\ArchDevAdmin'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'LoggingUser'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'ProviderSearchUser'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'Web_Prov'
EXEC sp_addrolemember @rolename = 'HAR_Read', @membername = 'IEHP\HAR_Admin'
EXEC sp_addrolemember @rolename = 'HAR_Read', @membername = 'IEHP\HAR_Analyst'
 
-- [-- OBJECT LEVEL PERMISSIONS --] --
GRANT ALTER ON [dbo].[SuccessFailedAttemptsByDate] TO [CIAUser]
GRANT ALTER ON [dbo].[SuccessFailedAttemptsByDate] TO [IEHP\c1243]
GRANT ALTER ON [dbo].[SuccessFailedAttemptsByDate] TO [LoggingUser]
GRANT CONTROL ON [dbo].[SuccessFailedAttemptsByDate] TO [CIAUser]
GRANT CONTROL ON [dbo].[SuccessFailedAttemptsByDate] TO [IEHP\c1243]
GRANT DELETE ON [dbo].[ActivityRequest] TO [LoggingUser]
GRANT DELETE ON [dbo].[ActivityType] TO [LoggingUser]
GRANT DELETE ON [dbo].[Applications] TO [LoggingUser]
GRANT DELETE ON [dbo].[EntityActivityLog] TO [LoggingUser]
GRANT DELETE ON [dbo].[ErrorCodes] TO [LoggingUser]
GRANT DELETE ON [dbo].[Log] TO [LoggingUser]
GRANT DELETE ON [sys].[sysallocunits] TO [LoggingUser]
GRANT DELETE ON [sys].[sysclones] TO [LoggingUser]
GRANT DELETE ON [sys].[sysfiles1] TO [LoggingUser]
GRANT DELETE ON [sys].[sysrowsets] TO [LoggingUser]
GRANT DELETE ON [sys].[sysseobjvalues] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[AddNewApplication] TO [CIAUser]
GRANT EXECUTE ON [dbo].[AddNewApplication] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[AttemptsBySubscriberNumber] TO [CIAUser]
GRANT EXECUTE ON [dbo].[ClearLog] TO [CIAUser]
GRANT EXECUTE ON [dbo].[ClearLog] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[CreateActivityRequestLogEntry] TO [CIAUser]
GRANT EXECUTE ON [dbo].[CreateActivityRequestLogEntry] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[CreateActivityRequestLogEntry] TO [Web_Prov]
GRANT EXECUTE ON [dbo].[CreateEntityActivityLog] TO [CIAUser]
GRANT EXECUTE ON [dbo].[CreateEntityActivityLog] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[CreateEntityActivityLog] TO [Web_Prov]
GRANT EXECUTE ON [dbo].[DeleteApplication] TO [CIAUser]
GRANT EXECUTE ON [dbo].[DeleteApplication] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetAllActiveUsersInLastMonth] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetAllActiveUsersInLastMonth] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetAllRegisteredUsers] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetAllRegisteredUsers] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetAllRegisteredUsersInLastMonth] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetAllRegisteredUsersInLastMonth] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetApplications] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetApplications] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetDifferenctInTotalRegistrationsForMemberPortal] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetLoginsBySuccessTypeForTime] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetLoginsBySuccessTypeForTime] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetLogLevel] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetLogLevel] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetLogRecordCount] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetLogRecordCount] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetPortalErrorLogging] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[GetRegisteredUsersByRegDateLastLoginAndAppName] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetRegistrationsByDateAndApplication] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetSuccessesAndFailsForProviderPortalByDate] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetTotalRegistrationsForMemberPortal] TO [CIAUser]
GRANT EXECUTE ON [dbo].[GetTotalRegistrationsForMemberPortalByMonth] TO [CIAUser]
GRANT EXECUTE ON [dbo].[ReadLog] TO [CIAUser]
GRANT EXECUTE ON [dbo].[ReadLog] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[ReportMemberPortalRegistrationsByDate] TO [CIAUser]
GRANT EXECUTE ON [dbo].[ReportMemberPortalRegistrationsByLob] TO [CIAUser]
GRANT EXECUTE ON [dbo].[SetLogLevel] TO [CIAUser]
GRANT EXECUTE ON [dbo].[SetLogLevel] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[SuccessFailedAttemptsByDate] TO [CIAUser]
GRANT EXECUTE ON [dbo].[SuccessFailedAttemptsByDate] TO [IEHP\c1243]
GRANT EXECUTE ON [dbo].[SuccessFailedAttemptsByDate] TO [LoggingUser]
GRANT EXECUTE ON [dbo].[WriteLog] TO [CIAUser]
GRANT EXECUTE ON [dbo].[WriteLog] TO [LoggingUser]
GRANT EXECUTE ON [sys].[sysallocunits] TO [LoggingUser]
GRANT EXECUTE ON [sys].[sysclones] TO [LoggingUser]
GRANT EXECUTE ON [sys].[sysfiles1] TO [LoggingUser]
GRANT EXECUTE ON [sys].[sysrowsets] TO [LoggingUser]
GRANT EXECUTE ON [sys].[sysseobjvalues] TO [LoggingUser]
GRANT INSERT ON [dbo].[ActivityRequest] TO [LoggingUser]
GRANT INSERT ON [dbo].[ActivityRequest] TO [Web_Prov]
GRANT INSERT ON [dbo].[ActivityType] TO [LoggingUser]
GRANT INSERT ON [dbo].[Applications] TO [LoggingUser]
GRANT INSERT ON [dbo].[EntityActivityLog] TO [LoggingUser]
GRANT INSERT ON [dbo].[EntityActivityLog] TO [Web_Prov]
GRANT INSERT ON [dbo].[ErrorCodes] TO [LoggingUser]
GRANT INSERT ON [dbo].[Log] TO [LoggingUser]
GRANT INSERT ON [sys].[sysallocunits] TO [LoggingUser]
GRANT INSERT ON [sys].[sysclones] TO [LoggingUser]
GRANT INSERT ON [sys].[sysfiles1] TO [LoggingUser]
GRANT INSERT ON [sys].[sysrowsets] TO [LoggingUser]
GRANT INSERT ON [sys].[sysseobjvalues] TO [LoggingUser]
GRANT SELECT ON [dbo].[ActivityRequest] TO [CIAUser]
GRANT SELECT ON [dbo].[ActivityRequest] TO [HAR_Read]
GRANT SELECT ON [dbo].[ActivityRequest] TO [LoggingUser]
GRANT SELECT ON [dbo].[ActivityRequest] TO [Web_Prov]
GRANT SELECT ON [dbo].[ActivityType] TO [CIAUser]
GRANT SELECT ON [dbo].[ActivityType] TO [LoggingUser]
GRANT SELECT ON [dbo].[Applications] TO [CIAUser]
GRANT SELECT ON [dbo].[Applications] TO [IEHPBusinessApp]
GRANT SELECT ON [dbo].[Applications] TO [LoggingUser]
GRANT SELECT ON [dbo].[EntityActivityLog] TO [CIAUser]
GRANT SELECT ON [dbo].[EntityActivityLog] TO [IEHP\i1782]
GRANT SELECT ON [dbo].[EntityActivityLog] TO [IEHPBusinessApp]
GRANT SELECT ON [dbo].[EntityActivityLog] TO [LoggingUser]
GRANT SELECT ON [dbo].[EntityActivityLog] TO [Web_Prov]
GRANT SELECT ON [dbo].[ErrorCodes] TO [CIAUser]
GRANT SELECT ON [dbo].[ErrorCodes] TO [LoggingUser]
GRANT SELECT ON [dbo].[Log] TO [CIAUser]
GRANT SELECT ON [dbo].[Log] TO [IEHPBusinessApp]
GRANT SELECT ON [dbo].[Log] TO [LoggingUser]
GRANT SELECT ON [dbo].[vw_EntityActivityLog] TO [HAR_Read]
GRANT SELECT ON [dbo].[vw_EntityActivityLog] TO [IEHP\i1782]
GRANT SELECT ON [sys].[sysallocunits] TO [LoggingUser]
GRANT SELECT ON [sys].[sysclones] TO [LoggingUser]
GRANT SELECT ON [sys].[sysfiles1] TO [LoggingUser]
GRANT SELECT ON [sys].[sysrowsets] TO [LoggingUser]
GRANT SELECT ON [sys].[sysseobjvalues] TO [LoggingUser]
GRANT TAKE OWNERSHIP ON [dbo].[SuccessFailedAttemptsByDate] TO [CIAUser]
GRANT TAKE OWNERSHIP ON [dbo].[SuccessFailedAttemptsByDate] TO [IEHP\c1243]
GRANT UPDATE ON [dbo].[ActivityRequest] TO [LoggingUser]
GRANT UPDATE ON [dbo].[ActivityRequest] TO [Web_Prov]
GRANT UPDATE ON [dbo].[ActivityType] TO [LoggingUser]
GRANT UPDATE ON [dbo].[Applications] TO [LoggingUser]
GRANT UPDATE ON [dbo].[EntityActivityLog] TO [LoggingUser]
GRANT UPDATE ON [dbo].[EntityActivityLog] TO [Web_Prov]
GRANT UPDATE ON [dbo].[ErrorCodes] TO [LoggingUser]
GRANT UPDATE ON [dbo].[Log] TO [LoggingUser]
GRANT UPDATE ON [sys].[sysallocunits] TO [LoggingUser]
GRANT UPDATE ON [sys].[sysclones] TO [LoggingUser]
GRANT UPDATE ON [sys].[sysfiles1] TO [LoggingUser]
GRANT UPDATE ON [sys].[sysrowsets] TO [LoggingUser]
GRANT UPDATE ON [sys].[sysseobjvalues] TO [LoggingUser]
GRANT VIEW DEFINITION ON [dbo].[SuccessFailedAttemptsByDate] TO [CIAUser]
GRANT VIEW DEFINITION ON [dbo].[SuccessFailedAttemptsByDate] TO [IEHP\c1243]
GRANT VIEW DEFINITION ON [dbo].[SuccessFailedAttemptsByDate] TO [LoggingUser]
-- [-- TYPE LEVEL PERMISSIONS --] --
 
-- [--DB LEVEL PERMISSIONS --] --
GRANT CONNECT TO [CIAUser]
GRANT CONNECT TO [IEHP\ArchDevAdmin]
GRANT CONNECT TO [IEHP\ArchDevUser]
GRANT CONNECT TO [IEHP\DataScience_Admin]
GRANT CONNECT TO [IEHP\HAR_Admin]
GRANT CONNECT TO [IEHP\HAR_Analyst]
GRANT CONNECT TO [IEHP\i1782]
GRANT CONNECT TO [IEHP\i7574]
GRANT CONNECT TO [IEHP\IT_DataMgmt_Admin]
GRANT CONNECT TO [IEHP\IT_QA_User]
GRANT CONNECT TO [IEHP\TitanDataReader]
GRANT CONNECT TO [IEHPBusinessApp]
GRANT CONNECT TO [LoggingUser]
GRANT CONNECT TO [LSUser_ReadOnly]
GRANT CONNECT TO [ProviderSearchUser]
GRANT CONNECT TO [Vega01\Logging_R]
GRANT CONNECT TO [Vega01\Logging_W]
GRANT CONNECT TO [Web_Prov]
 
-- [--DB LEVEL SCHEMA PERMISSIONS --] --
GRANT DELETE ON SCHEMA::[audit] TO [LoggingUser]
GRANT DELETE ON SCHEMA::[context] TO [LoggingUser]
GRANT DELETE ON SCHEMA::[lookup] TO [LoggingUser]
GRANT DELETE ON SCHEMA::[report] TO [LoggingUser]
GRANT DELETE ON SCHEMA::[work] TO [LoggingUser]
GRANT EXECUTE ON SCHEMA::[audit] TO [LoggingUser]
GRANT EXECUTE ON SCHEMA::[context] TO [LoggingUser]
GRANT EXECUTE ON SCHEMA::[lookup] TO [LoggingUser]
GRANT EXECUTE ON SCHEMA::[report] TO [LoggingUser]
GRANT EXECUTE ON SCHEMA::[work] TO [LoggingUser]
GRANT INSERT ON SCHEMA::[audit] TO [LoggingUser]
GRANT INSERT ON SCHEMA::[context] TO [LoggingUser]
GRANT INSERT ON SCHEMA::[lookup] TO [LoggingUser]
GRANT INSERT ON SCHEMA::[report] TO [LoggingUser]
GRANT INSERT ON SCHEMA::[work] TO [LoggingUser]
GRANT SELECT ON SCHEMA::[audit] TO [LoggingUser]
GRANT SELECT ON SCHEMA::[context] TO [LoggingUser]
GRANT SELECT ON SCHEMA::[lookup] TO [LoggingUser]
GRANT SELECT ON SCHEMA::[report] TO [LoggingUser]
GRANT SELECT ON SCHEMA::[work] TO [LoggingUser]
GRANT UPDATE ON SCHEMA::[audit] TO [LoggingUser]
GRANT UPDATE ON SCHEMA::[context] TO [LoggingUser]
GRANT UPDATE ON SCHEMA::[lookup] TO [LoggingUser]
GRANT UPDATE ON SCHEMA::[report] TO [LoggingUser]
GRANT UPDATE ON SCHEMA::[work] TO [LoggingUser]
