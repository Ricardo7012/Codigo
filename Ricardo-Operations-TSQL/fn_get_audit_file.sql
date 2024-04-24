USE master
GO
SET NOCOUNT ON 

SELECT event_time, statement FROM sys.fn_get_audit_file ('P:\MSSQL\Audit\HIPAA_Audit_CD7D9814-F48C-4A51-B450-19695B38EAAA_0_131209423732640000.sqlaudit',default,default) 
WHERE action_id = 'IN'  
	and statement <> '-- Encrypted text'
ORDER BY event_time DESC

