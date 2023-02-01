-- Check for Number in Database

DECLARE @sql VARCHAR(8000)
DECLARE @tbl VARCHAR(255)
DECLARE @col VARCHAR(255)
DECLARE @data VARCHAR(50)

SET @data = '100000'

DECLARE cur_tbl CURSOR
FOR
SELECT a.NAME
	, b.NAME
FROM sysobjects a
	, syscolumns b
	, systypes c
WHERE a.id = b.id
	AND a.type = 'U'
	AND c.xtype = b.xtype
	AND c.NAME IN ('int')

OPEN cur_tbl

FETCH NEXT
FROM cur_tbl
INTO @tbl
	, @col

WHILE @@fetch_status = 0
BEGIN
	SET @sql = '	
IF EXISTS (
		SELECT *
		FROM [' + @tbl + ']
		WHERE convert(VARCHAR(255), [' + @col + ']) = ''' + @data + '''
		)
	SELECT tbl = ''' + @tbl + '''
		, col = ''' + @col + '''
		, [' + @col + ']
		, *
	FROM [' + @tbl + ']
	WHERE convert(VARCHAR(255), [' + @col + ']) = ''' + @data + '''	  
		  '

	EXEC (@sql)

	FETCH NEXT
	FROM cur_tbl
	INTO @tbl
		, @col
END

CLOSE cur_tbl

DEALLOCATE cur_tbl
