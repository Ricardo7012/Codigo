-- CHECK ID AUTOMATIC STATISTICS UPDATE IS ON
SELECT is_auto_create_stats_on,
is_auto_update_stats_on
FROM 
sys.databases
WHERE
[NAME]='ReportServer'
