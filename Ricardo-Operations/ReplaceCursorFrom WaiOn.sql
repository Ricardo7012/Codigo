DECLARE @VName VARCHAR(256);        
            
SELECT  CONVERT(VARCHAR(250), ' ') AS StoredProcedureName ,
        CONVERT(VARCHAR(250), ' ') AS LinkServerName ,
        CONVERT(INT, 1) AS ObjectID ,
        CONVERT(VARCHAR(30), ' ') AS ObjectType
INTO    #temp_StoredProcedure;            
            
DECLARE Findlinked CURSOR LOCAL STATIC FORWARD_ONLY READ_ONLY
FOR
    SELECT  name
    FROM    sys.servers
    WHERE   is_linked = 1;    
            
OPEN Findlinked;        
FETCH NEXT FROM Findlinked INTO @VName;         
            
WHILE @@FETCH_STATUS = 0
    BEGIN         
            
        INSERT  INTO #temp_StoredProcedure
                ( StoredProcedureName ,
                  LinkServerName ,
                  ObjectID ,
                  ObjectType
                )
                SELECT  OBJECT_NAME(object_id) AS StoredProcedureName ,
                        @VName AS LinkServerName ,
                        object_id ,
                        CASE WHEN OBJECTPROPERTY(object_id, 'IsProcedure') = 1
                             THEN 'Procedure'
                             WHEN OBJECTPROPERTY(object_id, 'IsView') = 1
                             THEN 'view'
                             WHEN OBJECTPROPERTY(object_id, 'IsTrigger') = 1
                             THEN 'Trigger'
                             WHEN OBJECTPROPERTY(object_id, 'IsScalarFunction') = 1
                             THEN 'ScalarFunction'
                             WHEN OBJECTPROPERTY(object_id, 'IsTableFunction') = 1
                             THEN 'TableFunction'
                             ELSE 'Other'
                        END
                FROM    sys.sql_modules
                WHERE   definition LIKE '%' + @VName + '.' + @VName + '%'
                        AND ( ( OBJECTPROPERTY(object_id, 'IsProcedure') = 1 )
                              OR ( OBJECTPROPERTY(object_id, 'Isview') = 1 )
                              OR ( OBJECTPROPERTY(object_id, 'IsTrigger') = 1 )
                              OR ( OBJECTPROPERTY(object_id, 'IsTableFunction') = 1 )
                              OR ( OBJECTPROPERTY(object_id,
                                                  'IsScalarFunction') = 1 )
                            );
            
        FETCH NEXT FROM Findlinked INTO @VName; 
    END;          
            
CLOSE Findlinked;       
DEALLOCATE Findlinked;  

DECLARE @ObjectID INT;
DECLARE @LinkServerName VARCHAR(50);
DECLARE @SP NVARCHAR(MAX);
DECLARE @Linkcheck VARCHAR(50);

DECLARE Findlinked CURSOR LOCAL STATIC FORWARD_ONLY READ_ONLY
FOR
    SELECT  ObjectID ,
            LinkServerName
    FROM    #temp_StoredProcedure
    WHERE   StoredProcedureName <> ' '
            AND ObjectID = 2024394281;
            
OPEN Findlinked;        
FETCH NEXT FROM Findlinked INTO @ObjectID, @LinkServerName;       
            
WHILE @@FETCH_STATUS = 0
    BEGIN

        SELECT  @SP = definition
        FROM    sys.sql_modules
        WHERE   object_id = @ObjectID;

        SET @SP = REPLACE(@SP, 'Create', 'Alter');

        SELECT  @SP;
        
        SET @Linkcheck = @LinkServerName + '.' + @LinkServerName + '.';
        
        SET @SP = REPLACE(@SP, @Linkcheck, @LinkServerName + '.');
        
        SELECT  @SP;
       
        EXEC (@SP);
            
        FETCH NEXT FROM Findlinked INTO @ObjectID, @LinkServerName;           
                  
    END;          
            
CLOSE Findlinked;       
DEALLOCATE Findlinked;        

--DROP TABLE #temp_StoredProcedure;

SELECT * FROM #temp_StoredProcedure
