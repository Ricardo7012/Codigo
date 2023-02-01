SELECT o.name AS OBJECT_NAME
     , o.object_id
	 , o.type_desc
     , o.create_date
	 , o.modify_date
     , s.name AS schema_name
FROM sys.all_objects            o
    LEFT OUTER JOIN sys.schemas s
        ON (o.schema_id = s.schema_id)
WHERE o.modify_date > (GETDATE() - 360);


