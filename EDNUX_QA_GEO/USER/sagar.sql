USE [EDNUX_QA]
GO
/****** Object:  User [sagar]    Script Date: 7/6/2022 12:12:27 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'sagar')
CREATE USER [sagar] FOR LOGIN [sagar] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [sagar]
GO
