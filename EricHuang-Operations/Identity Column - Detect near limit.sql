/* Define how close we are to the value limit
   before we start throwing up the red flag.
   The higher the value, the closer to the limit. */
Declare @threshold decimal(3,2) = .85;
 
/* Create a temp table */
Create Table #identityStatus
(
      database_name     varchar(128)
    , table_name        varchar(128)
    , column_name       varchar(128)
    , data_type         varchar(128)
    , last_value        bigint
    , max_value         bigint
);
 
/* Use an undocumented command to run a SQL statement
   in each database on a server */
Execute sp_msforeachdb '
    Use [?];
    Insert Into #identityStatus
    Select ''?'' As [database_name]
        , Object_Name(id.object_id, DB_ID(''?'')) As [table_name]
        , id.name As [column_name]
        , t.name As [data_type]
        , Cast(id.last_value As bigint) As [last_value]
        , Case 
            When t.name = ''tinyint''   Then 255 
            When t.name = ''smallint''  Then 32767 
            When t.name = ''int''       Then 2147483647 
            When t.name = ''bigint''    Then 9223372036854775807
          End As [max_value]
    From sys.identity_columns As id
    Join sys.types As t
        On id.system_type_id = t.system_type_id
    Where id.last_value Is Not Null';
 
/* Retrieve our results and format it all prettily */
Select database_name
    , table_name
    , column_name
    , data_type
    , last_value
    , Case 
        When last_value < 0 Then 100
        Else (1 - Cast(last_value As float(4)) / max_value) * 100 
      End As [percentLeft]
    , Case 
        When Cast(last_value As float(4)) / max_value >= @threshold
            Then 'warning: approaching max limit'
        Else 'okay'
        End As [id_status]
From #identityStatus
Order By percentLeft;
 
/* Clean up after ourselves */
Drop Table #identityStatus;