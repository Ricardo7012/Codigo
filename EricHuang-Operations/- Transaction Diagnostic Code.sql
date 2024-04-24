/*
Transaction Diagnostic T-SQL Code - Transactions does not have to be active, just open.

The T-SQL code below should be run from within the database you are concerned about. It will give you the following:

    Transactions that are taking up space in the database.
    The T-SQL code that initially fired the transaction.
    The size used by both the transaction and the system in the transaction in both MB and bytes
    The current state or status of the transaction.
    The number of log records used along with their lsn numbers.

This code can be run any time the transaction(s) are open, even if requests are not actively executing.
*/

CREATE TABLE #Tmp_Transaction
(
   ID int identity(1,1),
   [TransactionName] [nvarchar](32) NOT NULL,
   [transaction_id] [bigint] NOT NULL,
   [transaction_begin_time] [datetime] NOT NULL,
   [transaction_type] [int] NOT NULL,
   [transaction_state] [int] NOT NULL,
   [session_id] [int] NOT NULL,
   [TranLog_MB_Used] [bigint] NULL,
   [TranLog_MB_Reserved] [bigint] NULL,
   [TranLogSys_MB_Used] [int] NULL,
   [TranLogSys_MB_Reserved] [int] NULL,
   [database_transaction_type] [int] NOT NULL,
   [database_transaction_state] [int] NOT NULL,
   [database_transaction_status] [int] NOT NULL,
   [database_transaction_status2] [int] NOT NULL,
   [database_transaction_log_record_count] [bigint] NOT NULL,
   [database_transaction_replicate_record_count] [int] NOT NULL,
   [database_transaction_log_bytes_used] [bigint] NOT NULL,
   [database_transaction_log_bytes_reserved] [bigint] NOT NULL,
   [database_transaction_log_bytes_used_system] [int] NOT NULL,
   [database_transaction_log_bytes_reserved_system] [int] NOT NULL,
   [database_transaction_begin_lsn] [numeric](25, 0) NULL,
   [database_transaction_last_lsn] [numeric](25, 0) NULL,
   [database_transaction_most_recent_savepoint_lsn] [numeric](25, 0) NULL,
   [database_transaction_commit_lsn] [numeric](25, 0) NULL,
   [database_transaction_last_rollback_lsn] [numeric](25, 0) NULL,
   [database_transaction_next_undo_lsn] [numeric](25, 0) NULL,
   EventInfo nvarchar(Max)
)

CREATE TABLE #inputb
(
	EventType nvarchar(Max),  Parameters int, EventInfo nvarchar(Max)
) -- hold buffer

declare @iRwCnt int
declare @i int
declare @iSPID int
declare @vSPID varchar(4)
set @i = 1


insert into #Tmp_Transaction(TransactionName, transaction_id,
transaction_begin_time, transaction_type, transaction_state, session_id,
TranLog_MB_Used, TranLog_MB_Reserved, TranLogSys_MB_Used, TranLogSys_MB_Reserved,
database_transaction_type, database_transaction_state, database_transaction_status,
database_transaction_status2, database_transaction_log_record_count,
database_transaction_replicate_record_count, database_transaction_log_bytes_used,
database_transaction_log_bytes_reserved,
database_transaction_log_bytes_used_system,
database_transaction_log_bytes_reserved_system, database_transaction_begin_lsn,
database_transaction_last_lsn, database_transaction_most_recent_savepoint_lsn,
database_transaction_commit_lsn, database_transaction_last_rollback_lsn,
database_transaction_next_undo_lsn)
select at.name [TransactionName], at.transaction_id, at.transaction_begin_time,
at.transaction_type, at.transaction_state, st.session_id,
(dt.database_transaction_log_bytes_used/1048576) [TranLog_MB_Used],
(dt.database_transaction_log_bytes_reserved/1048576) [TranLog_MB_Reserved], (dt.database_transaction_log_bytes_used_system/1048576) [TranLogSys_MB_Used],
(dt.database_transaction_log_bytes_reserved_system/1048576)
[TranLogSys_MB_Reserved],
dt.[database_transaction_type], dt.[database_transaction_state],
dt.[database_transaction_status], dt.[database_transaction_status2],
dt.[database_transaction_log_record_count],
dt.[database_transaction_replicate_record_count],
dt.[database_transaction_log_bytes_used],
dt.[database_transaction_log_bytes_reserved],
dt.[database_transaction_log_bytes_used_system],
dt.[database_transaction_log_bytes_reserved_system],
dt.[database_transaction_begin_lsn],
dt.[database_transaction_last_lsn],
dt.[database_transaction_most_recent_savepoint_lsn],
dt.[database_transaction_commit_lsn], dt.[database_transaction_last_rollback_lsn],
dt.[database_transaction_next_undo_lsn]
from sys.dm_tran_active_transactions at
inner join sys.dm_tran_session_transactions st on at.transaction_id =
st.transaction_id
inner join sys.dm_tran_database_transactions dt on at.transaction_id =
dt.transaction_id
where dt.database_id = DB_ID() and dt.database_transaction_state in (4,12) and
st.is_user_transaction = 1
set @iRwCnt =  @@ROWCOUNT

