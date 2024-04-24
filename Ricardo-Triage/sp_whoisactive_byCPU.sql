
/* CPU */
EXEC dbo.sp_WhoIsActive @get_transaction_info=0,
@output_column_list ='[session_id][start_time][cpu][reads][writes]
                  [status][context_switches][host_name][database_name][login_name][open_tran_count][wait_info][program_name][sql_text]', 
@sort_order='[CPU]DESC'
go

/*CPU delta*/
EXEC dbo.sp_WhoIsActive @delta_interval=5, @get_task_info = 2,
@output_column_list ='[session_id][start_time][cpu][reads][writes]
                  [status][context_switches][host_name][database_name][login_name][open_tran_count][wait_info][program_name][sql_text]', 
@sort_order='[CPU]DESC'
go

/*
-- CPU time is measured in milliseconds, and is the total of CPU time consumed across all logical cores,

Context Switches are computationally intensive and Windows Server is fully optimized to use of context switches. 
Switching from one process to another is required more time to save and load registers, memory maps, updating memory tables 
and lists within the Operating System. There are three different triggers for a context switch which are Multitasking, 
Interrupt Handling and; User and Kernel Mode Switching.
*/
--EXEC dbo.sp_WhoIsActive 
--go
