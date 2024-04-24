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
/*
In SQL Server, the `PAGE_VERIFY` option is a database setting that helps ensure the integrity of data pages when they are written to and read from disk.
There are three options for `PAGE_VERIFY`: `CHECKSUM`, `TORN_PAGE_DETECTION`, and `NONE`.

1. **CHECKSUM**: When this option is enabled, the SQL Server Database Engine calculates a checksum over the contents of the 
whole page and stores the value in the page header when a page is written to disk. When the page is read from disk, 
the checksum is recomputed and compared to the checksum value stored in the page header¹. If there's a discrepancy, 
SQL Server reports an error¹. This option provides the most robust detection of database consistency problems caused by the system I/O path.

2. **TORN_PAGE_DETECTION**: This option operates similarly to `CHECKSUM`. When a page is written, the first 2 bytes of each 512-byte 
sector are stored in the page header. When the page is read back, SQL Server compares the stored information and the sector bytes 
to detect any discrepancy and return an error if the comparison fails.

3. **NONE**: This option means no page verification is performed. It's a risky choice because the purpose of the `PAGE_VERIFY` 
option is to provide a crucial check between when a page is written to disk and when it is read again to ensure its consistency.

The best practice recommendation is to set the `PAGE_VERIFY` database option to `CHECKSUM`. 
This is because `CHECKSUM` bases its verification on a value calculated by using the entire page, 
making the comparison between operations a much more thorough and effective option for page verification.

*/