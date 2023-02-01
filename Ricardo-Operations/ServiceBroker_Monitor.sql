
	SET ANSI_NULLS ON;

	SET QUOTED_IDENTIFIER ON;

	SET CONCAT_NULL_YIELDS_NULL ON;

	SET ANSI_PADDING ON;
GO


IF EXISTS (select * from sys.objects WHERE name = 'SB_Monitor')
BEGIN
	DROP PROC SB_Monitor
END;
GO
CREATE PROCEDURE SB_Monitor
--WITH EXECUTE AS OWNER 
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @dbname varchar(200)
	SELECT @dbname = DB_NAME()
	DECLARE @exec_str varchar(max);
	DECLARE @timer INT;
	

	--Test 1: is SB enabled and running properly?   
	IF EXISTS (
		select 'sys.databases' AS [sys.databases],service_broker_guid,is_broker_enabled , name, database_id 
		from sys.databases 
		where database_id = DB_ID(DB_NAME()) 
		AND service_broker_guid IS NOT NULL
		AND is_broker_enabled <> 1
	)
	BEGIN
		RAISERROR ('Test 1: Service Broker is not enabled/running correctly.',16,1) 
		RETURN 1;
	END;
	

	--Test 2: look for dropped Q monitors
	IF EXISTS (
		SELECT
			'ActivatedQStatus' AS ActivatedQStatus,
			t1.name AS [Service Name],
			t2.name AS [Queue Name],
			CASE WHEN t4.state IS NULL THEN 'Not available' ELSE t4.state END AS [Queue State],
			CASE WHEN t4.tasks_waiting IS NULL THEN '--' ELSE CONVERT(VARCHAR, t4.tasks_waiting) END AS [Tasks Waiting],
			CASE WHEN t4.last_activated_time IS NULL THEN '--' ELSE CONVERT(VARCHAR, t4.last_activated_time) END AS [Last Activated Time],
			CASE WHEN t4.last_empty_rowset_time IS NULL THEN '--' ELSE CONVERT(VARCHAR, t4.last_empty_rowset_time) END AS [Last Empty Rowset Time],
			(
				SELECT
				COUNT(*)
				FROM sys.transmission_queue t6
				WHERE (t6.from_service_name = t1.name)
				AND (t5.service_broker_guid = t6.to_broker_instance)
			) AS [Message Count],
			t2.activation_procedure,
			t2.is_activation_enabled,
			t4.*
		FROM sys.services t1
		JOIN sys.service_queues t2 
			ON t1.service_queue_id = t2.object_id
		LEFT OUTER JOIN sys.dm_broker_queue_monitors t4 
			ON t2.object_id = t4.queue_id
			AND t4.database_id = DB_ID()
		JOIN sys.databases t5 ON t5.database_id = DB_ID()
		WHERE t2.is_ms_shipped = 0 --dont show me system stuff
		AND t4.State = 'DROPPED'
	)
	BEGIN
		RAISERROR ('Test 2: We have DROPPED queue monitors.  Please investigate.',16,1)
		RETURN 1
	END;
	
	--Test 3: check for Qs in NOTIFIED state
	--this means that the Q activator was notified, but is not issuing the proper RECEIVE.  This could mean that the shell activator proc is enabled, or it 
	--could mean the activator is bad, or ???
	SELECT @timer = 0 
	WHILE EXISTS 
		(
			SELECT
				t4.*, t2.activation_procedure
			FROM sys.services t1
			JOIN sys.service_queues t2 
				ON t1.service_queue_id = t2.object_id
			LEFT OUTER JOIN sys.dm_broker_queue_monitors t4 
				ON t2.object_id = t4.queue_id
				AND t4.database_id = DB_ID()
			JOIN sys.databases t5 ON t5.database_id = DB_ID()
			WHERE t2.is_ms_shipped = 0 --dont show me system stuff
			AND t4.state = 'NOTIFIED' 
		)
	BEGIN
		SELECT @timer = @timer + 1 
		IF @timer > 5
		BEGIN
			SELECT
				t4.*, t2.activation_procedure
			FROM sys.services t1
			JOIN sys.service_queues t2 
				ON t1.service_queue_id = t2.object_id
			LEFT OUTER JOIN sys.dm_broker_queue_monitors t4 
				ON t2.object_id = t4.queue_id
				AND t4.database_id = DB_ID()
			JOIN sys.databases t5 ON t5.database_id = DB_ID()
			WHERE t2.is_ms_shipped = 0 --dont show me system stuff
			AND t4.state = 'NOTIFIED' 
			
			RAISERROR ('TEST 3:  WARNING: Queues exist in NOTIFIED state for over 10 seconds.  This may mean we have only a shell activator proc installed.  Please investigate.',10,1)
			RAISERROR ('See previous resultset. Continuing routine.',10,1)
			BREAK
			--RETURN 1
		END;
		
		WAITFOR DELAY '00:00:02'  --wait 2 seconds and try again
	END	
	
	--Test 4: are any of our activated Qs sitting in a disabled state.  This likely means the activator isn't working.  
	IF EXISTS (
		select * 
		from sys.service_queues 
		WHERE is_activation_enabled = 1 AND (is_enqueue_enabled = 0 OR is_receive_enabled = 0)
		)
	BEGIN
		RAISERROR ('Test 4:  Activated Queues exist that are disabled for enqueue and receive.  This likely means the activator procedure is throwing errors.',16,1)
		RAISERROR ('Issue the following command:  ALTER QUEUE [] WITH ACTIVATION (DROP);',16,1)
		RAISERROR ('Then manually run the activation procedure that is erroring, correct the errors, and run SETUP again.',16,1)
		RETURN 1
	END;
	
	--Test 5: "Poison Message" detection
	IF EXISTS (
		SELECT name, is_receive_enabled 
		FROM sys.service_queues
		WHERE is_receive_enabled = 0 
		)
	BEGIN
		RAISERROR ('We have disabled queues, probably from poison messages. Please investigate.',16,1)
		RAISERROR ('The queue can be re-enabled with: ALTER QUEUE [] WITH STATUS = ON ',16,1)
		RAISERROR ('after the problem is resolved.  ',16,1)
		RETURN 1
	END;
	
	--Test 6: do we have a "Conversation Population Explosion"?  
	--this means that we have a ton of conversations not in a CLOSED state.  
	--CLOSED conversations hang around for about 30 mins as a security precaution so just ignore them.  
	--In this case we may not have our conversations working correctly and the receiver is not ending the conversation. 
	--there is no magic to 500.  And if we ever enable Service Broker for more things then the number may need to go up.  
	IF (
		SELECT COUNT(*)
		FROM sys.conversation_endpoints
		WHERE state_desc <> 'CLOSED'
	) > 500
	BEGIN
		RAISERROR ('WARNING: We may not be CLOSEing conversations properly.  Please investigate.',10,1)
	END;
	
	--Test 7: do we have conversations stuck in the transmission Q?  If so something is misconfigured.  
	SELECT @timer = 0 
	WHILE EXISTS 
		(
			select * , CONVERT(xml,message_body) from sys.transmission_queue
		)
	BEGIN
		SELECT @timer = @timer + 1 
		IF @timer > 5
		BEGIN
					
			RAISERROR ('WARNING: There may be items in the transmission_queue that are not being processed.  Or we have VERY busy queues.  Please investigate.',10,1)
			BREAK
			--RETURN 1
		END;
		
		WAITFOR DELAY '00:00:02'  --wait 2 seconds and try again
	END	
	
	
	PRINT 'Service Broker infrastructure seems to be set up and functioning properly.' 
	PRINT 'The remaining result sets will provide configuration and metrics for Service Broker.'



	--just runs a bunch of misc queries that may be helpful for troubleshooting
	select 'sys.databases' AS [sys.databases],service_broker_guid,is_broker_enabled , name, database_id from sys.databases where database_id = DB_ID(DB_NAME()) 
	select 'sys.service_queues' AS [sys.service_queues],name, activation_procedure,is_activation_enabled,is_enqueue_enabled,is_receive_enabled from sys.service_queues
	select 'sys.transmission_queue' AS [sys.transmission_queue],*,CONVERT(xml,message_body) from sys.transmission_queue
	select 'sys.conversation_endpoints' AS [sys.conversation_endpoints],* from sys.conversation_endpoints
	select 'sys.dm_broker_activated_tasks' AS [sys.dm_broker_activated_tasks],* from sys.dm_broker_activated_tasks
	select 'Q Backlog Query' AS Backlog , far_service, state_desc, count(*) messages
	from sys.conversation_endpoints
	group by state_desc, far_service
	ORDER BY far_service, state_desc
	
	SELECT
		'ActivatedQStatus' AS ActivatedQStatus,
		t1.name AS [Service Name],
		t2.name AS [Queue Name],
		CASE WHEN t4.state IS NULL THEN 'Not available' ELSE t4.state END AS [Queue State],
		CASE WHEN t4.tasks_waiting IS NULL THEN '--' ELSE CONVERT(VARCHAR, t4.tasks_waiting) END AS [Tasks Waiting],
		CASE WHEN t4.last_activated_time IS NULL THEN '--' ELSE CONVERT(VARCHAR, t4.last_activated_time) END AS [Last Activated Time],
		CASE WHEN t4.last_empty_rowset_time IS NULL THEN '--' ELSE CONVERT(VARCHAR, t4.last_empty_rowset_time) END AS [Last Empty Rowset Time],
		(
			SELECT
			COUNT(*)
			FROM sys.transmission_queue t6
			WHERE (t6.from_service_name = t1.name)
			AND (t5.service_broker_guid = t6.to_broker_instance)
		) AS [Message Count],
		t2.activation_procedure,
		t2.is_activation_enabled,
		t4.*
	FROM sys.services t1
	JOIN sys.service_queues t2 
		ON t1.service_queue_id = t2.object_id
	LEFT OUTER JOIN sys.dm_broker_queue_monitors t4 
		ON t2.object_id = t4.queue_id
		AND t4.database_id = DB_ID()
	JOIN sys.databases t5 ON t5.database_id = DB_ID()
	WHERE t2.is_ms_shipped = 0 --dont show me system stuff
	
	--display the contents of your queues here
	DECLARE @qname varchar(200);
	DECLARE ssb CURSOR FOR 
		SELECT name 
		FROM sys.service_queues
		WHERE is_ms_shipped = 0 
	OPEN ssb
	FETCH NEXT FROM ssb INTO @qname
	WHILE (@@fetch_status = 0)
	BEGIN
		SELECT @exec_str = 'SELECT ''Contents of Q:' + @qname + ''' AS ''Q ' + @qname + ' Contents'', * FROM ' + @qname + ' WITH (NOLOCK)'
		EXEC (@exec_str);
		FETCH NEXT FROM ssb INTO @qname
	END;
	CLOSE ssb;
	DEALLOCATE ssb;

	--Perfmon counters	
	select 
		'PerfMon',
		object_name,
		counter_name,
		cntr_value
	from sys.dm_os_performance_counters                                                                                    
	WHERE counter_name IN (
		'Activation Errors Total',
		'Broker Transaction Rollbacks',
		'Corrupted Messages Total',
		'Enqueued TransmissionQ Msgs/sec',
		'Dequeued TransmissionQ Msgs/sec',
		'SQL SENDs/sec',      
		'SQL SEND Total',     
		'SQL RECEIVEs/sec',  
		'SQL RECEIVE Total'
	)  

	select 
		'PerfMon',
		object_name,
		counter_name,
		cntr_value
	from sys.dm_os_performance_counters   
	WHERE instance_name = DB_NAME()                                                                                 
	AND counter_name IN (
		'Tasks Running',
		'Task Limit Reached',
		'Tasks Aborted/sec'
	)  	

          
	
	SELECT 'Showing the last hour of SQL Server Log Entries.  Activator proc errors will be sent here.'
	DECLARE @Start datetime
	DECLARE @End datetime
	SELECT @Start = DATEADD(hh,-1,getdate()),@End = GETDATE()
	EXEC xp_readerrorlog 0, 1, NULL, NULL, @Start, @End, 'DESC'
	
	
END;

GO

