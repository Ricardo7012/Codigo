USE HSP_MO
GO
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationAccountTransactions'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationJobDetails'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationJobRecordMap'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationJobs'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationRateDetails'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationRateDetailsHistory'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationRateEntityMap'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationRateEntityMapHistory'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationRates'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationRecordPostAction'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationRecordPostActionHistory'

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM HSP_MO.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'CapitationRecords'


SELECT count(*)
  FROM [HSP_MO].[dbo].[CapitationRateDetails]

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT count(*)
  FROM [HSP_MO].[dbo].[CapitationRateEntityMap]

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT count(*)
  FROM [HSP_MO].[dbo].[CapitationRates]