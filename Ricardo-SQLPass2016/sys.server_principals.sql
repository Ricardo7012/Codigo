SELECT * FROM sys.server_principals 
GO

SELECT endpnt.name, 
       suser_name(perms.grantee_principal_id) as grantee_principal, 
       perms.permission_name, perms.state_desc
    FROM 
       sys.server_permissions perms,
       sys.endpoints endpnt
     WHERE 
       perms.class = 105 
       AND perms.major_id = endpnt.endpoint_id
GO

Select * from sys.dm_os_ring_buffers where ring_buffer_type = 'RING_BUFFER_SECURITY_ERROR'
