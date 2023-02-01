-- Tables Relationship Script

SELECT CASE 
		WHEN a.parent_object_id IS NULL
			THEN parent.NAME + '  --- 1 -- to -- Many ---  ' + child.NAME
		ELSE parent.NAME + '  --- 1 -- to --  1   ---  ' + child.NAME
		END AS 'Tables Relations'
FROM (
	SELECT DISTINCT parent_object_id
		, referenced_object_id
	FROM sys.foreign_keys
	) fk
LEFT JOIN (
	SELECT DISTINCT fkindexes.parent_object_id
		, fkindexes.referenced_object_id
	FROM (
		SELECT fk.parent_object_id
			, fk.referenced_object_id
			, ixcolumns.index_id
			, COUNT(*) cindexes
		FROM (
			SELECT object_id
				, parent_object_id
				, referenced_object_id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY parent_object_id
						, referenced_object_id ORDER BY object_id
						) rid
					, object_id
					, parent_object_id
					, referenced_object_id
				FROM sys.foreign_keys
				) fk
			WHERE rid = 1
			) fk
		INNER JOIN sys.foreign_key_columns fkc
			ON fkc.constraint_object_id = fk.object_id
		INNER JOIN sys.index_columns ixcolumns
			ON ixcolumns.object_id = fkc.parent_object_id AND ixcolumns.column_id = fkc.parent_column_id
		INNER JOIN sys.indexes ix
			ON ix.object_id = ixcolumns.object_id AND ix.index_id = ixcolumns.index_id
		WHERE ix.is_unique = 1
		GROUP BY fk.parent_object_id
			, fk.referenced_object_id
			, ixcolumns.index_id
		) fkindexes
	INNER JOIN (
		SELECT fk.parent_object_id
			, ixcolumns.index_id
			, COUNT(*) cindexestotal
		FROM (
			SELECT DISTINCT parent_object_id
			FROM sys.foreign_keys
			) fk
		INNER JOIN sys.index_columns ixcolumns
			ON ixcolumns.object_id = fk.parent_object_id
		GROUP BY fk.parent_object_id
			, ixcolumns.index_id
		) totalindexes
		ON totalindexes.parent_object_id = fkindexes.parent_object_id AND totalindexes.index_id = fkindexes.index_id
	WHERE cindexestotal - cindexes = 0
	) a
	ON a.parent_object_id = fk.parent_object_id AND a.referenced_object_id = fk.referenced_object_id
INNER JOIN sys.tables child
	ON fk.parent_object_id = child.object_id
INNER JOIN sys.tables parent
	ON fk.referenced_object_id = parent.object_id
ORDER BY 'Tables Relations'
