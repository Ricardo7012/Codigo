DECLARE @FileName NVARCHAR(4000);
SELECT @FileName = target_data.value('(EventFileTarget/File/@name)[1]', 'nvarchar(4000)')
FROM
(
    SELECT CAST(target_data AS XML) target_data
    FROM sys.dm_xe_sessions s
        JOIN sys.dm_xe_session_targets t
            ON s.address = t.event_session_address
    WHERE s.name = N'AlwaysOn_health'
) ft;

SELECT XEData.value('(event/@timestamp)[1]', 'datetime2(3)') AS event_timestamp,
       XEData.value('(event/data[@name="previous_state"]/text)[1]', 'varchar(255)') AS previous_state,
       XEData.value('(event/data[@name="current_state"]/text)[1]', 'varchar(255)') AS current_state,
       XEData.value('(event/data[@name="availability_replica_name"]/value)[1]', 'varchar(255)') AS availability_replica_name,
       XEData.value('(event/data[@name="availability_group_name"]/value)[1]', 'varchar(255)') AS availability_group_name
FROM
(
    SELECT CAST(event_data AS XML) XEData,
           *
    FROM sys.fn_xe_file_target_read_file(@FileName, NULL, NULL, NULL)
    WHERE object_name = 'availability_replica_state_change'
) event_data
WHERE XEData.value('(event/data[@name="current_state"]/text)[1]', 'varchar(255)') = 'PRIMARY_NORMAL'
ORDER BY event_timestamp DESC;

/******************************************************************************************************************
How to Query the Extended Events Session for Error Numbers
Next we can query for specific error numbers that are that referenced in the extended events session.  In the query 
below we are looking for the error numbers related to possible database corruption issues.
*******************************************************************************************************************/
DECLARE @FileName2 NVARCHAR(4000);
SELECT @FileName2 = target_data.value('(EventFileTarget/File/@name)[1]', 'nvarchar(4000)')
FROM
(
    SELECT CAST(target_data AS XML) target_data
    FROM sys.dm_xe_sessions s
        JOIN sys.dm_xe_session_targets t
            ON s.address = t.event_session_address
    WHERE s.name = N'AlwaysOn_health'
) ft;

SELECT XEData.value('(event/@timestamp)[1]', 'datetime2(3)') AS event_timestamp,
       XEData.value('(event/data[@name="error_number"]/value)[1]', 'int') AS error_number,
       XEData.value('(event/data[@name="severity"]/value)[1]', 'int') AS severity,
       XEData.value('(event/data[@name="message"]/value)[1]', 'varchar(max)') AS message
FROM
(
    SELECT CAST(event_data AS XML) XEData,
           *
    FROM sys.fn_xe_file_target_read_file(@FileName2, NULL, NULL, NULL)
    WHERE object_name = 'error_reported'
) event_data
WHERE XEData.value('(event/data[@name="error_number"]/value)[1]', 'int') IN ( 823, 824, 829 )
ORDER BY event_timestamp DESC;
