SELECT file_version
     , product_version
     , company
     , [description]
FROM sys.dm_os_loaded_modules
WHERE company NOT LIKE 'Microsoft%';
-- https://community.sophos.com/on-premise-endpoint/f/sophos-enterprise-console/98598/how-to-add-sql-policy-exception-on-the-sophos-enterprise-console
-- https://community.sophos.com/on-premise-endpoint/f/sophos-endpoint-software/4900/how-do-i-get-sophos-out-of-my-sql-server
-- https://support.microsoft.com/en-us/help/309422/choosing-antivirus-software-for-computers-that-run-sql-server
-- https://support.sophos.com/support/s/article/KB-000034359?language=en_US
