
-- =============================================
-- AUTHOR: Bindu Motaparthi     
-- CREATE DATE: 12/12/2019
-- DESCRIPTION: Configure Max DOP and Cost Threshold for Parallelism
--	For <= 8 cores 
--	MAX DOP <=8
--	For > 8 cores 
--	MAX DOP =8


-- =============================================
EXEC master.dbo.sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO

declare @ProcessorCount varchar(4)
exec xp_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'NUMBER_OF_PROCESSORS', @ProcessorCount output
set @ProcessorCount = cast(rtrim(ltrim(@ProcessorCount)) as tinyint)
select @processorcount

-- Limit MAXDOP to 8
if @ProcessorCount > 8
begin
	exec sp_configure N'max degree of parallelism', N'8';
	reconfigure with override;
end

else if @ProcessorCount <= 8
begin
	exec sp_configure N'max degree of parallelism', @processorCount;
	reconfigure with override;
end

exec sp_configure N'cost threshold for parallelism', N'30';
reconfigure with override;

--ref: https://support.microsoft.com/en-us/help/2806535/recommendations-and-guidelines-for-the-max-degree-of-parallelism-confi