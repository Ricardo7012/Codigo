SELECT DISTINCT [DatabaseName]
--      ,[LastUpdatedAt]
FROM [HSPLicensing].[dbo].[BuildLicenseKeys]
 
SELECT DISTINCT [DatabaseName]
      ,[LastUpdatedAt]
  FROM [HSPLicensing].[dbo].[LicenseKeys]
 
SELECT TOP 1 [LastUpdatedAt] 
FROM [HSPLicensing].[dbo].[BuildLicenseKeys]

use HSPLicensing
go

;WITH CTE1 AS
       (SELECT distinct DatabaseName FROM [dbo].[Seats])
,
CTE2 AS
       (SELECT DatabaseName, COUNT(1) AS #LicenseKeys FROM dbo.LicenseKeys GROUP BY DatabaseName)

SELECT CTE1.DatabaseName, CTE2.#LicenseKeys
FROM CTE1 LEFT OUTER JOIN CTE2
ON CTE1.DatabaseName = CTE2.DatabaseName
ORDER BY CTE1.DatabaseName

SELECT DISTINCT [DatabaseName]
FROM [HSPLicensing].[dbo].[LicenseKeys]

--CHECK LICENSE EXISTENCE 
SELECT [LicenseKeyId]
,[RequestId]
,[ServerName]
,[DatabaseName]
,[ApplicationName]
,[LicenseKey]
,[LastUpdatedAt]
FROM [HSPLicensing].[dbo].[LicenseKeys]
GO