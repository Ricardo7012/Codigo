-- List Reference Table

SELECT referenced_entity_name AS 'Reference Name'
	, OBJECT_NAME(referencing_id) AS 'Referencing Object'
	, referenced_database_name AS 'Database'
--	, referenced_schema_name AS 'Schema'
FROM sys.sql_expression_dependencies
WHERE referenced_database_name IS NOT NULL AND is_ambiguous = 0
--ORDER BY 'Referencing Object'
ORDER BY 'Reference Name'
