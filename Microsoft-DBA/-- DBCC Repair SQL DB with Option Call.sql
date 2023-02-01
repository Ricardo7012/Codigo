-- DBCC Repair SQL DB with Option Call

EXEC isp_RepairDB @SearchDBName = 'DB_Name',@DBCCOption = 'REPAIR_ALLOW_DATA_LOSS'