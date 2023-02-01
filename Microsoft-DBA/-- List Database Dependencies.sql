-- List Database Dependencies

SELECT DB_NAME() AS current_db_name
	, OBJECT_NAME(referencing_id) AS o_name
	, UPPER(COALESCE(sed.referenced_server_name, '')) AS referenced_server_name
	, sed.referenced_database_name
	, sed.referenced_schema_name
	, sed.referenced_entity_name
FROM sys.sql_expression_dependencies AS sed
WHERE referenced_database_name <> DB_NAME() AND referenced_database_name <> 'msdb'
ORDER BY UPPER(referenced_server_name);
