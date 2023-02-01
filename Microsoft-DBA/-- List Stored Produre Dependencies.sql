-- List Stored Produre Dependencies

SELECT DISTINCT o.NAME AS 'Procedure_Name'
	, soo.NAME AS 'Table_Name'
--, d.depnumber  -- comment this out returns unique tables only
FROM sysdepends d
	, sysobjects so
	, sysobjects soo
WHERE so.id = d.id
	AND so.NAME = 'Report_MeterReadingByType' -- Stored Procedure Name
	AND soo.id = d.depid
--and depnumber=1
ORDER BY so.NAME
	, soo.NAME