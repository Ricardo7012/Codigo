--instant_file_initialization_enabled
EXEC xp_readerrorlog 0, 1, N'Database Instant File Initialization';

SELECT servicename
     , status_desc
     , instant_file_initialization_enabled
FROM sys.dm_server_services;

