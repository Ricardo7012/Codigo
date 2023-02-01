--1.Value of error log file you want to read: 0 = current, 1 = Archive #1, 2 = Archive #2, etc... 
--2.Log file type: 1 or NULL = error log, 2 = SQL Agent log 
--3.Search string 1: String one you want to search for 
--4.Search string 2: String two you want to search for to further refine the results
EXEC sp_readerrorlog 1, 1, 'availability group failed over', ''
EXEC sp_readerrorlog 1, 1, 'STACK DUMP', ''
EXEC sp_readerrorlog 0, 1, 'CHECKDB', ''
EXEC sp_readerrorlog 0, 1, 'Error', ''
