--Listing data sources and their dependencies 
SELECT
    DS.Name AS DatasourceName,
    C.Path AS DependentItemPath,
    C.Name AS DependentItemName 
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
    --AND C.Path LIKE '/%'
ORDER BY
    DS.Name;
	--C.Path, C.Name;
    
    
--Listing data sources and their dependencies 
SELECT
    C2.Name AS Data_Source_Name,
    C.Name AS Dependent_Item_Name,
    C.Path AS Dependent_Item_Path
FROM
    ReportServer.dbo.DataSource AS DS
        INNER JOIN
    ReportServer.dbo.Catalog AS C
        ON
            DS.ItemID = C.ItemID
                AND
            DS.Link IN (SELECT ItemID FROM ReportServer.dbo.Catalog
                        WHERE Type = 5) --Type 5 identifies data sources
        FULL OUTER JOIN
    ReportServer.dbo.Catalog C2
        ON
            DS.Link = C2.ItemID
WHERE
    C2.Type = 5 --Type 5 identifies data sources
ORDER BY
    C2.Name ASC,
    C.Name ASC;


--Find the procedure names that are being used in the reports
;WITH XMLNAMESPACES 
( DEFAULT 
  'http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition'
, 'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS ReportDefinition )
SELECT  
	CATDATA.Name AS ReportName
	,CATDATA.Path AS ReportPathLocation
	,xmlcolumn.value('(@Name)[1]', 'VARCHAR(250)') AS DataSetName  
	,xmlcolumn.value('(Query/DataSourceName)[1]','VARCHAR(250)') AS DataSoureName 
	,xmlcolumn.value('(Query/CommandText)[1]','VARCHAR(2500)') AS CommandText
FROM (  
		SELECT C.Name
		,c.Path
		,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
		FROM  ReportServer.dbo.Catalog C
		WHERE  C.Content is not null
		AND  C.Type = 2
	) CATDATA
CROSS APPLY reportXML.nodes('/Report/DataSets/DataSet') xmltable ( xmlcolumn )
WHERE xmlcolumn.value('(Query/CommandText)[1]','VARCHAR(2500)') LIKE '%usp_OaMembershipByLanguage%'
ORDER BY CATDATA.Name



--Find all the adhoc sql used in reports
;WITH XMLNAMESPACES
(
	DEFAULT 
	'http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition',
	'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd
)
SELECT name
	, x.value('CommandType[1]', 'VARCHAR(50)') AS CommandType
	, x.value('CommandText[1]','VARCHAR(50)') AS CommandText
	, x.value('DataSourceName[1]','VARCHAR(50)') AS DataSource
FROM (
	SELECT name
		, CAST(CAST(content AS VARBINARY(MAX)) AS XML) AS reportXML 
	FROM ReportServer.dbo.Catalog 
	WHERE content IS NOT NULL
	AND type != 3) a
CROSS APPLY reportXML.nodes('/Report/DataSets/DataSet/Query') r(x)
WHERE x.value('CommandType[1]', 'VARCHAR(50)') IS NULL 
ORDER BY name




--Find all the reports, and thier parameters and thier default values
;WITH XMLNAMESPACES (
DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition',
		'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd --ReportDefinition
)
SELECT 
   NAME
   , PATH
   , x.value ('@Name', 'VARCHAR(100)') AS ReportParameterName
   , x.value ('DataType[1]', 'VARCHAR(100)') AS DataType
   , x.value ('AllowBlank[1]', 'VARCHAR(50)') AS AllowBlank
   , x.value ('Prompt[1]', 'VARCHAR(100)') AS Prompt
   , x.value ('Hidden[1]', 'VARCHAR(100)') AS Hidden
   , x.value ('data(DefaultValue/Values/Value)[1]', 'VARCHAR(100)') AS Value
FROM (
   SELECT  PATH
           , NAME
           , CAST(CAST(content AS VARBINARY(MAX)) AS XML) AS ReportXML 
   FROM ReportServer.dbo.Catalog 
   WHERE CONTENT IS NOT NULL AND TYPE = 2
   ) A
CROSS APPLY ReportXML.nodes('/Report/ReportParameters/ReportParameter') R(x)
--WHERE NAME = 'Sales_Report'
--Use the where clause above to look for a specific report
ORDER BY NAME





-- 1. To View the Report code in XML format from content field in Catalog Table
SELECT  Name,Convert(XML,(Convert(VARBINARY(MAX),Content))) AS ReportXML
  FROM  ReportServer.dbo.Catalog
 WHERE  Content IS NOT NULL
   AND  [Type] = 2 -- For Report objects alone


-- 2. Get the Report's Created/Modified User and Created/Modified Dates.
SELECT Name
      ,CreatedBy = U.UserName
      ,CreationDate = C.CreationDate
      ,ModifiedBy = UM.UserName
      ,ModifiedDate
  FROM Reportserver.dbo.Catalog C
  JOIN Reportserver.dbo.Users U
    ON C.CreatedByID = U.UserID
  JOIN Reportserver.dbo.Users UM
    ON c.ModifiedByID = UM.UserID
 WHERE Name = 'ReportName'


-- 3. Get the List of Report Parameters for the given Report
SELECT  Name = Paravalue.value('Name[1]', 'VARCHAR(250)')
       ,Type = Paravalue.value('Type[1]', 'VARCHAR(250)')
       ,Nullable = Paravalue.value('Nullable[1]', 'VARCHAR(250)')
       ,AllowBlank = Paravalue.value('AllowBlank[1]', 'VARCHAR(250)')
       ,MultiValue = Paravalue.value('MultiValue[1]', 'VARCHAR(250)')
       ,UsedInQuery = Paravalue.value('UsedInQuery[1]', 'VARCHAR(250)')
       ,Prompt = Paravalue.value('Prompt[1]', 'VARCHAR(250)')
       ,DynamicPrompt = Paravalue.value('DynamicPrompt[1]', 'VARCHAR(250)')
       ,PromptUser = Paravalue.value('PromptUser[1]', 'VARCHAR(250)')
       ,State = Paravalue.value('State[1]', 'VARCHAR(250)')
 FROM (
     SELECT C.Name,CONVERT(XML,C.Parameter) AS ParameterXML
       FROM  ReportServer.dbo.Catalog C
      WHERE  C.Content is not null
        AND  C.Type  = 2
        AND  C.Name  =  'ReportName'
    ) a
CROSS APPLY ParameterXML.nodes('//Parameters/Parameter') p ( Paravalue )


-- 4. Get the Data Sources used in the Report
-- Note : The XML Schema used here is for SQL 2008 R2. 
--You need to change it to make it work for other versions. To see the schema use the first query in the samples list.

WITH XMLNAMESPACES (
DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition', 
		'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd )
SELECT  ReportName     = name
       ,DataSourceName   = x.value('(@Name)[1]', 'VARCHAR(250)')
       ,DataProvider   = x.value('(ConnectionProperties/DataProvider)[1]','VARCHAR(250)')
       ,ConnectionString = x.value('(ConnectionProperties/ConnectString)[1]','VARCHAR(250)')
  FROM (  SELECT C.Name,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
           FROM  ReportServer.dbo.Catalog C
          WHERE  C.Content is not null
            AND  C.Type  = 2
      AND  C.Name  = 'ReportName'
        ) a
  CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource') r ( x )
 ORDER BY name ;


-- 5. Get the Data Sets used in the Report.
--Note : The XML Schema used here is for SQL 2011. You need to change it to make it work for other versions. 
--To see the schema use the first query in the samples list.
WITH XMLNAMESPACES (
DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition', 
		'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd )
SELECT  ReportName    = name
       ,DataSetName    = x.value('(@Name)[1]', 'VARCHAR(250)')
       ,DataSourceName  = x.value('(Query/DataSourceName)[1]','VARCHAR(250)')
       ,CommandText    = x.value('(Query/CommandText)[1]','VARCHAR(250)')
       ,Fields      = df.value('(@Name)[1]','VARCHAR(250)')
       ,DataField    = df.value('(DataField)[1]','VARCHAR(250)')
       ,DataType    = df.value('(rd:TypeName)[1]','VARCHAR(250)')
  FROM (  SELECT C.Name,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
           FROM  ReportServer.dbo.Catalog C
          WHERE  C.Content is not null
            AND  C.Type = 2
         AND  C.Name = 'ReportName'
     ) a
  CROSS APPLY reportXML.nodes('/Report/DataSets/DataSet') r ( x )
  CROSS APPLY x.nodes('Fields/Field') f(df)
ORDER BY name


-- 6. Get the list of Data Sources used by Reports using DataSources Table.
SELECT D.Name
       ,'Using Report '
      = CASE
        WHEN D.Name IS NOT NULL THEN  C.Name
        ELSE 'Shared Data Source'
        END
      ,'IsSharedDataSource' = CLink.Name
     FROM DataSource D
     JOIN Catalog C
     ON D.ItemID = C.ItemID
LEFT JOIN Catalog CLink
     ON Clink.ItemID = D.Link
  WHERE C.Name = 'ReportName'


-- 7. Get the Schedule List with type and Recurrence
SELECT Name
    ,StartDate
    ,EndDate
    ,NextRunTime
    ,LastRunTime
    ,LastRunStatus
    ,RecurrenceType = CASE RecurrenceType
            WHEN  1 THEN 'Once'
            WHEN  2 THEN 'Hourly '
            WHEN  4 THEN 'Daily / Weekly'
            WHEN  6 THEN 'Monthly'
            End
   ,EventType
FROM Schedule


-- 8. Query to get the list of Subscription and it's schedule for a given report
SELECT Reportname = c.Name
      ,SubscriptionDesc=su.Description
      ,Subscriptiontype=su.EventType
      ,su.LastStatus
      ,su.LastRunTime
      ,su.Parameters
      ,Schedulename=sch.Name
      ,sch.Type
      ,sch.EventType
  FROM Subscriptions su
  JOIN Catalog c
    ON su.Report_OID = c.ItemID
  JOIN ReportSchedule rsc
    ON rsc.ReportID = c.ItemID
   AND rsc.SubscriptionID = su.SubscriptionID
  JOIN Schedule Sch
    ON rsc.ScheduleID = sch.ScheduleID
 WHERE c.Name = '@ReportName'


--9. Query to get the notification details sent for the given report
SELECT C.Name
      ,S.Description
      ,N.NotificationEntered
      ,A.TotalNotifications
      ,A.TotalSuccesses
      ,A.TotalFailures
  FROM Notifications N
  JOIN ActiveSubscriptions A
    ON N.SubscriptionID = A.SubscriptionID
   AND N.ActivationID = A.ActiveID
  JOIN Catalog C
    ON C.ItemID = N.ReportID
  JOIN Subscriptions S
    ON S.SubscriptionID = N.SubscriptionID
 WHERE c.Name = '@ReportName'

 
 --10. Get the users and their roles mapped for the reports
 SELECT c.name,
       u.username,
       u.authtype,
       r.rolename,
       r.DESCRIPTION
 FROM users u
 JOIN policyuserrole pur
   ON u.userid = pur.userid
 JOIN policies p
   ON p.policyid = pur.policyid
 JOIN roles r
   ON r.roleid = pur.roleid
 JOIN catalog c
   ON c.policyid = p.policyid
WHERE c.TYPE = 2 -- For Reports Only
ORDER BY name,username 


--11. Get the Cache Policy for the Reports
SELECT c.name,
       cp.cacheexpiration,
       cp.expirationflags
 FROM  cachepolicy cp
 JOIN  catalog c
   ON  c.itemid = cp.reportid


--12. Get the Security Details XML from SecData Table
 SELECT c.name,
       CONVERT(XML, sec.xmldescription)
  FROM catalog c
  JOIN secdata sec
    ON c.policyid = sec.policyid
 WHERE c.TYPE = 2 


--13. Get the Model Item's User and Role
SELECT c.name,
       mip.modelitemid,
       u.username,
       r.rolename
  FROM catalog c
  JOIN modelitempolicy mip
    ON c.itemid = mip.catalogitemid
  JOIN policies p
    ON p.policyid = mip.policyid
  JOIN policyuserrole pur
    ON p.policyid = pur.policyid
  JOIN users u
    ON u.userid = pur.userid
  JOIN roles r
    ON r.roleid = pur.roleid 


--14. Get the details of the history pf the snapshot with report name and schedule used to create the snapshot
SELECT c.name,
       h.snapshotdate,
       s.DESCRIPTION,
       s.effectiveparams,
       s.queryparams,
       sc.name,
       sc.nextruntime
  FROM history h
  JOIN snapshotdata s
    ON h.snapshotdataid = s.snapshotdataid
  JOIN catalog c
    ON c.itemid = h.reportid
  JOIN reportschedule rs
    ON rs.reportid = h.reportid
  JOIN schedule sc
    ON sc.scheduleid = rs.scheduleid
 WHERE rs.reportaction = 2 -- Create schedule


--15. Get the execution details of a given report with the details like User executing the report , Execution time etc
SELECT c.name,
       CASE e.requesttype
       WHEN 1 THEN 'Subscription'
       WHEN 0 THEN 'Report Launch'
       ELSE ''
       END,
       e.*
  FROM executionlog e
  JOIN catalog c
    ON e.reportid = c.itemid
 WHERE c.name = N'@Reportname' 






--List all users and thier roles in Reporting Server
SELECT UserName
	, RoleName
	, Description 
FROM ReportServer.dbo.Roles r JOIN ReportServer.dbo.PolicyUserRole pur
    ON r.roleid = pur.roleid
    JOIN ReportServer.dbo.Users u
    ON pur.userid = u.userid
    WHERE UserName NOT IN ('BUILTIN\Administrators', 'Domain Users')
    ORDER BY UserName


--List all the rendering types and thier counts used in reports like excel, pdf
SELECT format
	, count(1) as cnt
FROM ReportServer.dbo.ExecutionLog
GROUP BY format
ORDER BY cnt
