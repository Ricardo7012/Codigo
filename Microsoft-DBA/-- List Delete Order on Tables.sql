-- List Delete Order on Tables

DECLARE @mytable VARCHAR(30)
DECLARE @Order INT

SET @mytable = 'Period'
SET @Order = 0

CREATE TABLE #TEMP (RowNo INT, OrderNo INT, TableName VARCHAR(50))

INSERT INTO #TEMP
VALUES (
	(
		SELECT Row_number() OVER (
				ORDER BY @mytable
				)
		), @Order, @mytable
	)

WHILE (
		EXISTS (
			SELECT TableName
			FROM #TEMP
			WHERE OrderNo = @Order
			)
		)
BEGIN
	SET @Order = @Order + 1;

	INSERT INTO #TEMP
	SELECT Row_number() OVER (
			ORDER BY t1.TABLE_NAME
			), @Order, t1.TABLE_NAME AS PointsFrom
	FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS r
	INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS t1
		ON t1.CONSTRAINT_NAME = r.CONSTRAINT_NAME
	INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS t2
		ON t2.CONSTRAINT_NAME = r.UNIQUE_CONSTRAINT_NAME
	WHERE t2.table_name IN (
			SELECT TableName
			FROM #TEMP
			WHERE OrderNo = (@Order - 1)
			)
END

SELECT RowNo AS 'Row #', OrderNo AS 'Delete Order', TableName AS 'Table Name'
FROM #TEMP

DROP TABLE #TEMP
