-- Age Out 1 Time USE Plans Greater than 10 MB

DECLARE @MB DECIMAL(19, 3)
DECLARE @Count BIGINT
DECLARE @StrMB NVARCHAR(20)

SELECT @MB = sum(cast((
				CASE 
					WHEN usecounts = 1
						AND objtype IN (
							'Adhoc'
							, 'Prepared'
							)
						THEN size_in_bytes
					ELSE 0
					END
				) AS DECIMAL(12, 2))) / 1024 / 1024
	, @Count = sum(CASE 
			WHEN usecounts = 1
				AND objtype IN (
					'Adhoc'
					, 'Prepared'
					)
				THEN 1
			ELSE 0
			END)
	, @StrMB = convert(NVARCHAR(20), @MB)
FROM sys.dm_exec_cached_plans

IF @MB > 10
BEGIN
	DBCC FREESYSTEMCACHE ('SQL Plans')

	RAISERROR (
			' % s MB was allocated TO single - USE PLAN cache.Single - USE plans have been cleared.'
			, 10
			, 1
			, @StrMB
			)
END
ELSE
BEGIN
	RAISERROR (
			'Only % s MB IS allocated TO single - USE PLAN cache – no need TO clear cache now.'
			, 10
			, 1
			, @StrMB
			) -- Note: this IS ONLY a warning message AND NOT an actual error.
END
GO