while @i <= @iRwCnt
begin
   select @iSPID = t.session_id from #Tmp_Transaction t where t.ID = @i
   set @vSPID = Convert(varchar,@iSPID)

   truncate table #inputb
   INSERT #inputb EXEC ( 'DBCC INPUTBUFFER (' + @vSPID + ') WITH NO_INFOMSGS')

   update t set t.EventInfo = (select top 1 EventInfo from #inputb)
   from #Tmp_Transaction t
   where t.ID = @i

   set @i = @i+1

end

select TransactionName, transaction_id, transaction_begin_time, transaction_type,
transaction_state, session_id, TranLog_MB_Used, TranLog_MB_Reserved,
TranLogSys_MB_Used, TranLogSys_MB_Reserved, EventInfo, database_transaction_type,
database_transaction_state, database_transaction_status,
database_transaction_status2, database_transaction_log_record_count,
database_transaction_replicate_record_count, database_transaction_log_bytes_used,
database_transaction_log_bytes_reserved,
database_transaction_log_bytes_used_system,
database_transaction_log_bytes_reserved_system, database_transaction_begin_lsn,
database_transaction_last_lsn, database_transaction_most_recent_savepoint_lsn,
database_transaction_commit_lsn, database_transaction_last_rollback_lsn,
database_transaction_next_undo_lsn
from #Tmp_Transaction

drop table #Tmp_Transaction
drop table #inputb

/*
Transaction T-SQL Diagnostic - Transactions have to be actively executing for this to work.

This next code is designed to be used with the T-SQL above to provide a complete picture. Basically it will give you information on actively executing transactions, providing you with:

    Various information on what the initial T-SQL call was.
    What sub-text within the initial T-SQL call is currently executing.
    What the current state/begin time is, as well as any completion percentage.
*/

SELECT st.Session_id, req.Blocking_Session_ID [Blocker], req.Wait_Type,
req.Wait_Time [WaitTimeMS], req.Wait_Resource, req.open_transaction_count,
req.percent_complete, dt.transaction_id, dt.database_transaction_begin_time, case
when dt.database_transaction_type = 1 then  'RW' when dt.database_transaction_type =
2 then 'R' when dt.database_transaction_type = 3 then 'Sys' else 'Unknown' end
[TranType],
case when dt.database_transaction_state = 1 then  'Not Initialized' when
dt.database_transaction_state = 3 then  'Initialized, but no logs' when
dt.database_transaction_state = 4 then  'Generated logs' when
dt.database_transaction_state = 5 then  'Prepared' when
dt.database_transaction_state = 10 then  'Committed' when
dt.database_transaction_state = 11 then  'Rolled Back' when
dt.database_transaction_state = 12 then  'In process of committing' else 'Unknown'
end [TranState],
req. Status, req.Command, stxt.objectid [ExecObjID],
(SUBSTRING(stxt. text,req.statement_start_offset/2,( CASE WHEN
req.statement_end_offset = -1 then  LEN(CONVERT(nvarchar(max), stxt. text)) * 2 ELSE
req.statement_end_offset end -req.statement_start_offset)/2)) [SubText], stxt. text,
req.statement_start_offset
FROM  sys.dm_tran_database_transactions dt (nolock)
inner join sys.dm_tran_session_transactions st (nolock) on dt.transaction_id =
st.transaction_id
inner join  sys.dm_exec_requests req (nolock) on st.transaction_id =
req.transaction_id
CROSS APPLY  sys.dm_exec_sql_text(req. sql_handle) [stxt]
where dt.database_id = db_id() and st.is_user_transaction = 1
