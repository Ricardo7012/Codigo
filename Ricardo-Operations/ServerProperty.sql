--select @@version
--go
-- https://sqlserverbuilds.blogspot.com/
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql
-- https://docs.microsoft.com/en-us/windows/release-information/
SELECT 
     SERVERPROPERTY('ServerName') as ServerName
	,OSVersion =RIGHT(@@version, LEN(@@version)- 3 -charindex (' ON ', @@VERSION))
	,CASE LEFT(CONVERT(VARCHAR, SERVERPROPERTY('ProductVersion')),4) 
	   WHEN '8.00' THEN 'SQL Server 2000'
	   WHEN '9.00' THEN 'SQL Server 2005'
	   WHEN '10.0' THEN 'SQL Server 2008'
	   WHEN '10.5' THEN 'SQL Server 2008 R2'
	   WHEN '11.0' THEN 'SQL Server 2012'
	   WHEN '12.0' THEN 'SQL Server 2014'
	   WHEN '13.0' THEN 'SQL Server 2016'
	   WHEN '14.0' THEN 'SQL Server 2017'
	   WHEN '15.0' THEN 'SQL Server 2019'
	   ELSE 'SQL Server 2019+'
	 END AS [SQLVersionBuild]
	,SERVERPROPERTY('Edition') as SQLEdition
	--,SERVERPROPERTY('EditionID') as SQLEditionID
	,SERVERPROPERTY('EngineEdition') as SQLEngineEdition	
	,SERVERPROPERTY('ProductVersion') as SQLProductVersion
	,SERVERPROPERTY('ProductLevel') as SQLProductLevel
	,SERVERPROPERTY('ProductBuild') as SQLProductBuild
	--,SERVERPROPERTY('ProductBuildType') as ProductBuildType
	,SERVERPROPERTY('ProductMajorVersion') as ProductMajorVersion
	,SERVERPROPERTY('ProductMinorVersion') as ProductMinorVersion
	,SERVERPROPERTY('ProductUpdateLevel') as ProductUpdateLevel
	,SERVERPROPERTY('ProductUpdateReference') as ProductUpdateReference
	,SERVERPROPERTY('BuildClrVersion') as BuildClrVersion	
	--,SERVERPROPERTY('Collation') as Collation
	--,SERVERPROPERTY('CollationID') as CollationID
	--,SERVERPROPERTY('ComparisonStyle') as ComparisonStyle
	--,SERVERPROPERTY('ComputerNamePhysicalNetBIOS') as ComputerNamePhysicalNetBIOS
	--,SERVERPROPERTY('HadrManagerStatus') as HadrManagerStatus
	--,SERVERPROPERTY('InstanceDefaultDataPath') as InstanceDefaultDataPath
	--,SERVERPROPERTY('InstanceDefaultLogPath') as InstanceDefaultLogPath
	--,SERVERPROPERTY('InstanceName') as InstanceName
	--,SERVERPROPERTY('IsAdvancedAnalyticsInstalled') as IsAdvancedAnalyticsInstalled
	--,SERVERPROPERTY('IsClustered') as IsClustered
	--,SERVERPROPERTY('IsFullTextInstalled') as IsFullTextInstalled
	--,SERVERPROPERTY('IsHadrEnabled') as IsHadrEnabled
	--,SERVERPROPERTY('IsIntegratedSecurityOnly') as IsIntegratedSecurityOnly
	--,SERVERPROPERTY('IsLocalDB') as IsLocalDB
	,SERVERPROPERTY('IsPolybaseInstalled') as IsPolybaseInstalled
	--,SERVERPROPERTY('IsSingleUser') as IsSingleUser
	--,SERVERPROPERTY('IsXTPSupported') as IsXTPSupported
	--,SERVERPROPERTY('LCID') as LCID
	,SERVERPROPERTY('LicenseType') as LicenseType
	--,SERVERPROPERTY('MachineName') as MachineName
	--,SERVERPROPERTY('NumLicenses') as NumLicenses
	,SERVERPROPERTY('ProcessID') as ProcessID
	,SERVERPROPERTY('ResourceLastUpdateDateTime') as ResourceLastUpdateDateTime
	,SERVERPROPERTY('ResourceVersion') as ResourceVersion
	--,SERVERPROPERTY('SqlCharSet') as SqlCharSet
	--,SERVERPROPERTY('SqlCharSetName') as SqlCharSetName
	--,SERVERPROPERTY('SqlSortOrder') as SqlSortOrder
	--,SERVERPROPERTY('SqlSortOrderName') as SqlSortOrderName
	--,SERVERPROPERTY('FilestreamShareName') as FilestreamShareName
	--,SERVERPROPERTY('FilestreamConfiguredLevel') as FilestreamConfiguredLevel
	--,SERVERPROPERTY('FilestreamEffectiveLevel') as FilestreamEffectiveLevel

GO
SELECT @@version 
GO
