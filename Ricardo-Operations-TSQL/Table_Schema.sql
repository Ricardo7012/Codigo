sys.sp_helpdb @dbname = 'Pharmacy'


SELECT  TABLE_CATALOG ,
        TABLE_SCHEMA ,
        TABLE_NAME ,
        COLUMN_NAME ,
        COLUMN_DEFAULT ,
        IS_NULLABLE ,
        DATA_TYPE
FROM    Pharmacy.INFORMATION_SCHEMA.COLUMNS
WHERE   TABLE_NAME = 'vw_IEHP_Pharmacy_Providers_History'
ORDER BY TABLE_NAME ,
        ORDINAL_POSITION;

