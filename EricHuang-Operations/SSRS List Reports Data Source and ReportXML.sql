--Listing data sources and their dependencies 
SELECT
    DS.Name AS DatasourceName,
    C.Path AS DependentItemPath,
    C.Name AS DependentItemName,
	CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS ReportXML
FROM
    ReportServer.dbo.Catalog AS C 
	INNER JOIN ReportServer.dbo.Users AS CU
        ON C.CreatedByID = CU.UserID
    INNER JOIN ReportServer.dbo.Users AS MU
        ON C.ModifiedByID = MU.UserID
	LEFT OUTER JOIN ReportServer.dbo.SecData AS SD
        ON C.PolicyID = SD.PolicyID AND SD.AuthType = 1
	INNER JOIN ReportServer.dbo.DataSource AS DS
        ON C.ItemID = DS.ItemID
WHERE
    DS.Name IS NOT NULL
    
	--AND C.Path LIKE '%/QA/%'	
	--AND c.NAME LIKE '%4111%'

ORDER BY
    DS.Name;



SELECT DSID,
       ItemID,
       SubscriptionID,
       Name,
       Extension,
       Link,
       CredentialRetrieval,
       Prompt,
       ConnectionString,
       OriginalConnectionString,
       OriginalConnectStringExpressionBased,
       UserName,
       Flags,
       Version
FROM DataSource ds
