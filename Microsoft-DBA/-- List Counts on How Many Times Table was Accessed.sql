-- List Counts on How Many Times Table was Accessed

SELECT TableName AS 'Table Name'
	, COUNT(*) AS 'Access Count'
FROM (
	SELECT DISTINCT o.NAME 'TableName'
		, op.NAME 'DependentObject'
	FROM SysObjects o
	INNER JOIN SysDepends d
		ON d.DepId = o.Id
	INNER JOIN SysObjects op
		ON op.Id = d.Id
	WHERE o.XType = 'U'
	GROUP BY o.NAME
		, o.Id
		, op.NAME
	) x
GROUP BY TableName
ORDER BY 2 DESC
