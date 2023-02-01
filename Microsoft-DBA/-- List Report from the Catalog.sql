-- List Report from the Catalog

-- Type
-- 1 Folder
-- 2 Report
-- 3 Resource
-- 4 Linked Report
-- 5 Data Source
-- 6 Model
-- report definition is stored as VARBINARY, so we need to convert it
-- to something readable
DECLARE @ReportType SMALLINT

SET @ReportType = 4


SELECT
    ItemID,
    [Path],
    [Name],
    CONVERT(VARCHAR(MAX),
            CONVERT(NVARCHAR(MAX),
            CONVERT(XML, CONVERT(VARBINARY(MAX), Content))))
 AS [ReportDefinition]
 
FROM [ReportServer].[dbo].[Catalog]
WHERE [Type] = ReportType