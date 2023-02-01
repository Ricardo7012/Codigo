-- List Relationship Level on Tables

DECLARE @RITable TABLE (
	object_id INT PRIMARY KEY
	, SchemaName SYSNAME NOT NULL
	, TableName SYSNAME NOT NULL
	, RILevel TINYINT DEFAULT 0
	, IsSelfReferencing TINYINT DEFAULT 0
	, HasExcludedRelationship TINYINT DEFAULT 0
	, UpdateCount TINYINT DEFAULT 0
	);

INSERT @RITable (
	object_id
	, SchemaName
	, TableName
	, RILevel
	, IsSelfReferencing
	, HasExcludedRelationship
	, UpdateCount
	)
SELECT tables.object_id
	, schemas.NAME
	, tables.NAME
	, 0
	, SUM(CASE 
			WHEN foreign_keys.parent_object_id IS NULL
				THEN 0
			ELSE 1
			END)
	, SUM(CASE 
			WHEN foreign_keys02.referenced_object_id IS NULL
				THEN 0
			ELSE 1
			END)
	, 0
FROM sys.tables tables
INNER JOIN sys.schemas schemas
	ON tables.schema_id = schemas.schema_id
LEFT JOIN sys.foreign_keys foreign_keys
	ON tables.object_id = foreign_keys.parent_object_id
		AND tables.object_id = foreign_keys.referenced_object_id
LEFT JOIN sys.foreign_keys foreign_keys01
	ON tables.object_id = foreign_keys01.parent_object_id
LEFT JOIN sys.foreign_keys foreign_keys02
	ON foreign_keys01.parent_object_id = foreign_keys02.referenced_object_id
		AND foreign_keys01.referenced_object_id = foreign_keys02.parent_object_id
		AND foreign_keys01.parent_object_id <> foreign_keys01.referenced_object_id
WHERE tables.NAME NOT IN (
		'sysdiagrams'
		, 'dtproperties'
		)
GROUP BY tables.object_id
	, schemas.NAME
	, tables.NAME;

DECLARE @LookLevel INT;
DECLARE @MyRowcount INT;

SELECT @LookLevel = 0
	, @MyRowcount = - 1;

WHILE (@MyRowcount <> 0)
BEGIN
	UPDATE ChildTable
	SET RILevel = @LookLevel + 1
		, UpdateCount = ChildTable.UpdateCount + 1
	FROM @RITable ChildTable
	INNER JOIN sys.foreign_keys foreign_keys
		ON ChildTable.object_id = foreign_keys.parent_object_id
	INNER JOIN @RITable ParentTable
		ON foreign_keys.referenced_object_id = ParentTable.object_id
			AND ParentTable.RILevel = @LookLevel
	LEFT JOIN sys.foreign_keys foreign_keysEX
		ON foreign_keys.parent_object_id = foreign_keysEX.referenced_object_id
			AND foreign_keys.referenced_object_id = foreign_keysEX.parent_object_id
			AND foreign_keys.parent_object_id <> foreign_keys.referenced_object_id
	WHERE ChildTable.object_id <> ParentTable.object_id
		AND foreign_keysEX.referenced_object_id IS NULL;

	SELECT @MyRowcount = @@ROWCOUNT;

	SELECT @LookLevel = @LookLevel + 1;
END;

SELECT RITable.SchemaName SchemaName
	, RITable.TableName TableName
	, RITable.RILevel RILevel
	, CASE 
		WHEN RITable.IsSelfReferencing > 0
			THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
		END IsSelfReferencing
	, CASE 
		WHEN RITable.HasExcludedRelationship > 0
			THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
		END HasExcludedRelationship
FROM @RITable RITable
ORDER BY RITable.RILevel DESC
	, RITable.TableName ASC;

-- Excluded relationships
SELECT foreign_keys01.NAME ForeignKeyName
	, ParentSchema.NAME ParentSchema
	, ParentObject.NAME ParentTable
	, ChildSchema.NAME ChildSchema
	, ChildObject.NAME ChildTable
FROM sys.foreign_keys foreign_keys01
INNER JOIN sys.foreign_keys foreign_keys02
	ON foreign_keys01.parent_object_id = foreign_keys02.referenced_object_id
		AND foreign_keys01.referenced_object_id = foreign_keys02.parent_object_id
		AND foreign_keys01.parent_object_id <> foreign_keys01.referenced_object_id
INNER JOIN sys.objects ParentObject
	ON foreign_keys01.parent_object_id = ParentObject.object_id
INNER JOIN sys.schemas ParentSchema
	ON ParentObject.schema_id = ParentSchema.schema_id
INNER JOIN sys.objects ChildObject
	ON foreign_keys01.referenced_object_id = ChildObject.object_id
INNER JOIN sys.schemas ChildSchema
	ON ChildObject.schema_id = ChildSchema.schema_id;
