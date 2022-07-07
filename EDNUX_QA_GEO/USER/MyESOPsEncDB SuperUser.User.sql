USE [EDNUX_QA]
GO
/****** Object:  User [MyESOPsEncDB\SuperUser]    Script Date: 7/6/2022 12:12:27 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MyESOPsEncDB\SuperUser')
CREATE USER [MyESOPsEncDB\SuperUser] FOR LOGIN [MyESOPsEncDB\SuperUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [MyESOPsEncDB\SuperUser]
GO
