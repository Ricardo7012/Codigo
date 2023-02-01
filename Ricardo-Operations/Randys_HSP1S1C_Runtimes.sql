use HSP_Supplemental
go

set transaction isolation level read uncommitted

declare @Start datetime2 = cast('2019-01-27 00:00' as datetime2)
       ,@End datetime2 = cast('2019-02-04 00:00:00' as datetime2)

declare @StepCount int = 7
       ,@IEHPStepNumber int = 6
	   ,@HSPStepNumber int = 2

declare @RunIdTable table
    (
        RunId uniqueidentifier not null primary key
       ,MaxDOP int null
       ,Threshold int null
       ,RunStartTime datetime2 null
       ,HspAuxilliaryStartTime datetime2 null
       ,IEHPMemberDateReformatStartTime datetime2 null
       ,RunEndTime datetime2 null
       ,SortOrder int null
    );

declare @TimeTable table
    (
        RunId uniqueidentifier not null
       ,RunTime datetime2 null
    );

with FullRunId
    as
        (
            select  RunId
            from    EBM.ExtractRunStatistics
            where   ExtractName = 'member'
                    and StepTime
                    between @Start
                    and     @End
            group by RunId
            having  count(1) = @StepCount
        )
insert into @RunIdTable
    (
        RunId
    )
select  distinct
        rs.RunId
from    EBM.ExtractRunStatistics rs
        join FullRunId rid
            on rid.RunId = rs.RunId

--	Get enrolled member export start time
insert into @TimeTable
    (
        RunId
       ,RunTime
    )
select  distinct
        rid.RunId
       ,case row_number() over (partition by rs.RunId
                                order by rs.StepTime
                               ) % @StepCount
             when 1 then rs.StepTime
             else null
        end as RunStartTime
from    EBM.ExtractRunStatistics rs
        join @RunIdTable rid
            on rid.RunId = rs.RunId

delete @TimeTable
where   RunTime is null

update  rid
set RunStartTime = tt.RunTime
from    @RunIdTable rid
        join @TimeTable tt
            on tt.RunId = rid.RunId

delete @TimeTable

--	Get member HSP auxilliary table export start time
insert into @TimeTable
    (
        RunId
       ,RunTime
    )
select  distinct
        rid.RunId
       ,case row_number() over (partition by rs.RunId
                                order by rs.StepTime
                               ) % @StepCount
             when @HSPStepNumber then rs.StepTime
             else null
        end as RunStartTime
from    EBM.ExtractRunStatistics rs
        join @RunIdTable rid
            on rid.RunId = rs.RunId

delete @TimeTable
where   RunTime is null

update  rid
set rid.HspAuxilliaryStartTime = tt.RunTime
from    @RunIdTable rid
        join @TimeTable tt
            on tt.RunId = rid.RunId

delete @TimeTable

--	Get member date reformatting start time
insert into @TimeTable
    (
        RunId
       ,RunTime
    )
select  distinct
        rid.RunId
       ,case row_number() over (partition by rs.RunId
                                order by rs.StepTime
                               ) % @StepCount
             when @IEHPStepNumber then rs.StepTime
             else null
        end as RunStartTime
from    EBM.ExtractRunStatistics rs
        join @RunIdTable rid
            on rid.RunId = rs.RunId

delete @TimeTable
where   RunTime is null

update  rid
set rid.IEHPMemberDateReformatStartTime = tt.RunTime
from    @RunIdTable rid
        join @TimeTable tt
            on tt.RunId = rid.RunId

delete @TimeTable

--	Get member export stop time
insert into @TimeTable
    (
        RunId
       ,RunTime
    )
select  distinct
        rid.RunId
       ,case row_number() over (partition by rs.RunId
                                order by rs.StepTime
                               ) % @StepCount
             when 0 then rs.StepTime
             else null
        end as RunEndTime
from    EBM.ExtractRunStatistics rs
        join @RunIdTable rid
            on rid.RunId = rs.RunId

delete @TimeTable
where   RunTime is null

update  rid
set rid.RunEndTime = tt.RunTime
from    @RunIdTable rid
        join @TimeTable tt
            on tt.RunId = rid.RunId;

with Sorted
    as
        (
            select  RunId
                   ,row_number() over (order by RunStartTime) as SortOrder
            from    @RunIdTable
        )
update  rid
set rid.SortOrder = s.SortOrder
from    @RunIdTable rid
        join Sorted s
            on s.RunId = rid.RunId

update  rid
set rid.MaxDOP = ersp.MaxDOP
   ,rid.Threshold = ersp.Threshold
from    @RunIdTable rid
        join EBM.ExtractRunStatisticsParallelism ersp
            on ersp.RunId = rid.RunId

select  RunId
       ,RunStartTime
       ,RunEndTime
       ,convert(decimal(10, 3), datediff(second, RunStartTime, HspAuxilliaryStartTime) / 60.) as HspMemberExportTimeInMinutes
       ,convert(decimal(10, 3), datediff(second, HspAuxilliaryStartTime, IEHPMemberDateReformatStartTime) / 60.) as HSPAuxilliaryTableExportTimeInMinutes
       ,convert(decimal(10, 3), datediff(second, IEHPMemberDateReformatStartTime, RunEndTime) / 60.) as IEHPDateReformatTimeInMinutes
       ,convert(decimal(10, 3), datediff(second, RunStartTime, RunEndTime) / 60.) as TotalExecutionTimeInMinutes
       ,MaxDOP
       ,Threshold
from    @RunIdTable
order by SortOrder