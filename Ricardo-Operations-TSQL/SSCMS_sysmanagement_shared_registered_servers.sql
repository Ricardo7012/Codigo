
WITH RegServers (parent_id, server_group_id, name ) AS 
(
    SELECT parent_id, server_group_id, name 
     FROM dbo.sysmanagement_shared_server_groups 
    WHERE parent_id IS NULL
    
    UNION ALL
    
    SELECT e.parent_id, e.server_group_id, e.name 
     FROM dbo.sysmanagement_shared_server_groups AS e
         INNER JOIN RegServers AS d
         ON e.parent_id = d.server_group_id 
)
SELECT s.name, g.parent_id, sg.name as parent_group_name, g.server_group_id, g.name as group_name
 FROM RegServers AS g JOIN dbo.sysmanagement_shared_registered_servers AS s
  ON s.server_group_id = g.server_group_id
 JOIN dbo.sysmanagement_shared_server_groups AS sg 
  ON g.parent_id = sg.server_group_id
--WHERE g.parent_id =  -- OR g.server_group_id = @p_RegServer_Group

--QVSQLCMS01
SELECT * FROM msdb.dbo.sysmanagement_shared_registered_servers
SELECT * FROM msdb.dbo.sysmanagement_shared_server_groups
