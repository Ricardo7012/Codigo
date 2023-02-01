--http://msdn.microsoft.com/query/dev10.query?appId=Dev10IDEF1&l=EN-US&k=k(SERVERPROPERTY_TSQL);k(SQL11.SWB.TSQLRESULTS.F1);k(SQL11.SWB.TSQLQUERY.F1);k(MISCELLANEOUSFILESPROJECT);k(DevLang-TSQL)&rd=true
SELECT 
	--SERVERPROPERTY('BuildClrVersion') AS BuildClrVersion
	--,SERVERPROPERTY('Collation') AS Collation
	--,SERVERPROPERTY('CollationID') AS CollationID
	--,SERVERPROPERTY('ComparisonStyle') AS ComparisonStyle
	--,SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS ComputerNamePhysicalNetBIOS
	SERVERPROPERTY('Edition') AS Edition
--	,SERVERPROPERTY('EditionID') AS EditionID
	,SERVERPROPERTY('EngineEdition') AS EngineEdition
	--,SERVERPROPERTY('HadrManagerStatus') AS HadrManagerStatus
	--,SERVERPROPERTY('InstanceName') AS InstanceName
	--,SERVERPROPERTY('IsClustered') AS IsClustered
	--,SERVERPROPERTY('IsFullTextInstalled') AS IsFullTextInstalled
	--,SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled
	--,SERVERPROPERTY('IsIntegratedSecurityOnly') AS IsIntegratedSecurityOnly
	--,SERVERPROPERTY('IsLocalDB') AS IsLocalDB
	--,SERVERPROPERTY('IsSingleUser') AS IsSingleUser
	--,SERVERPROPERTY('LCID') AS LCID
	--,SERVERPROPERTY('LicenseType') AS LicenseType
	--,SERVERPROPERTY('MachineName') AS MachineName
	--,SERVERPROPERTY('NumLicenses') AS NumLicenses
	--,SERVERPROPERTY('ProcessID') AS ProcessID
	,SERVERPROPERTY('ProductVersion') AS ProductVersion
	,SERVERPROPERTY('ProductLevel') AS ProductLevel
	--,SERVERPROPERTY('ResourceLastUpdateDateTime') AS ResourceLastUpdateDateTime
	--,SERVERPROPERTY('ResourceVersion') AS ResourceVersion
	--,SERVERPROPERTY('ServerName') AS ServerName
	--,SERVERPROPERTY('SqlCharSet') AS SqlCharSet
	--,SERVERPROPERTY('SqlCharSetName') AS SqlCharSetName
	--,SERVERPROPERTY('SqlSortOrder') AS SqlSortOrder
	--,SERVERPROPERTY('FilestreamShareName') AS FilestreamShareName
	--,SERVERPROPERTY('FilestreamConfiguredLevel') AS FilestreamConfiguredLevel
	--,SERVERPROPERTY('FilestreamEffectiveLevel') AS FilestreamEffectiveLevel
GO
USE master
EXEC xp_regread 'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\Microsoft SQL Server\110\Tools\Setup', 'DigitalProductID'
GO
