-- List Index Usage Stats

SELECT OBJECT_NAME(S.[OBJECT_ID]) AS 'Object Name'
	, I.[NAME] AS 'Index Name'
	, ' - - - - - > ' AS 'User Info'
	, USER_SEEKS AS 'Seeks'
	, USER_SCANS AS 'Scans'
	, USER_LOOKUPS AS 'Lookups'
	, USER_UPDATES AS 'Updates'
FROM SYS.DM_DB_INDEX_USAGE_STATS AS S
INNER JOIN SYS.INDEXES AS I
	ON I.[OBJECT_ID] = S.[OBJECT_ID]
		AND I.INDEX_ID = S.INDEX_ID
WHERE OBJECTPROPERTY(S.[OBJECT_ID], 'IsUserTable') = 1