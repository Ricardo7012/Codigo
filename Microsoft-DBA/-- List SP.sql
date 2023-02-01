-- List SP

DECLARE @ObjectName varchar(50)
DECLARE @Schema varchar(4)
DECLARE @TempObjectName varchar(50)

SET @TempObjectName = 'PlayerSession'
SET @Schema = 'dbo' + '.'
SET @ObjectName = @Schema + @TempObjectName

SELECT referencing_entity_name AS 'Referencing Entity Name'
FROM sys.dm_sql_referencing_entities(@ObjectName, 'OBJECT')
ORDER BY referencing_entity_name