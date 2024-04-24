DECLARE @sql NVARCHAR(MAX)

    DECLARE db_cursor CURSOR FOR  
        select 'sp_dropserver ''' + [name] + '''' from sys.servers

    OPEN db_cursor   
    FETCH NEXT FROM db_cursor INTO @sql   

    WHILE @@FETCH_STATUS = 0   
    BEGIN   

           EXEC (@sql)

           FETCH NEXT FROM db_cursor INTO @sql   
    END   

    CLOSE db_cursor   
    DEALLOCATE db_cursor