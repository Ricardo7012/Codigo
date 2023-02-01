--CONFIGURATION
--Security Check:	Max Number of concurrent sessions  (SQL2-00-022000)
--     Determine maximum number of allowed concurrent sessions.
--Risk Level:	High
--     Server is vulnerable if number of concurrent sessions are greater than maximum allowed concurrent sessions
--Findings:	
--DVSQLFIN01	 has infinite allowed concurrent sessions, which could make the server vulnerable to DDoS attacks.

SELECT ConnectionStatus = CASE WHEN dec.most_recent_sql_handle = 0x0 
        THEN 'Unused' 
        ELSE 'Used' 
        END
    , CASE WHEN des.status = 'Sleeping' 
        THEN 'sleeping' 
        ELSE 'Not Sleeping' 
        END
    , ConnectionCount = COUNT(1)
FROM sys.dm_exec_connections dec
    INNER JOIN sys.dm_exec_sessions des ON dec.session_id = des.session_id
GROUP BY CASE WHEN des.status = 'Sleeping' 
        THEN 'sleeping' 
        ELSE 'Not Sleeping' 
        END
    , CASE WHEN dec.most_recent_sql_handle = 0x0 
        THEN 'Unused' 
        ELSE 'Used' 
        END;
--FIX 
-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-the-user-connections-server-configuration-option?view=sql-server-2017

EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'user connections', N'3000'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
