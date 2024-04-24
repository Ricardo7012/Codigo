 -- ADR 
 -- https://www.mssqltips.com/sqlservertip/5971/accelerated-database-recovery-in-sql-server-2019/

--ALTER DATABASE HSP SET ACCELERATED_DATABASE_RECOVERY = ON;

SELECT
    [name]
    ,is_accelerated_database_recovery_on
FROM
sys.databases
