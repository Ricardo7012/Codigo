--CHECK WHO IS DB_OWNER
SELECT  [name] ,
        SUSER_SNAME(owner_sid)
FROM    sys.databases
ORDER BY DATABASE_id ASC
