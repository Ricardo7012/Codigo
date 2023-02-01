USE HSP_MO;  
GO  
EXEC sys.sp_cdc_disable_db;  
GO  
EXEC sys.sp_cdc_enable_db
GO
EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'dbo'  
  , @source_name =  'MemberCoverages'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  0   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  --, @captured_column_list =  NULL   
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO
SELECT * FROM cdc.change_tables
GO


EXECUTE sys.sp_cdc_enable_table 
	@source_schema =  'dbo'  
  , @source_name =  'BenefitCoverages'   
  --, @capture_instance =  ''   
  , @supports_net_changes =  0   
  , @role_name =  NULL  
  --, @index_name =  NULL   
  --, @captured_column_list =  ''  
  --, @filegroup_name =  NULL   
  , @allow_partition_switch =  1 
GO
SELECT * FROM cdc.change_tables
GO