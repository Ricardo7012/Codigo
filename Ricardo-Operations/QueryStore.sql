SELECT * FROM sys.database_query_store_options

ALTER DATABASE HSP SET QUERY_STORE CLEAR

ALTER DATABASE HSP SET QUERY_STORE=ON

SELECT max_storage_size_mb - current_storage_size_mb from sys.database_query_store_options

