IF NOT EXISTS 
    (SELECT name  
     FROM master.sys.server_principals
     WHERE name = 'iehp\_sqladmins')
BEGIN
    --CREATE LOGIN [LoginName] WITH PASSWORD = N'password'
END
