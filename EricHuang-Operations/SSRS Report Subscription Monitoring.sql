SELECT  s.*
FROM ReportServer.dbo.Subscriptions AS s 
WHERE s.DataSettings IS NOT NULL;


--List all the report subscriptions
SELECT 
	s.SubscriptionID,
	DataSettings,
	'SubnDesc' = s.Description,
	'SubnOwner' = us.UserName,
	'LastStatus' = s.LastStatus,
	'LastRun' = s.LastRunTime,
	'ReportPath' = c.Path,
	'ReportModifiedBy' = uc.UserName,
	'ScheduleId' = rs.ScheduleId,
	'SubscriptionId' = s.SubscriptionID,
	'SubscriptionSettings' = s.ExtensionSettings
FROM ReportServer.dbo.Subscriptions s WITH(NOLOCK)
INNER JOIN ReportServer.dbo.CATALOG c WITH(NOLOCK) ON c.ItemID = s.Report_OID
INNER JOIN ReportServer.dbo.ReportSchedule rs WITH(NOLOCK) ON rs.SubscriptionID = s.SubscriptionID
INNER JOIN ReportServer.dbo.Users uc WITH(NOLOCK) ON uc.UserID = c.ModifiedByID
INNER JOIN ReportServer.dbo.Users us WITH(NOLOCK) ON us.UserID = s.OwnerId
--INNER JOIN msdb.dbo.sysjobs j WITH(NOLOCK) ON j.NAME = CONVERT(NVARCHAR(128), rs.ScheduleId)
WHERE 
	s.DataSettings IS NOT NULL
	AND s.[Description] LIKE 'CFG_3%'
	--sample id complaining sql agent not running
	--AND s.SubscriptionID = '7842b9e3-a757-45b5-b224-f5e225069f5d'



--List the susbcriptions being processed or in queue for processing
--Review for backlog of reports
SELECT
	'Report' = c.Path,
	'Subscription' = s.Description,
	'SubscriptionOwner' = uo.UserName,
	'SubscriptionModBy' = um.UserName,
	'SubscriptionModDate' = s.ModifiedDate,
	'ProcessStart' = dateadd(hh, DATEDIFF(hh, Getutcdate(), Getdate()), n.ProcessStart),
	'NotificationEntered' = dateadd(hh, DATEDIFF(hh, Getutcdate(), Getdate()), n.NotificationEntered),
	'ProcessAfter' = dateadd(hh, DATEDIFF(hh, Getutcdate(), Getdate()), n.ProcessAfter),
	n.Attempt,
	'SubscriptionLastRunTime' = dateadd(hh, DATEDIFF(hh, Getutcdate(), Getdate()), n.SubscriptionLastRunTime),
	n.IsDataDriven,
	'ProcessHeartbeat' = dateadd(hh, DATEDIFF(hh, Getutcdate(), Getdate()), n.ProcessHeartbeat),
	n.Version,
	n.SubscriptionID
FROM ReportServer.dbo.Notifications n WITH(NOLOCK)
INNER JOIN ReportServer.dbo.Subscriptions s WITH(NOLOCK) ON n.SubscriptionID = s.SubscriptionID
INNER JOIN ReportServer.dbo.CATALOG c WITH(NOLOCK) ON c.ItemID = n.ReportID
INNER JOIN ReportServer.dbo.Users uo WITH(NOLOCK) ON uo.UserID = s.OwnerID
INNER JOIN ReportServer.dbo.Users um WITH(NOLOCK) ON um.UserID = s.ModifiedByID


--List failed or errored reports
SELECT s.LastRunTime,
	s.LastStatus,
	s.Description,
	c.Path,
	c.NAME,
	u.UserName AS SubscriptionOwner
FROM ReportServer.dbo.subscriptions s
INNER JOIN ReportServer.dbo.users u ON s.OwnerId = u.UserId
INNER JOIN ReportServer.dbo.CATALOG c ON s.Report_OID = c.ItemID
WHERE LastStatus LIKE '%Failure%'
	OR LastStatus LIKE '%Error%'
	OR LastStatus LIKE '%The e-mail address of one or more recipients is not valid.%'
	OR LastStatus LIKE '%Thread was being aborted.%'
	OR LastStatus LIKE '%SQLAgent%'
	OR LastStatus LIKE '%Fail%'
ORDER BY LastRunTime
