-- List Ratio on Indexes

SELECT st.NAME AS 'Table Name'
	, si.NAME AS 'Index Name'
	, si.dpages AS 'Data Page'
	, sp.rows AS 'Rows'
	, cast(1.0 * sp.rows / si.dpages AS DECIMAL(10, 2)) AS 'Ratio'
FROM sys.sysindexes si
INNER JOIN sys.partitions sp
	ON si.id = sp.object_id
INNER JOIN sys.tables st
	ON si.id = st.object_id
WHERE si.dpages > 1 --objects that have used more than one page
	AND st.type = 'U' --user tables only
	AND si.indid = sp.index_id
	AND si.rows > 1000 --objects with more than 1000 rows
ORDER BY 'Table Name' ASC
