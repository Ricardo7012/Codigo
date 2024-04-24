-- DEADLOCKS
SELECT CONVERT(XML, event_data).query('/event/data/value/child::*')
     , CONVERT(XML, event_data).value('(event[@name="xml_deadlock_report"]/@timestamp)[1]', 'datetime') AS Execution_Time
FROM sys.fn_xe_file_target_read_file('\\hsp1s1a\Log\system_health*.xel', NULL, NULL, NULL)
WHERE object_name LIKE 'xml_deadlock_report';
