-- Check Table Structure

SELECT t.NAME AS 'Qualified Name'
	, ' -- ' AS ' -- '
	, CASE -- Table has a primary key
		WHEN OBJECTPROPERTY(object_id, 'TableHasPrimaryKey') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Primary Key'
	, CASE -- Table has an identity column.
		WHEN OBJECTPROPERTY(object_id, 'TableHasIdentity') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Identity Col'		
	, ' -- ' AS ' -- '				
	, CASE -- Table has an index of any type.
		WHEN OBJECTPROPERTY(object_id, 'TableHasIndex') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Any Index'
	, ' -- ' AS ' -- '
	, CASE -- Table has a clustered index.	
		WHEN OBJECTPROPERTY(object_id, 'TableHasClustIndex') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Clustered IX'
	, CASE -- Table has a Nonclustered index.
		WHEN OBJECTPROPERTY(object_id, 'TableHasNonclustIndex') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Non Clustered IX'
	, CASE -- Table has an active full-text index.
		WHEN OBJECTPROPERTY(object_id, 'TableHasActiveFulltextIndex') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Full Text IX'
	, ' -- ' AS ' -- '
	, CASE -- Table has a CHECK constraint.
		WHEN OBJECTPROPERTY(object_id, 'TableHasCheckCnst') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Check Cnt'
	, CASE -- Table has a DEFAULT constraint.
		WHEN OBJECTPROPERTY(object_id, 'TableHasDefaultCnst') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Default Cnt'
	, CASE -- Table has a UNIQUE constraint.
		WHEN OBJECTPROPERTY(object_id, 'TableHasUniqueCnst') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Unique Cnt'	
	, ' -- ' AS ' -- '		
	, CASE -- Table has a FOREIGN KEY constraint.
		WHEN OBJECTPROPERTY(object_id, 'TableHasForeignKey') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'FK Cnt'		
	, CASE -- Referenced by a FOREIGN KEY constraint.
		WHEN OBJECTPROPERTY(object_id, 'TableHasForeignRef') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'FK Ref'
	, ' -- ' AS ' -- '			
	, CASE -- Object has an INSERT trigger.
		WHEN OBJECTPROPERTY(object_id, 'TableHasInsertTrigger') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Insert Tgr'
	, CASE -- Table has an Update trigger. 
		WHEN OBJECTPROPERTY(object_id, 'TableHasUpdateTrigger') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Update Tgr'		
	, CASE -- Table has a DELETE trigger.
		WHEN OBJECTPROPERTY(object_id, 'TableHasDeleteTrigger') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Delete Tgr'		
	, ' -- ' AS ' -- '
	, CASE -- Table has text, ntext, or image column
		WHEN OBJECTPROPERTY(object_id, 'TableHasTextImage') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Has Blob'	
	, CASE -- Table has a timestamp column.
		WHEN OBJECTPROPERTY(object_id, 'TableHasTimestamp') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Time Stamp'		
	, CASE -- ROWGUIDCOL for uniqueidentifier col
		WHEN OBJECTPROPERTY(object_id, 'TableHasRowGuidCol') = 0
			THEN 'No'
		ELSE 'Yes'
		END AS 'Row GUID Col'
FROM sys.tables t
ORDER BY 'Qualified Name'
