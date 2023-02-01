--CLAIMS LOAD CHECK
--Hey Ricardo – here you go.
--inner SELECT has a TOP 100 PERCENT option because of wanting to run it by itself or as CTE and you can’t do ORDER BY in inner query blah blah blah
--cannot USE database because it is different for each, well, database.
--will probably need to be tweaked as new data comes to light


;WITH CTE1 AS
       (

       SELECT TOP 100 PERCENT
              [Server] = @@SERVERNAME
              ,[Database] = DB_NAME()
              --,F.EDIFileID
              ,F.FileStatus
              ,F.ExternalFileName
              --,F.CreationDate
              ,F.NumberOfXacts
              --,F.ProcessedDate
              ,convert(datetime2(0),J.DateCreated,120) as DateCreated
              ,convert(datetime2(0),J.DateCompleted,120) as DateCompleted
              --,CAST(CAST(DATEDIFF(MILLISECOND, J.DateCreated, J.DateCompleted) AS numeric(15,3)) / 1000 AS numeric(15,3)) AS DurationMSEC
              ,F.InputTime
              ,U.Username
              --,J.ProcessingStatus

       from dbo.EDIFiles as F WITH (NOLOCK)
       LEFT OUTER JOIN dbo.EDIJobs AS J WITH (NOLOCK)
       ON F.EDIFileID = J.EDIFileId
       INNER JOIN dbo.Users AS U WITH (NOLOCK)
       ON F.LastUpdatedBy = u.UserID

       WHERE 1=1
       AND J.DateCreated >= '2018-03-15 11:00:00'
       --AND J.DateCreated <= '2018-03-15 03:00:00'
       AND F.FileStatus NOT IN ('CRT')
       ORDER BY U.Username, J.DateCreated
       --order by ExternalFileName
       --ORDER BY F.CreationDate --DESC
       --ORDER BY U.LastName, F.ProcessedDate
       --ORDER BY J.DateCreated desc
       --ORDER BY J.DateCompleted desc

       )

SELECT [Server]
       , [Database]
--     , DateReceived = MIN(CONVERT(date, CreationDate))
       , [Queue] = COALESCE(UserName,'TOTAL')
       , FileCount = COUNT(UserName)
       , ClaimCount = SUM(NumberOfXacts)
       --, ElapsedTimeInSeconds = SUM(COALESCE(DurationMSEC,0))
       , Duration = CONVERT(varchar, dateadd(MS,sum(COALESCE(InputTime,0))*1000,0),108)
FROM CTE1
GROUP BY [Server], [Database], UserName --WITH ROLLUP
ORDER BY UserName
