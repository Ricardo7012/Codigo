--SHOW ALL INDEXES AND THEIR USAGE FOR THE CURRENT DATABASE
select object_schema_name(i.object_id) + '.' + object_name(i.object_id) as objectName,
         i.name, 
		 case when is_unique = 1 then 'UNIQUE ' else '' end + i.type_desc, 
         us.user_seeks, 
		 us.user_scans,
		 us.user_lookups,
		 us.user_updates
from sys.indexes i
left outer join sys.dm_db_index_usage_stats us
on i.object_id = us.object_id
and i.index_id = us.index_id
and us.database_id = db_id()
and OBJECTPROPERTY(i.object_id,'IsUserTable')=1 --do not look at system tables
order by us.user_seeks + us.user_scans + us.user_lookups desc
