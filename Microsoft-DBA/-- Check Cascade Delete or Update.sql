-- Check Cascade Delete or Update

SELECT OBJECT_NAME(parent_object_id) AS 'Parent Object'
	, OBJECT_NAME(referenced_object_id) AS 'Referenced Object'
	, NAME AS 'Constraint Name'
	, delete_referential_action_desc AS 'ON DELETE'
	, update_referential_action_desc AS 'ON UPDATE'
FROM sys.foreign_keys
ORDER BY [Parent Object]
