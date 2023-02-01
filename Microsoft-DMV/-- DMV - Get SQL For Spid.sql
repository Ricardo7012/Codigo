-------------------------------------------------

-- Purpose:   Returns the SQL text for a given spid.

---------------------------------------------------

DECLARE @spid SMALLINT 
DECLARE @SqlHandle BINARY(20)
DECLARE @SqlText NVARCHAR(4000)
   -- Get sql_handle for the given spid.
   SELECT @SqlHandle = sql_handle 
      FROM sys.sysprocesses WITH (nolock) WHERE 
      spid = @spid
   -- Get the SQL text for the given sql_handle.
   SELECT @SqlText = [text] FROM 
      sys.dm_exec_sql_text(@SqlHandle)
   RETURN @SqlText

GO
