SELECT [Default Data Path] = SERVERPROPERTY('InstanceDefaultDataPath')
SELECT [Default Log Path]  = SERVERPROPERTY('InstanceDefaultLogPath')
SELECT [Default Log Path]  = SERVERPROPERTY('ErrorLogFileName')

SELECT 
SERVERPROPERTY('BuildClrVersion'),
SERVERPROPERTY('Collation'),
SERVERPROPERTY('CollationID'),
SERVERPROPERTY('ComparisonStyle'),
SERVERPROPERTY('ComputerNamePhysicalNetBIOS'),
SERVERPROPERTY('Edition'),
SERVERPROPERTY('EditionID'),
SERVERPROPERTY('EngineEdition'), -- 1=Personal, 2=Standard, 3=Enterprise, 4 = Express, 5=SQLDB
SERVERPROPERTY('HadrManagerStatus'), -- 1=NotStartedPendingComm, 2=Started, 3=NotStartedFailed
SERVERPROPERTY('IsHadrEnabled'),
SERVERPROPERTY('InstanceName'),
SERVERPROPERTY('IsClustered'),
SERVERPROPERTY('IsFullTextInstalled'),
SERVERPROPERTY('IsIntegratedSecurityOnly'),
SERVERPROPERTY('IsLocalDB'),
SERVERPROPERTY('IsSingleUser'),
SERVERPROPERTY('IsXTPSupported'),
SERVERPROPERTY('LicenseType'),
SERVERPROPERTY('LCID'),
SERVERPROPERTY('MachineName'),
SERVERPROPERTY('NumLicenses'),
SERVERPROPERTY('ProcessID'),
SERVERPROPERTY('ProductVersion'),
SERVERPROPERTY('ProductLevel'),
SERVERPROPERTY('ResourceLastUpdateDateTime'),
SERVERPROPERTY('ResourceVersion'),
SERVERPROPERTY('ServerName'),
SERVERPROPERTY('SqlCharSet'),
SERVERPROPERTY('SqlCharSetName'),
SERVERPROPERTY('SqlSortOrder'),
SERVERPROPERTY('SqlSortOrderName'),
SERVERPROPERTY('FilestreamShareName'),
SERVERPROPERTY('FilestreamConfiguredLevel'),
SERVERPROPERTY('FilestreamEffectiveLevel')


