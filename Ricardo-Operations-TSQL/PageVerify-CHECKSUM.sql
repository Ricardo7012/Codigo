-- BLITZ RESULTS: PAGE VERIFICATION NOT OPTIMAL
-- https://www.brentozar.com/blitz/page-verification/
SELECT 'ALTER DATABASE ' + QUOTENAME(s.name) + ' SET PAGE_VERIFY CHECKSUM  WITH NO_WAIT;'
FROM sys.databases AS s
WHERE s.page_verify_option_desc <> 'CHECKSUM';
GO
