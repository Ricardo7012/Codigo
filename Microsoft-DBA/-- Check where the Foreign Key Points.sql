-- Check where the Foreign Key Points

DECLARE @TableName varchar(35)

SET @TableName = 'TripDoNotModify'

SELECT object_name(parent_object_id) AS 'Parent Table Name'
	, object_name(referenced_object_id) AS 'Ref Table Name'
	, NAME AS 'FK Key'
FROM sys.foreign_keys
WHERE parent_object_id = object_id(@TableName)