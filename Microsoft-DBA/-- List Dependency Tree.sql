-- List Dependency Tree

SET NOCOUNT ON

SELECT 'name' = (o1.NAME)
	, 'id' = (o1.id)
	, 'type' = substring(v2.NAME, 5, 16)
	, 'query' = replace(replace(substring(c7.[text], charindex('@', left(c7.[text], charindex('AS' + CHAR(13) + CHAR(10), replace(Upper(c7.[text]), 'AS ' + CHAR(13) + CHAR(10), 'AS' + CHAR(13) + CHAR(10)), 1)), 1), charindex('AS' + CHAR(13) + CHAR(10), replace(Upper(c7.[text]), 'AS ' + CHAR(13) + CHAR(10), 'AS' + CHAR(13) + CHAR(10)), 1) - charindex('@', left(c7.[text], charindex('AS' + CHAR(13) + CHAR(10), replace(Upper(c7.[text]), 'AS ' + CHAR(13) + CHAR(10), 'AS' + CHAR(13) + CHAR(10)), 1)), 1)), '))', ')'), 'nt])', 'nt]')
INTO [dbo].#Initial
FROM [dbo].sysobjects o1
INNER JOIN master.dbo.spt_values v2
	ON o1.xtype = substring(v2.NAME, 1, 2) collate database_default AND v2.type = 'O9T'
INNER JOIN [dbo].syscomments c7
	ON o1.id = c7.id AND o1.xtype = 'p'
WHERE o1.xtype <> 's' AND o1.xtype <> 'c' AND left(o1.NAME, 3) <> 'dt_' AND left(o1.NAME, 2) <> 'dd'
ORDER BY 'type'
	, 'name'

UPDATE [dbo].#Initial
SET query = ''
WHERE charindex('CREATE', query, 1) > 0

UPDATE [dbo].#Initial
SET query = replace(query, CHAR(13) + CHAR(10), '')

WHILE EXISTS (
		SELECT *
		FROM [dbo].#Initial
		WHERE charindex('  ', query, 1) > 0
		)
	UPDATE [dbo].#Initial
	SET query = replace(query, '  ', ' ')

CREATE TABLE [dbo].[#Report] (
	[IDC] [int] IDENTITY(1, 1) NOT NULL
	, [objectid] [int] NULL
	, [objectname] [nvarchar](776) NULL
	, [objecttype] [varchar](100) NULL
	, [depname] [varchar](776) NULL
	, [deptype] [varchar](100) NULL
	, [depupdated] [varchar](10) NULL
	, [depselected] [varchar](10) NULL
	, [depcolumn] [varchar](100) NULL
	) ON [PRIMARY]

DECLARE @objid INT /* the id of the object we want */
DECLARE @found_some BIT /* flag for dependencies found */
DECLARE @dbname SYSNAME

DECLARE lcReport CURSOR LOCAL FAST_FORWARD
FOR
SELECT 'name' = (o1.NAME)
	, 'type' = substring(v2.NAME, 5, 16)
	, 'oid' = (o1.id)
FROM [dbo].sysobjects o1
	, master.dbo.spt_values v2
	, [dbo].sysusers s6
WHERE o1.xtype = substring(v2.NAME, 1, 2) collate database_default AND v2.type = 'O9T' AND o1.uid = s6.uid AND left(o1.[name], 3) <> 'dt_' AND (o1.xtype = 'p' OR o1.xtype = 'u' OR o1.xtype = 'v' OR o1.xtype = 'fn')
ORDER BY 'type'
	, 'name'

OPEN lcReport

DECLARE @objname NVARCHAR(776)
DECLARE @objtype VARCHAR(50)
DECLARE @oid INT

FETCH NEXT
FROM lcReport
INTO @objname
	, @objtype
	, @oid

