CONNECT:HSP1S1A
 -- SERVERPROPERTY
       SELECT
              SERVERPROPERTY('productversion') ProductVersion,
              SERVERPROPERTY ('productlevel') ProductLevel,
              SERVERPROPERTY ('edition') Edition,
              SERVERPROPERTY ('MachineName') MachineName,
			  SERVERPROPERTY('InstanceDefaultDataPath') AS InstanceDefaultDataPath,
			  SERVERPROPERTY('InstanceDefaultLogPath') AS InstanceDefaultLogPath,
			  SERVERPROPERTY('ErrorLogFileName') AS 'Error log file location',
              create_date 'SQL Server Installation Date'
       FROM
              sys.server_principals
       WHERE
              name='NT AUTHORITY\SYSTEM'

CONNECT:HSP1S1B