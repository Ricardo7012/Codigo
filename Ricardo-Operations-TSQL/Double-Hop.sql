-- DOUBLE HOP -- RUN THIS WITH PROCESS MONITOR FROM (SYSINTERNALS)
-- CHECK UAC -- COPY FILE TO EACH FOLDER AND EXECUTE
SET NOCOUNT ON;
PRINT 'START TIME: ' + (CONVERT(VARCHAR(24), GETDATE(), 121));
GO
SELECT CONVERT(VARCHAR(24), GETDATE(), 113);
GO
PRINT 'SERVER NAME: ' + @@SERVERNAME;
GO
SELECT @@SERVERNAME AS SN,
       CURRENT_USER AS CU,
       SYSTEM_USER AS SU,
       USER_NAME() AS UN;
GO
SELECT session_id,
       local_tcp_port,
       auth_scheme
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;
GO
--**********************************************************************************************
--PUT COMMAND IN HERE 
SELECT *
FROM
    OPENROWSET(BULK '\\sysstorage\EntDataSystems\CreateProcessingObjects.sql', SINGLE_CLOB)
    --OPENROWSET(BULK '\\sysstorage\sqlarchive\Templates\Generic\CreateProcessingObjects.sql', SINGLE_CLOB)
    AS a;
GO
--**********************************************************************************************
--1) Kerberos is used when making remote connection over TCP/IP if SPN present.
--2) Kerberos is used when making local tcp connection on XP if SPN present.
--3) NTLM is used when making local connection on WIN 2K3.
--4) NTLM is used over NP connection.
--5) NTLM is used over TCP connection if SPN not found.
SELECT CONVERT(VARCHAR(24), GETDATE(), 113);
GO
PRINT 'END TIME: ' + (CONVERT(VARCHAR(24), GETDATE(), 121));
GO

