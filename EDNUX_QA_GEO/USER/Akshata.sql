USE [EDNUX_QA]
GO
/****** Object:  User [Akshata]    Script Date: 7/6/2022 12:12:27 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'Akshata')
CREATE USER [Akshata] FOR LOGIN [Akshata] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [Akshata]
GO
