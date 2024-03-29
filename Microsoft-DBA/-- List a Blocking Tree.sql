SET ANSI_NULLS ON 
GO 
SET QUOTED_IDENTIFIER ON 
GO 
-- ============================================= 
-- Description: Format bytes as largest unit (KB, MB, GB, TB, PB, EB, ZB, YB, BB, Geopbytes) 
-- Will take any unit of measurement as input (bytes, 
-- KB, MB, GB, TB, PB, EB, ZB, YB, BB, Geopbytes) and converts them first to 
-- bytes, then formats that as the largest whole UOM in 
-- a human readable format. 1024MB becomes 1.00GB, 0.5GB 
-- becomes 512MB, etc. 
-- INPUT: @InputNumber – Decimal(38,2) 
-- ============================================= 
ALTER FUNCTION [dbo].[udf_FormatBytes] 
( 
@InputNumber DECIMAL(38,7), 
@InputUOM VARCHAR(5) = ‘Bytes’ 
) 
RETURNS VARCHAR(20) 
WITH SCHEMABINDING 
AS 
BEGIN 
-- Declare the return variable here 
DECLARE @Output VARCHAR(48) 
DECLARE @Prefix MONEY 
DECLARE @Suffix VARCHAR(6) 
DECLARE @Multiplier DECIMAL(38,2) 
DECLARE @Bytes DECIMAL(38,2) 

SELECT @Multiplier = CASE @InputUOM 
WHEN ‘Bytes’ THEN 1 
WHEN ‘Byte’ THEN 1 
WHEN ‘B’ THEN 1 
WHEN ‘Kilobytes’ THEN 1024 
WHEN ‘Kilobyte’ THEN 1024 
WHEN ‘KB’ THEN 1024 
WHEN ‘Megabytes’ THEN 1048576 
WHEN ‘Megabyte’ THEN 1048576 
WHEN ‘MB’ THEN 1048576 
WHEN ‘Gigabytes’ THEN 1073741824 
WHEN ‘Gigabyte’ THEN 1073741824 
WHEN ‘GB’ THEN 1073741824 
WHEN ‘Terabytes’ THEN 1099511627776 
WHEN ‘Terabyte’ THEN 1099511627776 
WHEN ‘TB’ THEN 1099511627776 
WHEN ‘Petabytes’ THEN 1125899906842624 
WHEN ‘Petabyte’ THEN 1125899906842624 
WHEN ‘PB’ THEN 1125899906842624 
WHEN ‘Exabytes’ THEN 1152921504606846976 
WHEN ‘Exabyte’ THEN 1152921504606846976 
WHEN ‘EB’ THEN 1152921504606846976 
WHEN ‘Zettabytes’ THEN 1180591620717411303424 
WHEN ‘Zettabyte’ THEN 1180591620717411303424 
WHEN ‘ZB’ THEN 1180591620717411303424 
WHEN ‘Yottabytes’ THEN 1208925819614629174706176 
WHEN ‘Yottabyte’ THEN 1208925819614629174706176 
WHEN ‘YB’ THEN 1208925819614629174706176 
WHEN ‘Brontobytes’ THEN 1237940039285380274899124224 
WHEN ‘Brontobyte’ THEN 1237940039285380274899124224 
WHEN ‘BB’ THEN 1237940039285380274899124224 
WHEN ‘Geopbytes’ THEN 1267650600228229401496703205376 
WHEN ‘Geopbyte’ THEN 1267650600228229401496703205376 
END 

SELECT @Bytes = @InputNumber*@Multiplier 

SELECT @Prefix = CASE 
WHEN ABS(@Bytes) < 1024 THEN @Bytes –bytes 
WHEN ABS(@Bytes) < 1048576 THEN (@Bytes/1024) –kb 
WHEN ABS(@Bytes) < 1073741824 THEN (@Bytes/1048576) –mb 
WHEN ABS(@Bytes) < 1099511627776 THEN (@Bytes/1073741824) –gb 
WHEN ABS(@Bytes) < 1125899906842624 THEN (@Bytes/1099511627776) –tb 
WHEN ABS(@Bytes) < 1152921504606846976 THEN (@Bytes/1125899906842624) –pb 
WHEN ABS(@Bytes) < 1180591620717411303424 THEN (@Bytes/1152921504606846976) –eb 
WHEN ABS(@Bytes) < 1208925819614629174706176 THEN (@Bytes/1180591620717411303424) –zb 
WHEN ABS(@Bytes) < 1237940039285380274899124224 THEN (@Bytes/1208925819614629174706176) –yb 
WHEN ABS(@Bytes) < 1267650600228229401496703205376 THEN (@Bytes/1237940039285380274899124224) –bb 
ELSE (@Bytes/1267650600228229401496703205376) –geopbytes 
END, 
@Suffix = CASE 
WHEN ABS(@Bytes) < 1024 THEN ‘ Bytes’ 
WHEN ABS(@Bytes) < 1048576 THEN ‘ KB’ 
WHEN ABS(@Bytes) < 1073741824 THEN ‘ MB’ 
WHEN ABS(@Bytes) < 1099511627776 THEN ‘ GB’ 
WHEN ABS(@Bytes) < 1125899906842624 THEN ‘ TB’ 
WHEN ABS(@Bytes) < 1152921504606846976 THEN ‘ PB’ 
WHEN ABS(@Bytes) < 1180591620717411303424 THEN ‘ EB’ 
WHEN ABS(@Bytes) < 1208925819614629174706176 THEN ‘ ZB’ 
WHEN ABS(@Bytes) < 1237940039285380274899124224 THEN ‘ YB’ 
WHEN ABS(@Bytes) < 1267650600228229401496703205376 THEN ‘ BB’ 
ELSE ‘ Geopbytes’ 
END 

-- Return the result of the function 
SELECT @Output = CAST(@Prefix AS VARCHAR(39)) + @Suffix 
RETURN @Output 

END 
GO 

--GIVE PERMISSIONS FOR WEB REPORTS 
GRANT EXECUTE ON dbo.udf_FormatBytes TO webreport_approle, smsschm_users 
GO

-- NOW TEST IT

SELECT dbo.udf_FormatBytes(22345,’Bytes’) 

SELECT dbo.udf_FormatBytes(8675309,’MB’) 

SELECT dbo.udf_FormatBytes(0.5,’GB’)  

