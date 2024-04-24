--WINDOWS ACCOUNTS
SELECT N'CREATE LOGIN ['+sp.[name]+'] FROM WINDOWS;'
FROM master.sys.server_principals AS sp
WHERE sp.[type] IN ('U', 'G') AND
      sp.is_disabled=0 AND
      sp.[name] NOT LIKE 'NT [AS]%\%';

--SQL ACCOUNTS

--RUN ON PRIMARY THEN EXECUTE THE RESULTS ON SECONDARY 
SELECT N'CREATE LOGIN [' + sp.[name] + '] WITH PASSWORD=0x' + CONVERT(NVARCHAR(MAX), l.password_hash, 2)
       + N' HASHED, CHECK_POLICY=OFF, ' + N'SID=0x' + CONVERT(NVARCHAR(MAX), sp.[sid], 2) + N';'
FROM master.sys.server_principals AS sp
    INNER JOIN master.sys.sql_logins AS l
        ON sp.[sid] = l.[sid]
WHERE sp.[type] = 'S'
      AND sp.is_disabled = 0;
 
 

