-- HSP3S1A
-- https://blogs.msdn.microsoft.com/dataaccesstechnologies/2017/07/07/invalid-column-__command_id-issue-during-cdc-implementation-in-ssis-package/
USE HSP_Supplemental
GO
sp_msforeachtable N'
DECLARE @tsql nvarchar(MAX),
              @fn_all sysname,
              @fn_all_bk sysname,
              @fn_net sysname,
              @fn_net_bk sysname,
              @supports_net_changes bit 

IF object_id(N''cdc.change_tables'') IS NULL RETURN 

PRINT N''Verifying OBJECT ?...''
	SELECT @fn_all = N''fn_cdc_get_all_changes_'' + ct.capture_instance
		, @fn_all_bk = N''[cdc].[fn_cdc_get_all_changes_'' + ct.capture_instance + N''_original]''
		, @fn_net = N''fn_cdc_get_net_changes_'' + ct.capture_instance
		, @fn_net_bk = N''[cdc].[fn_cdc_get_net_changes_'' + ct.capture_instance + N''_original]''
		, @supports_net_changes = ct.supports_net_changes
	FROM 
		cdc.change_tables ct
	WHERE 
		ct.source_object_id = object_id(N''?'') 
IF @fn_all IS NULL OR object_id(N''[cdc].[''+@fn_all+N'']'') IS NULL 
BEGIN 
PRINT N''Workaround was not required for this table (is not enabled for CDC).'' 
END 
ELSE IF object_id(@fn_all_bk) IS NULL 
BEGIN 
	PRINT N''Workaround was not applied for this table.'' 
END 
ELSE 
BEGIN IF object_id(N''[cdc].[''+@fn_all+N'']'') IS NOT NULL 
BEGIN 
PRINT N''Removing proxy FUNCTION ''+@fn_all
  SET @tsql = N''
  DROP FUNCTION [cdc].[''+@fn_all+N'']'' 
  EXEC (@tsql) 
  END 
  PRINT N''Renaming function populating all changes back to original name'' 
  EXEC sp_rename @fn_all_bk,@fn_all IF @supports_net_changes = 1
	AND object_id(@fn_net_bk) IS NOT NULL 
BEGIN IF @fn_net IS NOT NULL
	AND object_id(N''[cdc].[''+@fn_net+N'']'') IS NOT NULL 
BEGIN 
PRINT N''Removing proxy function ''+@fn_net
  SET @tsql = N''
  DROP FUNCTION [cdc].[''+@fn_net+N'']'' 
  EXEC (@tsql) 
  END 
  PRINT N''Renaming function populating all changes back to original name'' 
  EXEC sp_rename @fn_net_bk, @fn_net
END
END'

GO