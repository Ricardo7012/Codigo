-- List Cascade Delete on Table

DECLARE @t NVARCHAR(128)
SET @t = 'My_Table_Name'

SELECT p.name, fk.delete_referential_action_desc, t.name
FROM sys.foreign_keys fk
INNER JOIN sys.objects t ON fk.parent_object_id = t.object_id
INNER JOIN sys.objects p ON fk.referenced_object_id = p.object_id
WHERE p.name = @t
ORDER BY 1, 3


SELECT DISTINCT p.name, fk.delete_referential_action_desc, t.name, 
   fk2.delete_referential_action_desc, tt.name
FROM sys.foreign_keys fk
INNER JOIN sys.objects t ON fk.parent_object_id = t.object_id
INNER JOIN sys.objects p ON fk.referenced_object_id = p.object_id
INNER JOIN sys.foreign_keys fk2 ON fk2.referenced_object_id = t.object_id
INNER JOIN sys.objects tt ON fk2.parent_object_id = tt.object_id
WHERE p.name = @t
AND t.object_id <> p.object_id
ORDER BY 1, 3, 5

