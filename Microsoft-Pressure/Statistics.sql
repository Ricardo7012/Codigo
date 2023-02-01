/*Use Statistics 
          *  Presence of clustered index /table scans       
          *  Types of joins that are occurring   
          *  Actual  vs estimated Rows (Cardinality estimate)
 DBCC SHOW_STATISTICS  ('schema_name.table_name'.index_name)
  */

--DYNAMIC SQL SCRIPT TO GENERATE CODE
select ' DBCC SHOW_STATISTICS( ' + '''' + schema_name(schema_id) +'.' + a.name + ''''+ ',' + b.name + ')' 
from sys.objects a
INNER JOIN sys.indexes b 
ON a.object_id = b.object_id
WHERE a.is_ms_shipped = 0;