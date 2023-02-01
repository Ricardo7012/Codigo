-- List Parameter in Stored Procedure

SELECT SCHEMA_NAME(SCHEMA_ID) AS 'Schema'
	, SO.NAME AS 'Object Name'
	, SO.Type_Desc AS 'Object Type (UDF/SP)'
	, P.parameter_id AS 'Parameter ID'
	, P.NAME AS 'Parameter Name'
	, TYPE_NAME(P.user_type_id) AS 'Parameter Data Type'
	, P.max_length AS 'Parameter Max Bytes'
	, P.is_output AS 'Is OutPut Parameter'
FROM sys.objects AS SO
INNER JOIN sys.parameters AS P
	ON SO.OBJECT_ID = P.OBJECT_ID
WHERE SO.OBJECT_ID IN (
		SELECT OBJECT_ID
		FROM sys.objects
		WHERE TYPE IN (
				'P'
				, 'FN'
				)
		)
ORDER BY 1, 2, 4