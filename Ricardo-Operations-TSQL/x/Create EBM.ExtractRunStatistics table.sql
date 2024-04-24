use HSP_Supplemental
go

set quoted_identifier on
go

create table EBM.ExtractRunStatistics
	(
		RunId uniqueidentifier not null
	   ,ExtractName varchar(50) not null
	   ,StepInformation varchar(200) not null
	   ,StepTime datetime2(7) not null
	) on [PRIMARY]
go


