USE [EDNUX_QA]
GO
/****** Object:  User [siddharth]    Script Date: 7/6/2022 12:12:27 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'siddharth')
CREATE USER [siddharth] FOR LOGIN [siddharth] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [siddharth]
GO
ALTER ROLE [db_datareader] ADD MEMBER [siddharth]
GO
