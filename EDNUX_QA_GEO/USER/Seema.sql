USE [EDNUX_QA]
GO
/****** Object:  User [Seema]    Script Date: 7/6/2022 12:12:27 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'Seema')
CREATE USER [Seema] FOR LOGIN [Seema] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [Seema]
GO
