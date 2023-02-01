-- https://docs.microsoft.com/en-us/sql/integration-services/system-stored-procedures/catalog-get-parameter-values-ssisdb-database
SELECT * FROM SSISDB.catalog.object_parameters 
WHERE CONVERT(VARCHAR(32),design_default_value) LIKE '\\%'

SELECT object_name,parameter_name, description, design_default_value FROM SSISDB.catalog.object_parameters 
WHERE CONVERT(VARCHAR(32),design_default_value) LIKE '\\%'


EXEC SSISDB.catalog.get_parameter_values 
	@folder_name =  'Development'  
    ,  @project_name = 'BatchLoads'   
    ,  @package_name = 'BatchLoad' 
    --,  @reference_id =  ''

EXEC SSISDB.catalog.get_any_parameter_values 
	@folder_name =  'ModelOffice'  
    ,  @project_name = 'BatchExtracts'   
    ,  @package_name = NULL 
    ,  @reference_id =  NULL

EXEC SSISDB.catalog.get_project 
	@folder_name =  'modeloffice' 
	, @project_name =  'BatchExtracts'  
