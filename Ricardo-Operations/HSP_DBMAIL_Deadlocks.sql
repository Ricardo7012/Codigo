-- **********************************************************************************
-- # 1 THE SERVER SHOULD ALSO HAVE THE BLOCKED PROCESS THRESHOLD SET TO A VALUE OF 8.
-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/blocked-process-threshold-server-configuration-option 

--sp_configure 'show advanced options', 1 ;  
--GO  
--RECONFIGURE   
--GO  
--sp_configure 'blocked process threshold', 8 ;  
--GO  
--RECONFIGURE 
--GO  
-- sp_configure 'show advanced options', 0 ;  
--RECONFIGURE   
--GO  
-- **********************************************************************************
--#2 AND THE BLOCKED PROCESS EVENT WOULD NEED TO BE IN THE SYSTEM HEALTH EVENT
--ALTER EVENT SESSION [system_health] ON SERVER 
--ADD EVENT sqlserver.blocked_process_report
--GO
-- **********************************************************************************
USE [msdb]
GO

/****** Object:  Job [HSP Blocked Process Report]    Script Date: 1/11/2018 9:32:24 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 1/11/2018 9:32:24 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'HSP_DBMAIL_Blocked Process Report', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'HSP daily blocking report - Jan 2018.
@notify_level_email=1 -- Notify on success
[@notify_level_email=2 -- Notify on failure]
@notify_level_email=3 -- Notify on completion
BY: GEORGE SCAFF', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'_system_admin', 
		@notify_email_operator_name=N'', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Blocked process report]    Script Date: 1/11/2018 9:32:24 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Blocked process report', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET quoted_identifier on
SET nocount on
SET transaction isolation level read uncommitted

----------------------------------------
---------- Declare Variables -----------
----------------------------------------
DECLARE
	@FilePath						nvarchar(max),
	@CurrentDate					datetime,
	@tableHTML						nvarchar(max),
	@Debug							int,
	@Column1Name					varchar(255),
	@Query							nvarchar(max)


----------------------------------------
--------- Set Log File Path ------------ 
----------------------------------------
SET @FilePath = ''E:\DATA\MSSQL13.MSSQLSERVER\MSSQL\Log\*.xel''


----------------------------------------
--- Set Debug Flag -- Off(0) or ON(1)--- 
----------------------------------------
SELECT @Debug = 0


----------------------------------------
--------- Cleanup Old Tables ----------- 
----------------------------------------
IF object_id(''tempdb..#ReportsXML'') is not null
              drop table #ReportsXML
IF object_id(''tempdb..#DistinctTemp'') is not null
              drop table #DistinctTemp
IF object_id(''tempdb..##EmailAttachment'') is not null
			  drop table ##EmailAttachment


----------------------------------------
-------- Declare source tables ---------
----------------------------------------
--DECLARE @BlockedXMLData table
--(
--	Target_Data XML
--)

--------------------------------------------
DECLARE @FullBlocking table
(
	xactrank							bigint,
	BlockedProcessDBname				varchar(255),
	BlockedProcessLastBatchStarted		datetime,
	BlockedProcessWaitTime				int,
	BlockedProcessSPID					int,
	BlockedProcessInputBuf				varchar(max),
	BlockedProcessTransactionName		varchar(255),
	BlockedProcessHostname				varchar(255),
	BlockedProcessLoginname				varchar(255),
	BlockedProcessApplication			varchar(255),
	BlockedProcessIsolationLevel		varchar(255),
	BlockedProcessLockMode				varchar(255),
	WaitResource						varchar(255),
	BlockedObjectname					varchar(255),
	BlockedStatementText				varchar(max),
	BlockedEncrypted					varchar(255),
	BlockedStatementOffsets				varchar(255),
	Divider								varchar(128),
	BlockingProcessDBname				varchar(255),
	BlockingProcessInputBuf				varchar(max),
	BlockingProcessLastBatchStarted		datetime,
	BlockingProcessHostname				varchar(255),
	BlockingProcessSessionID			varchar(255),
	BlockingProcessUserID				varchar(255),
	BlockingProcessUsername				varchar(255),
	BlockingProcessTranCount			int,
	BlockingProcessObjectname			varchar(255),
	BlockingProcessLockMode				varchar(255),
	BlockingProcessSPID					int,
	BlockingProcessLoginName			varchar(255),
	BlockingProcessApplication			varchar(255),
	BlockingStatementText				varchar(max),
	BlockingStatementOffsets			varchar(255),
	BlockingEncrypted					varchar(255)
)

--------------------------------------------
CREATE TABLE #ReportsXML
       (
             
			blocked_xactid						bigint						NULL, 
			blocked_spid						int							NULL,
			blocking_xactid						bigint						NULL,
			blocking_spid						int							NULL, 
 			lastbatchstarted					datetime					NULL,
            lastbatchcompleted					datetime					NULL,
            blocking_inputbuf					varchar(max)				NULL,
			blocking_sessionID					varchar(255)				NULL,
			blocking_userID						varchar(255)				NULL,
			blocking_username					varchar(255)				NULL,
            bpReportXml							xml							NOT NULL            
       )

--------------------------------------------
CREATE TABLE #DistinctTemp
       (
             
			blocking_xactid						bigint						 NULL,
			blocking_spid						int							 NULL, 
 			lastbatchstarted					datetime					NULL,
            lastbatchcompleted					datetime					NULL,
            blocking_inputbuf					varchar(max)				NULL,
			blocking_sessionID					varchar(255)				NULL,
			blocking_userID						varchar(255)				NULL,
			blocking_username					varchar(255)				NULL,
			directblocks						bigint						null,				
			indirectblocks						bigint						null
       )


----------------------------------------
-------- Populate source tables ---------
----------------------------------------
--INSERT INTO @BlockedXMLData
--SELECT Target_Data
--	        FROM (
--	              SELECT CAST(event_data AS xml) AS Target_Data
--                  FROM sys.fn_xe_file_target_read_file(@FilePath,NULL,NULL, NULL)
--            ) AS XML_Data

--------------------------------------------
INSERT INTO @FullBlocking

SELECT *
FROM (
       SELECT  
                     Row_Number() over (partition by xed.value(''(./blocked-process/process/@xactid)[1]'', ''bigint'') order by xed.value(''(./blocked-process/process/@waittime)[1]'', ''int'') desc) xactRank, 
                     db_name(xed.value(''(./blocked-process/process/@currentdb)[1]'', ''int'')) [blocked-process-dbname],
                     xed.value(''(./blocked-process/process/@lastbatchstarted)[1]'', ''datetime'') [blocked-process-lastbatchstarted],
                     xed.value(''(./blocked-process/process/@waittime)[1]'', ''int'')/1000.00 [blocked-process-waittime(s)],
                     xed.value(''(./blocked-process/process/@spid)[1]'', ''int'') [blocked-process-spid],
                     xed.value(''(./blocked-process/process/inputbuf)[1]'', ''varchar(max)'') [blocked-process-inputbuf],
                     xed.value(''(./blocked-process/process/@transactionname)[1]'', ''varchar(255)'') [blocked-process-transactionname],
					 xed.value(''(./blocked-process/process/@hostname)[1]'', ''varchar(255)'') [blocked-process-hostname],
                     xed.value(''(./blocked-process/process/@loginname)[1]'', ''varchar(255)'') [blocked-process-loginname],
					 xed.value(''(./blocked-process/process/@clientapp)[1]'', ''varchar(255)'') [blocked-process-application],
                     xed.value(''(./blocked-process/process/@isolationlevel)[1]'', ''varchar(255)'') [blocked-process-isolationlevel],
                     xed.value(''(./blocked-process/process/@lockMode)[1]'', ''varchar(255)'') [blocked-process-lockmode],
                     wt.waitresource [wait-resource],
					 case 
                           when wt.waitresource like ''OBJECT: %'' then
                                  object_name(parsename(replace(wt.waitresource, '':'',''.''),2), parsename(replace(wt.waitresource, '':'',''.''),3))
                           when wt.waitresource like ''KEY:%'' then
                                  (SELECT top 1 obj.name + ''.'' + ind.name
                                         FROM sys.partitions par JOIN sys.objects obj ON par.OBJECT_ID = obj.OBJECT_ID
                                         JOIN sys.indexes ind ON par.OBJECT_ID = ind.OBJECT_ID  AND par.index_id = ind.index_id
                                         WHERE par.hobt_id = parsename(replace(replace(replace(wt.waitresource, '': '',''.''),'':'',''.''),'' '',''.''),2)
                                                              )
                           else
                                  wt.waitresource
                                                         
                     end [blocked-objectname],
                    SUBSTRING(s.text, (frm.statement_start_offset/2)+1, 
                    (abs((CASE 
                        WHEN frm.statement_end_offset = -1 THEN DATALENGTH(s.text)
                                         WHEN (frm.statement_end_offset <= frm.statement_start_offset) THEN DATALENGTH(s.text)
                    ELSE frm.statement_end_offset
                    END - frm.statement_start_offset)/2) + 1)) [blocked-statement-text],
                     s.encrypted [blocked-encrypted],
                                  convert(varchar(10), frm.statement_start_offset) + ''-'' + convert(varchar(10), frm.statement_end_offset) [blocked-statement-offsets],
                     ''<---->'' [<----->],
                     db_name(xed.value(''(./blocking-process/process/@currentdb)[1]'', ''int'')) [blocking-process-dbname],
                     xed.value(''(./blocking-process/process/inputbuf)[1]'', ''varchar(max)'') [blocking-process-inputbuf],
                     xed.value(''(./blocking-process/process/@lastbatchstarted)[1]'', ''datetime'') [blocking-process-lastbatchstarted],
                     xed.value(''(./blocking-process/process/@hostname)[1]'', ''varchar(255)'') [blocking-process-hostname],
					 NULL [BlockingProcessSessionID],
					 NULL [BlockingProcessUserID],
					 NULL [BlockingProcessUsername],	 
					 xed.value(''(./blocking-process/process/@trancount)[1]'', ''int'') [blocking-process-trancount],
					 OBJECT_NAME(s2.objectid) [blocking-process-object-name],
					 xed.value(''(./blocking-process/process/@lockMode)[1]'', ''varchar(255)'') [blocking-process-lockmode],
                     xed.value(''(./blocking-process/process/@spid)[1]'', ''int'') [blocking-process-spid],
                     xed.value(''(./blocking-process/process/@loginname)[1]'', ''varchar(255)'') [blocking-process-loginname],
					 xed.value(''(./blocking-process/process/@clientapp)[1]'', ''varchar(255)'') [blocking-process-application],
			         SUBSTRING(s2.text, (frm2.statement_start_offset/2)+1,
							(abs((CASE 
                        WHEN frm2.statement_end_offset = -1 THEN DATALENGTH(s2.text)
                            WHEN (frm2.statement_end_offset <= frm2.statement_start_offset) THEN DATALENGTH(s2.text)
						ELSE frm2.statement_end_offset
							END - frm2.statement_start_offset)/2) + 1)) [blocking-statement-text],
                     convert(varchar(10), frm2.statement_start_offset) + ''-'' + convert(varchar(10), frm2.statement_end_offset) [blocking-statement-offsets],
                     s2.encrypted [blocking-encrypted]
                    
					from (
                            SELECT CAST(event_data AS xml) AS Target_Data
                            FROM sys.fn_xe_file_target_read_file(@FilePath,NULL,NULL, NULL)
                    ) AS XML_Data
       cross apply Target_Data.nodes(''//blocked-process-report'') AS XEventData(xed)
       cross apply (select xed.value(''(./blocked-process/process/@waitresource)[1]'', ''varchar(255)'') [waitresource]) wt
       outer apply 
              (
                     SELECT 
                     convert(varbinary(64), xed.value(''(./blocked-process/process/executionStack/frame/@sqlhandle)[1]'', ''varchar(max)''),1) [sqlhandle],
                     xed.value(''(./blocked-process/process/executionStack/frame/@stmtstart)[1]'', ''int'') [statement_start_offset],
                     xed.value(''(./blocked-process/process/executionStack/frame/@stmtend)[1]'', ''int'') [statement_end_offset]
              ) frm 
       outer apply sys.dm_exec_sql_text(frm.sqlhandle) s
                 outer apply 
              (
                     SELECT 
                     convert(varbinary(64), xed.value(''(./blocking-process/process/executionStack/frame/@sqlhandle)[1]'', ''varchar(max)''),1) [sqlhandle],
                     xed.value(''(./blocking-process/process/executionStack/frame/@stmtstart)[1]'', ''int'') [statement_start_offset],
                     xed.value(''(./blocking-process/process/executionStack/frame/@stmtend)[1]'', ''int'') [statement_end_offset]
              ) frm2 
       outer apply sys.dm_exec_sql_text(frm2.sqlhandle) s2
) BlockingData
WHERE xactRank = 1
ORDER BY [blocked-process-lastbatchstarted]
OPTION (recompile)

UPDATE @FullBlocking
	SET BlockingProcessSessionID = try_convert(int, case when charindex(''@Sessionid'',replace(BlockingProcessInputBuf,'' '',''''),0) != 0 
                     then replace(rtrim(ltrim(substring(replace(BlockingProcessInputBuf,'' '',''''),( charindex(''='',replace(BlockingProcessInputBuf,'' '',''''),charindex(''@Sessionid'',replace(BlockingProcessInputBuf,'' '',''''),0) )+1 ),case when 
                     ((case when charindex('','',replace(BlockingProcessInputBuf,'' '',''''),charindex(''='',replace(BlockingProcessInputBuf,'' '',''''),charindex(''@Sessionid'',replace(BlockingProcessInputBuf,'' '',''''),0) ) ) = 0 then len(replace(BlockingProcessInputBuf,'' '','''')) +1 
                     else charindex('','',replace(BlockingProcessInputBuf,'' '',''''),charindex(''='',replace(BlockingProcessInputBuf,'' '',''''),charindex(''@Sessionid'',replace(BlockingProcessInputBuf,'' '',''''),0) ) ) end)-1) - 
                     (charindex(''='',replace(BlockingProcessInputBuf,'' '',''''),charindex(''@Sessionid'',replace(BlockingProcessInputBuf,'' '',''''),0) ) )<0 then 0 else ((case when charindex('','',replace(BlockingProcessInputBuf,'' '',''''),
                     charindex(''='',replace(BlockingProcessInputBuf,'' '',''''),charindex(''@Sessionid'',replace(BlockingProcessInputBuf,'' '',''''),0) ) ) = 0 then len(replace(BlockingProcessInputBuf,'' '',''''))+1 else charindex('','',replace(BlockingProcessInputBuf,'' '',''''),
                     charindex(''='',replace(BlockingProcessInputBuf,'' '',''''),charindex(''@Sessionid'',replace(BlockingProcessInputBuf,'' '',''''),0) ) ) end)-1) - 
                     (charindex(''='',replace(BlockingProcessInputBuf,'' '',''''),charindex(''@Sessionid'',replace(BlockingProcessInputBuf,'' '',''''),0) ) )end))),''null'',0)else 0 end)

UPDATE f
	SET f.BlockingProcessUserID = s.userid
		FROM @FullBlocking f
		inner join sessions s
		on f.BlockingProcessSessionID = s.SessionID
	
UPDATE f
	SET f.BlockingProcessUsername = u.Firstname + '' '' + u.LastName + '' ('' + u.username + '')'' 
		FROM @FullBlocking f 
		inner join users u
		ON u.userID = f.BlockingProcessUserID

--------------------------------------------
INSERT INTO #ReportsXML
       (
             blocked_xactid,
             blocked_spid,
             blocking_xactid,
             blocking_spid,
             lastbatchstarted,
             lastbatchcompleted,
             blocking_inputbuf,
             bpReportXml
       )
	   SELECT 
              blocked_xactid
              ,blocked_spid
              ,blocking_xactid
              ,blocking_spid
              ,lastbatchstarted
              ,lastbatchcompleted
	          ,blocking_inputbuf
              ,bpReportXml.query(''.'')
       FROM (
            SELECT CAST(event_data AS xml) AS Target_Data
            FROM sys.fn_xe_file_target_read_file(@FilePath,NULL,NULL, NULL)
              ) as XML_Data
       cross apply Target_Data.nodes(''//blocked-process-report'') AS bpReports(bpReportXml)
       cross apply (
              SELECT 
                     blocked_spid = bpReportXml.value(''(./blocked-process/process/@spid)[1]'', ''int''),
                     blocked_xactid = bpReportXml.value(''(./blocked-process/process/@xactid)[1]'', ''bigint''),
                     blocking_spid = bpReportXml.value(''(./blocking-process/process/@spid)[1]'', ''int''),
                     blocking_xactid = bpReportXml.value(''(./blocking-process/process/@xactid)[1]'', ''bigint''),
                     lastbatchcompleted = bpReportXml.value(''(./blocked-process/process/@lastbatchcompleted)[1]'', ''datetime''),
                     lastbatchstarted = bpReportXml.value(''(./blocked-process/process/@lastbatchstarted)[1]'', ''datetime''),
                     blocking_inputbuf = bpReportXml.value(''(./blocking-process/process/inputbuf)[1]'', ''varchar(max)'')
              ) AS bpShredded
              WHERE blocking_spid is not null
              AND blocked_spid is not null 
	 
		;WITH Blockheads AS
		(
              SELECT blocking_spid, blocking_inputbuf, blocking_xactid, lastblockedbatchstarted = min(lastbatchstarted),  lastblockedbatchcompleted = max(lastbatchcompleted)
              FROM #ReportsXML
              group by blocking_spid, blocking_inputbuf, blocking_xactid

              EXCEPT
              SELECT blocked_spid,  blocking_inputbuf, blocked_xactid, lastblockedbatchstarted = min(lastbatchstarted) , lastblockedbatchcompleted = max(lastbatchcompleted)
              FROM #ReportsXML
              group by blocked_spid,  blocking_inputbuf, blocked_xactid
		),
		TopBlockers as 
		(
              SELECT bh.* 
              FROM Blockheads bh
              WHERE not exists (SELECT 1 
                                         FROM #ReportsXML r
                                         WHERE bh.blocking_xactid = r.blocked_xactid
                                           and bh.blocking_spid = r.blocked_spid
                                         ) 
		),
		Hierachy as
		(
              SELECT distinct r.blocking_xactid, r.blocking_spid, Sentinel = CAST(r.blocking_xactid AS VARCHAR(MAX)), 0 as level, r.blocking_xactid [topblocker]
              FROM TopBlockers r                          
              UNION all
              SELECT r.blocked_xactid, r.blocked_spid, Sentinel + ''|'' + CAST(r.blocked_xactid AS VARCHAR(MAX)), level + 1, h.topblocker
              FROM #ReportsXML r inner join Hierachy h
                     on r.blocking_xactid = h.blocking_xactid
                     and r.blocking_spid = h.blocking_spid
              WHERE charindex(CAST(h.blocking_xactid AS VARCHAR(MAX)), Sentinel) = 0 or h.level <= 1
		)

--------------------------------------------
INSERT #DistinctTemp       
		(   blocking_spid,             
	        blocking_inputbuf,
			blocking_xactid,
			lastbatchstarted,
			lastbatchcompleted,
			directblocks,
			indirectblocks
		)	
       SELECT tb.*
              , Summary.[distinct_direct_blocked_xact_count]
              , RecursiveSummary.[distinct_blocked_xact_count]
       FROM TopBlockers tb
       
	   outer apply (
              SELECT count(distinct r.blocked_xactid) [distinct_direct_blocked_xact_count]
              FROM #ReportsXML r
              WHERE tb.blocking_xactid = r.blocking_xactid
              and tb.blocking_spid = r.blocking_spid   
       ) Summary    
	    
       outer apply (
              SELECT count(distinct h.blocking_xactid) [distinct_blocked_xact_count]
              FROM hierachy h
              WHERE h.topblocker = tb.blocking_xactid
              and level > 0
       ) RecursiveSummary

UPDATE #DistinctTemp
	SET blocking_sessionID = try_convert(int, case when charindex(''@Sessionid'',replace(blocking_inputbuf,'' '',''''),0) != 0 
                     then replace(rtrim(ltrim(substring(replace(blocking_inputbuf,'' '',''''),( charindex(''='',replace(blocking_inputbuf,'' '',''''),charindex(''@Sessionid'',replace(blocking_inputbuf,'' '',''''),0) )+1 ),case when 
                     ((case when charindex('','',replace(blocking_inputbuf,'' '',''''),charindex(''='',replace(blocking_inputbuf,'' '',''''),charindex(''@Sessionid'',replace(blocking_inputbuf,'' '',''''),0) ) ) = 0 then len(replace(blocking_inputbuf,'' '','''')) +1 
                     else charindex('','',replace(blocking_inputbuf,'' '',''''),charindex(''='',replace(blocking_inputbuf,'' '',''''),charindex(''@Sessionid'',replace(blocking_inputbuf,'' '',''''),0) ) ) end)-1) - 
                     (charindex(''='',replace(blocking_inputbuf,'' '',''''),charindex(''@Sessionid'',replace(blocking_inputbuf,'' '',''''),0) ) )<0 then 0 else ((case when charindex('','',replace(blocking_inputbuf,'' '',''''),
                     charindex(''='',replace(blocking_inputbuf,'' '',''''),charindex(''@Sessionid'',replace(blocking_inputbuf,'' '',''''),0) ) ) = 0 then len(replace(blocking_inputbuf,'' '',''''))+1 else charindex('','',replace(blocking_inputbuf,'' '',''''),
                     charindex(''='',replace(blocking_inputbuf,'' '',''''),charindex(''@Sessionid'',replace(blocking_inputbuf,'' '',''''),0) ) ) end)-1) - 
                     (charindex(''='',replace(blocking_inputbuf,'' '',''''),charindex(''@Sessionid'',replace(blocking_inputbuf,'' '',''''),0) ) )end))),''null'',0)else 0 end)

UPDATE r
	SET r.blocking_userID = s.userid
		FROM #DistinctTemp r
		inner join sessions s
		on r.blocking_sessionID = s.SessionID

update r
	SET r.blocking_username = u.Firstname + '' '' + u.LastName + '' ('' + u.username + '')''
		FROM #DistinctTemp r 
		inner join users u
		ON u.userID = r.blocking_userID


------------------------------------------------
------------ Populate HTML Results -------------
------------------------------------------------
SET @tableHTML =
			  N''<style type="text/css">
              #box-table
              {
              font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
              font-size: 12px;
              text-align: center;
              border-collapse: collapse;
              border-top: 1px solid #9baff1;
              border-bottom: 1px solid #9baff1;
			  table-layout: fixed;
			  width: 100%;
              }
              #box-table th
              {
              font-size: 13px;
              font-weight: normal;
              background: #b9c9fe;
              border-right: 1px solid #9baff1;
              border-left: 1px solid #9baff1;
              border-bottom: 1px solid #9baff1;
              color: #039;
              padding: 1px 7px;
			  text-align: center;
			  }
			  #box-table caption
			  {
			  font-size: 14px;
              font-weight: normal;
              background: #b9c9fe;
              border-right: 4px solid #9baff1;
              border-left: 4px solid #9baff1;
			  border-top: 4px solid #9baff1;
              border-bottom: 4px solid #9baff1;
			  border-collapse: collapse;
              color: #039;
			  text-align: left;
			  }
              #box-table td
              {
              border-right: 1px solid #aabcfe;
              border-left: 1px solid #aabcfe;
              border-bottom: 1px solid #aabcfe;
              color: #669;
              padding: 1px 7px;
			  text-align: center;
              }
              tr:nth-child(odd)    
			  { 
              background-color:#eee; 
              }
              tr:nth-child(even)   
              { 
	      background-color:#fff; 
              } 
    	</style><BR>''+    


--- Distinct Blocking ---

	N''<table id="box-table" ><caption><B>Distinct Blocking Stats</B></caption>'' +
	N''<tr><font color="BLACK">
					<th width="100">Full Name (username)</th>
			   		<th width="100">Duration (seconds)</th>
					<th width="200">Start Time</th>
					<th width="200">End Time</th>
					<th width="300">Blocking Input Buffer</th>
					<th width="100">Direct Blocks</th>
					<th width="100">Hierarchical Blocks</th>
					<th width="300">User ID</th>
					<th width="100">Session ID</th>
					<th width="100">SPID</th>
					<th width="100">Blocking xactid</th>
			</tr>'' +
              CAST ( ( 
              SELECT 
					td = ISNULL(dt.blocking_username,''''), '''',
					td = ISNULL(PARSENAME(CONVERT(varchar, CAST(datediff(ss, dt.lastbatchstarted, dt.lastbatchcompleted) AS money), 1),2),''''),'''',
					td = ISNULL(convert(varchar(24),dt.lastbatchstarted	,121),''''), '''',
					td = ISNULL(convert(varchar(24),dt.lastbatchcompleted,121),''''), '''',
					td = ISNULL(LEFT(dt.blocking_inputbuf,2000),''''),'''',
					td = ISNULL(dt.directblocks ,''''), '''',
					td = ISNULL(dt.indirectblocks,''''), '''',
					td = ISNULL(dt.blocking_userID,''''), '''',
					td = ISNULL(dt.blocking_sessionID,''''), '''',
					td = ISNULL(dt.blocking_spid,''''), '''',
					td = ISNULL(dt.blocking_xactid,''''), ''''
				FROM #DistinctTemp dt
				WHERE convert(date,getdate()) = convert(date, [lastbatchstarted]) 
				ORDER BY lastbatchstarted asc  
				FOR XML PATH(''tr''), TYPE 
				) AS NVARCHAR(MAX) ) +
        N''</table><BR><P ALIGN="left"><h5>--- CSV with detailed results is attached ---</h5><BR><BR>'' 	

--- Full Blocking into Email Attachment ---

SELECT 
	ISNULL(CONVERT(varchar,xactrank), ''----'') [xactrank],	
	ISNULL(BlockingProcessDBname, ''----'') [BlockingProcessDBname],
	''"'' + ISNULL(replace(replace(replace(ltrim(convert(varchar(4000),BlockingProcessInputBuf)),char(13), '' ''),char(10), '' ''),char(9), '' ''), ''----'') + ''"'' [BlockingProcessInputBuf],
	ISNULL(CONVERT(varchar,BlockingProcessLastBatchStarted), ''----'') [BlockingProcessLastBatchStarted],
	ISNULL(BlockingProcessObjectname, ''----'') [BlockingProcessObjectName],
	ISNULL(BlockingProcessLockMode, ''----'') [BlockingProcessLockMode],
	ISNULL(BlockingProcessHostname, ''----'') [BlockingProcessHostname],
	ISNULL(BlockingProcessSessionID, ''----'') [BlockingProcessSessionID],
	ISNULL(BlockingProcessUserID, ''----'') [BlockingProcessUserID],
	ISNULL(BlockingProcessUsername, ''----'') [BlockingProcessUsername],
	ISNULL(CONVERT(varchar,BlockingProcessTranCount), ''----'') [BlockingProcessTranCount],
	ISNULL(CONVERT(varchar,BlockingProcessSPID), ''----'') [BlockingProcessSPID],
	ISNULL(BlockingProcessLoginName, ''----'') [BlockingProcessLoginName],
	ISNULL(BlockingProcessApplication, ''----'') [BlockingProcessApplication],
	''"'' + ISNULL(replace(replace(replace(ltrim(convert(varchar(8000),BlockingStatementText)),char(13), '' ''),char(10), '' ''),char(9), '' ''), ''----'') + ''"'' [BlockingStatementText],
	QUOTENAME(ISNULL(BlockingStatementOffsets, ''----''), ''"'') [BlockingStatementOffsets],
	ISNULL(BlockingEncrypted, ''----'') [BlockingEncrypted],		
	ISNULL(Divider, ''----'') [Divider],
	ISNULL(BlockedProcessDBname, ''----'') [BlockedProcessDBname],	
	ISNULL(CONVERT(varchar,BlockedProcessLastBatchStarted), ''----'') [BlockedProcessLastBatchStarted],
	ISNULL(CONVERT(varchar,BlockedProcessWaitTime), ''----'') [BlockedProcessWaitTime],
	ISNULL(CONVERT(varchar,BlockedProcessSPID), ''----'') [BlockedProcessSPID],
	''"'' + ISNULL(replace(replace(replace(ltrim(convert(varchar(4000),BlockedProcessInputBuf)),char(13), '' ''),char(10), '' ''),char(9), '' ''), ''----'') + ''"'' [BlockedProcessInputBuf],
	ISNULL(BlockedProcessTransactionName, ''----'') [BlockedProcessTransactionName],
	ISNULL(BlockedProcessHostname, ''----'') [BlockedProcessHostname],
	ISNULL(BlockedProcessLoginname, ''----'') [BlockedProcessLoginname],
	ISNULL(BlockedProcessApplication, ''----'') [BlockedProcessApplication],
	ISNULL(BlockedProcessIsolationLevel, ''----'') [BlockedProcessIsolationLevel],
	ISNULL(BlockedProcessLockMode, ''----'') [BlockedProcessLockMode],
	ISNULL(WaitResource, ''----'') [WaitResource],
	ISNULL(BlockedObjectname, ''----'') [BlockedObjectname],
	''"'' + ISNULL(replace(replace(replace(ltrim(convert(varchar(8000),BlockedStatementText)),char(13), '' ''),char(10), '' ''),char(9), '' ''), ''----'') + ''"'' [BlockedStatementText],
	ISNULL(BlockedEncrypted, ''----'') [BlockedEncrypted],
	QUOTENAME(ISNULL(BlockedStatementOffsets, ''----''), ''"'')	[BlockedStatementOffsets]	
INTO ##EmailAttachment 
FROM @FullBlocking 
WHERE convert(date,getdate()) = convert(date, [BlockingProcessLastBatchStarted]);


------------------------------------------------
----------------- Debug Mode -------------------
------------------------------------------------

IF @Debug = 1
 	Begin
		SELECT * from #DistinctTemp
		SELECT * from @FullBlocking
		SELECT * from ##EmailAttachment	
		SELECT @TableHTML
		GOTO Skip_Email
	End


--------------------------------------------------
------------------ EMail Results -----------------	
--------------------------------------------------
IF @tableHTML IS NOT NULL
BEGIN

	SET @query = N''SET NOCOUNT ON; 
	SELECT 
	''''xactrank'''', 
	''''BlockingProcessDBname'''',
	''''BlockingProcessInputBuf'''',
	''''BlockingProcessLastBatchStarted'''',
	''''BlockingProcessObjectname'''',
	''''BlockingProcessHostname'''',
	''''BlockingProcessSessionID'''',
	''''BlockingProcessUserID'''',
	''''BlockingProcessUsername'''',
	''''BlockingProcessTranCount'''',
	''''BlockingProcessSPID'''',
	''''BlockingProcessLoginName'''',
	''''BlockingProcessApplication'''',
	''''BlockingStatementText'''',
	''''BlockingStatementOffsets'''',
	''''BlockingEncrypted'''',
	''''Divider'''',
	''''BlockedProcessDBname'''',
	''''BlockedProcessLastBatchStarted'''',
	''''BlockedProcessWaitTime'''',
	''''BlockedProcessSPID'''',
	''''BlockedProcessInputBuf'''',
	''''BlockedProcessTransactionName'''',
	''''BlockedProcessHostname'''',
	''''BlockedProcessLoginname'''',
	''''BlockedProcessApplication'''',
	''''BlockedProcessIsolationLevel'''',
	''''BlockedProcessLockMode'''',
	''''WaitResource'''',
	''''BlockedObjectname'''',
	''''BlockedStatementText'''',
	''''BlockedEncrypted'''',
	''''BlockedStatementOffsets''''	
	UNION ALL 
	SELECT 
	    xactrank, 
		BlockingProcessDBname,
		BlockingProcessInputBuf,
		BlockingProcessLastBatchStarted,
		BlockingProcessObjectname,
		BlockingProcessHostname,
		BlockingProcessSessionID,
		BlockingProcessUserID,
		BlockingProcessUsername,
		BlockingProcessTranCount,
		BlockingProcessSPID,
		BlockingProcessLoginName,
		BlockingProcessApplication,
		BlockingStatementText,
		BlockingStatementOffsets,
		BlockingEncrypted,
		Divider,
		BlockedProcessDBname,
		BlockedProcessLastBatchStarted,
		BlockedProcessWaitTime,
		BlockedProcessSPID,
		BlockedProcessInputBuf,
		BlockedProcessTransactionName,
		BlockedProcessHostname,
		BlockedProcessLoginname,
		BlockedProcessApplication,
		BlockedProcessIsolationLevel,
		BlockedProcessLockMode,
		WaitResource,
		BlockedObjectname,
		BlockedStatementText,
		BlockedEncrypted,
		BlockedStatementOffsets
	FROM ##EmailAttachment;''


EXEC msdb.dbo.Sp_send_dbmail
    @profile_name=''HSP_DBMAIL_DEV'',
	@body = @tableHTML,
	@body_format =''html'',
	@recipients = ''fernandez-r@iehp.org;Nakhoul-s@iehp.org;Bernardez-A@iehp.org;'',
	@subject = ''QA1_Daily Blocking Report'',
	@query = @query,
	@query_result_separator=''	'', 
	@query_result_width=32767,
	@query_attachment_filename = ''HSP3S1A_QA1_DailyBlockingResults.csv'',
	@attach_query_result_as_file = 1,
	@exclude_query_output = 1,
	@append_query_error = 0,
	@query_result_header = 1,
	@query_no_truncate = 1;

END

------------------------------------------------
Skip_Email:

', 
		@database_name=N'HSP_QA1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily_BlockedProcessReport', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150617, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, 
		@schedule_uid=N'd6ae8088-98c8-46e9-9de8-27089a561600'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

