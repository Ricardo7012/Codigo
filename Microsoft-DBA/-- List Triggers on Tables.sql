-- List Triggers on Tables

SELECT t.NAME AS 'Qualified Name'
	, CASE 
		WHEN OBJECTPROPERTY(t.object_ID, 'HasInsertTrigger') <> 0
			THEN 'yes'
		ELSE 'no'
		END AS 'Insert'
	, CASE 
		WHEN OBJECTPROPERTY(t.object_ID, 'HasUpdateTrigger ') <> 0
			THEN 'yes'
		ELSE 'no'
		END AS 'Update'
	, CASE 
		WHEN OBJECTPROPERTY(t.object_ID, 'HasDeleteTrigger') <> 0
			THEN 'yes'
		ELSE 'no'
		END AS 'Delete'
	, CASE 
		WHEN OBJECTPROPERTY(t.object_ID, 'HasInsteadOfTrigger') <> 0
			THEN 'yes'
		ELSE 'no'
		END AS 'Instead Of'
	, CASE 
		WHEN OBJECTPROPERTY(t.object_ID, 'HasAfterTrigger') <> 0
			THEN 'yes'
		ELSE 'no'
		END AS 'After'
FROM sys.tables t
ORDER BY 'Qualified Name'
