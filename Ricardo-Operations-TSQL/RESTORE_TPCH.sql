USE [master]
RESTORE DATABASE [tpch100] 
FROM  
DISK = N'\\10.21.200.27\SQL-RapidRestore-SMB1\TPCH_Full_1.bak',  
DISK = N'\\10.21.200.28\SQL-RapidRestore-SMB2\TPCH_Full_2.bak',  
DISK = N'\\10.21.200.70\SQL-RapidRestore-SMB3\TPCH_Full_3.bak',  
DISK = N'\\10.21.200.71\SQL-RapidRestore-SMB4\TPCH_Full_4.bak',  
DISK = N'\\10.21.200.72\SQL-RapidRestore-SMB5\TPCH_Full_5.bak',  
DISK = N'\\10.21.200.73\SQL-RapidRestore-SMB6\TPCH_Full_6.bak',  
DISK = N'\\10.21.200.74\SQL-RapidRestore-SMB7\TPCH_Full_7.bak',  
DISK = N'\\10.21.200.75\SQL-RapidRestore-SMB8\TPCH_Full_8.bak' 
WITH  FILE = 1,  
MOVE N'tpch100_d1' TO N'I:\Data\tpch100.mdf',  
MOVE N'tpch100_fg1_d1' TO N'I:\Data\tpch100_fg1_d1.ndf',  
MOVE N'tpch100_fg1_d2' TO N'J:\Data\tpch100_fg1_d2.ndf',  
MOVE N'tpch100_fg1_d3' TO N'K:\Data\tpch100_fg1_d3.ndf', 
MOVE N'tpch100_fg1_d4' TO N'L:\Data\tpch100_fg1_d4.ndf',  
MOVE N'tpch100_fg1_d5' TO N'M:\Data\tpch100_fg1_d5.ndf',  
MOVE N'tpch100_fg1_d6' TO N'N:\Data\tpch100_fg1_d6.ndf',  
MOVE N'tpch100_fg1_d7' TO N'O:\Data\tpch100_fg1_d7.ndf',  
MOVE N'tpch100_fg1_d8' TO N'P:\Data\tpch100_fg1_d8.ndf', 
MOVE N'tpch100_log' TO N'Y:\Log\tpch100_log.ldf',  
NOUNLOAD,  REPLACE,  STATS = 5

GO


