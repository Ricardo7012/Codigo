SELECT  c.spid
       ,100 - a.percent_complete AS Countdown
       ,c.[status]
       ,a.command
       ,c.lastwaittype
       ,a.estimated_completion_time
       ,a.total_elapsed_time
       ,a.database_id
       ,b.name
FROM    sys.dm_exec_requests a
        INNER JOIN sysprocesses c ON a.command = c.cmd
                                     AND a.database_id = c.dbid
        LEFT OUTER JOIN sys.databases b ON a.database_id = b.database_id
--order by percent_complete desc
WHERE   a.command LIKE '%DBCC%';
