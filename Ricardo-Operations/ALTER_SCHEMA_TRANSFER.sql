SELECT 'ALTER SCHEMA dbo TRANSFER ' + s.Name + '.' + o.Name
FROM sys.Objects o
INNER JOIN sys.Schemas s on o.schema_id = s.schema_id
WHERE s.Name LIKE'IEHP%'
And (o.Type = 'U' Or o.Type = 'P' Or o.Type = 'V')

ALTER SCHEMA dbo TRANSFER [IEHP\c1305].usp_excelTest
ALTER SCHEMA dbo TRANSFER [IEHP\c1283].ProviderAddressRiskGroupDataByFileid
ALTER SCHEMA dbo TRANSFER [IEHP\c1283].ClaimComplete__ClaimCARCsRARCs
ALTER SCHEMA dbo TRANSFER [IEHP\c1230].[SQL Server Destination]
