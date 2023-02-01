--Alter Proc spLogin_OwnedObjects ( @Login as SYSNAME ) As

DECLARE @Login AS VARCHAR(25) = 'HSP_dbo';
DECLARE @sql VARCHAR(MAX) ,
    @DB_Objects VARCHAR(512);
SELECT  @DB_Objects = ' L.name as Login, U.Name as [User], O.*
From %D%.sys.objects o
Join %D%.sys.database_principals u
ON Coalesce(o.principal_id, (Select S.Principal_ID from %D%.sys.schemas S Where S.Schema_ID = O.schema_id))= U.principal_id
left join %D%.sys.server_principals L on L.sid = u.sid';

SELECT  @sql = 'SELECT * FROM
(Select ' + CAST(database_id AS VARCHAR(9))
        + ' as DBID, ''master'' as DBName, ' + REPLACE(@DB_Objects, '%D%',
                                                       [name])
FROM    master.sys.databases
WHERE   [name] = 'master';

SELECT  @sql = @sql + 'UNION ALL Select ' + CAST(database_id AS VARCHAR(9))
        + ', ''' + [name] + ''', ' + REPLACE(@DB_Objects, '%D%', [name])
FROM    master.sys.databases
WHERE   [name] != 'master';

SELECT  @sql = @sql + ') oo Where Login = ''' + @Login + '''';

PRINT @sql;
EXEC (@sql);
