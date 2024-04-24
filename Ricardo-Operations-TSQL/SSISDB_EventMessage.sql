USE SSISDB;
GO
SELECT  event_message_id ,
		q.operation_id ,
        message ,
        package_name ,
        event_name ,
        message_source_name ,
        package_path ,
        execution_path ,
        message_type ,
        message_source_type
FROM    ( SELECT    em.*
          FROM      SSISDB.catalog.event_messages em
          WHERE     em.operation_id = ( SELECT  MAX(execution_id)
                                        FROM    SSISDB.catalog.executions
                                      )
                    AND event_name NOT LIKE '%Validate%'
        ) q
/* Put in whatever WHERE predicates you might like*/
--WHERE	event_name = 'OnError'
--WHERE	package_name = 'Package.dtsx'
--WHERE execution_path LIKE '%<some executable>%'
ORDER BY message_time DESC; 
--:CONNECT PVSQLSIS01
-- http://msdn.microsoft.com/en-us/library/ff877994.aspx
-- Find all error messages
USE SSISDB;
GO
-- http://msdn.microsoft.com/en-us/library/ff877994.aspx
-- Find all error messages
SELECT  OM.operation_message_id
       ,OM.operation_id
       ,OM.message_time
       ,OM.message_type
       ,OM.message_source_type
       ,OM.message
       ,OM.extended_info_id
FROM    catalog.operation_messages AS OM
--WHERE   OM.operation_id = 2039898
ORDER BY OM.message_time DESC;

USE SSISDB;
GO
-- http://msdn.microsoft.com/en-us/library/ff877994.aspx
-- Find all error messages
SELECT  OM.operation_message_id
       ,OM.operation_id
       ,OM.message_time
       ,OM.message_type
       ,OM.message_source_type
       ,OM.message
       ,OM.extended_info_id
FROM    catalog.operation_messages AS OM
WHERE   OM.message_type = 120 
	--AND OM.operation_id = 1142215
ORDER BY OM.message_time DESC;
USE SSISDB;
GO
-- Generate all the messages associated to failing operations
SELECT  OM.operation_message_id
       ,OM.operation_id
       ,OM.message_time
       ,OM.message_type
       ,OM.message_source_type
       ,OM.message
       ,OM.extended_info_id
FROM    catalog.operation_messages AS OM
        INNER JOIN ( 
-- Find failing operations
                     SELECT DISTINCT
                            OM.operation_id
                     FROM   catalog.operation_messages AS OM
                     WHERE  OM.message_type = 120
                   ) D ON D.operation_id = OM.operation_id
WHERE om.message LIKE 'MEDHOK_pro%'
ORDER BY OM.message_time DESC;
USE SSISDB;
GO
-- Find all messages associated to the last failing run
SELECT  OM.operation_message_id
       ,OM.operation_id
       ,OM.message_time
       ,OM.message_type
       ,OM.message_source_type
       ,OM.message
       ,OM.extended_info_id
FROM    catalog.operation_messages AS OM
WHERE   OM.operation_id = ( 
-- Find the last failing operation
-- lazy assumption that biggest operation
-- id is last. Could be incorrect if a long
-- running process fails after a quick process
-- has also failed
                            SELECT  MAX(OM.operation_id)
                            FROM    catalog.operation_messages AS OM
                            WHERE   OM.message_type = 120
                          ) 
ORDER BY OM.message_time DESC