WHILE @@fetch_status = 0
BEGIN
	SET @dbname = parsename(@objname, 3)

	/*
 **  See if @objname exists.
 */
	SELECT @objid = object_id(@objname)

	IF @objid IS NOT NULL
	BEGIN
		/*
  **  Initialize @found_some to indicate that we haven't seen any dependencies.
  */
		SET @found_some = 0

		INSERT [dbo].#Report
		SELECT @oid
			, @objname
			, @objtype
			, ''
			, ''
			, ''
			, ''
			, ''

		/*
  **  Print out the particulars about the local dependencies.
  */
		IF EXISTS (
				SELECT *
				FROM [dbo].sysdepends
				WHERE id = @objid
				)
		BEGIN
			INSERT [dbo].#Report
			SELECT @oid
				, @objname
				, @objtype
				, 'name' = (o1.NAME)
				, type = substring(v2.NAME, 5, 16)
				, updated = substring(u4.NAME, 1, 7)
				, selected = substring(w5.NAME, 1, 8)
				, 'column' = ISNULL(col_name(d3.depid, d3.depnumber), '')
			FROM [dbo].sysobjects o1
				, master.dbo.spt_values v2
				, [dbo].sysdepends d3
				, master.dbo.spt_values u4
				, master.dbo.spt_values w5 --11667
				, [dbo].sysusers s6
			WHERE o1.id = d3.depid AND o1.xtype = substring(v2.NAME, 1, 2) collate database_default AND v2.type = 'O9T' AND u4.type = 'B' AND u4.number = d3.resultobj AND w5.type = 'B' AND w5.number = d3.readobj | d3.selall AND d3.id = @objid AND o1.uid = s6.uid AND deptype < 2
			ORDER BY 'name'
				, 'column'

			SET @found_some = 1
		END

		/*
  **  Now check for things that depend on the object.
  */
		IF EXISTS (
				SELECT *
				FROM [dbo].sysdepends
				WHERE depid = @objid
				)
		BEGIN
			INSERT [dbo].#Report
			SELECT DISTINCT @oid
				, @objname
				, @objtype
				, 'name' = (o.NAME) + ' depends on'
				, type = substring(v.NAME, 5, 16)
				, ''
				, ''
				, ''
			FROM.[dbo].sysobjects o
				, master.dbo.spt_values v
				, [dbo].sysdepends d
				, [dbo].sysusers s
			WHERE o.id = d.id AND o.xtype = substring(v.NAME, 1, 2) collate database_default AND v.type = 'O9T' AND d.depid = @objid AND o.uid = s.uid AND deptype < 2

			SET @found_some = 1
		END
	END

	FETCH NEXT
	FROM lcReport
	INTO @objname
		, @objtype
		, @oid
END

CLOSE lcReport

DEALLOCATE lcReport

CREATE CLUSTERED INDEX [idx_TDR] ON [dbo].[#Report] ([IDC]) ON [PRIMARY]

UPDATE [dbo].#Report
SET objectname = ''
	, objecttype = ''
WHERE depname <> ''

SELECT IDC
	, 'Object' = CASE 
		WHEN objecttype <> ''
			THEN 'Database Object ' + objecttype + ' ' + objectname
		WHEN depcolumn <> '' AND CharIndex('depends on', depname, 1) = 0
			THEN '     Depends on ' + deptype + ' ' + depname + ' column ' + depcolumn
		WHEN deptype <> '' AND CharIndex('depends on', depname, 1) = 0
			THEN '     Depends on ' + deptype + ' ' + depname
		WHEN depcolumn <> ''
			THEN '     Required by ' + deptype + ' ' + replace(depname, ' depends on', '') + ' column ' + depcolumn
		WHEN deptype <> ''
			THEN '     Required by ' + deptype + ' ' + replace(depname, ' depends on', '')
		END
	, 'Input' = ISNULL((
			SELECT TOP 1 replace(replace(query, CHAR(9), ' '), ',@', ', @')
			FROM [dbo].#Initial
			WHERE [id] = [objectid] AND objecttype <> ''
			), '')
INTO [dbo].#Final
FROM [dbo].#Report
ORDER BY IDC ASC

SELECT Object
	, input
FROM [dbo].#Final

DROP TABLE [dbo].#Report

DROP TABLE [dbo].#Initial

DROP TABLE [dbo].#Final

SET NOCOUNT OFF
GO


