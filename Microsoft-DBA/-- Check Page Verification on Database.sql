-- Check Page Verification on Database

USE Master
GO

SELECT NAME AS [DatabaseName]
    , CASE 
        WHEN page_verify_option = 0
            THEN 'NONE'
        WHEN page_verify_option = 1
            THEN 'TORN_PAGE_DETECTION'
        WHEN page_verify_option = 2
            THEN 'CHECKSUM'
        END AS [Page Verify Setting]
FROM sys.databases
GO
