-- Alter DB to turn Stats Back On

USE [master]
GO

ALTER DATABASE [PlayerTracking] 
SET AUTO_UPDATE_STATISTICS ON WITH NO_WAIT
GO