-- List Parameters in Stored Procedures

DECLARE @ProcName varchar(45)

SET @ProcName = 'Proc_ReconstructPlayer'

SELECT SCHEMA_NAME(SCHEMA_ID) AS 'Schema'
	, SO.NAME AS 'ObjectName'
	, SO.Type_Desc AS 'ObjectType (UDF/SP)'
	, P.parameter_id AS 'ParameterID'
	, P.NAME AS 'ParameterName'
	, TYPE_NAME(P.user_type_id) AS 'ParameterDataType'
	, P.max_length AS 'ParameterMaxBytes'
	, P.is_output AS 'IsOutPutParameter'
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
AND so.name = @ProcName
ORDER BY [Schema]
	, SO.NAME
	, P.parameter_id
GO


