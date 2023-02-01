-- List Report Definitions
 
WITH XMLNAMESPACES
(
'http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition' AS REP
)
SELECT  c.Path ,
        c.Name ,
        DataSetXML.value('@Name', 'varchar(MAX)') DataSourceName ,
        DataSetXML.value('REP:Query[1]/REP:CommandText[1]', 'varchar(MAX)') CommandText
FROM    ( SELECT    ItemID ,
                    CAST(CAST(Content AS VARBINARY(MAX)) AS XML) ReportXML
          FROM      [ReportServer].[dbo].[Catalog]
          WHERE     Type = 2
        ) ReportXML
        CROSS APPLY ReportXML.nodes('//REP:DataSet') DataSetXML ( DataSetXML )
        INNER JOIN [ReportServer].[dbo].[Catalog] c ON ReportXML.ItemID = c.ItemID
 -- Search by part of the query text
WHERE   ( DataSetXML.value('REP:Query[1]/REP:CommandText[1]', 'varchar(MAX)') ) LIKE '% Enter object name here %'