USE [EDNUX_QA]
GO
/****** Object:  User [MyESOPsENCDB\karuna]    Script Date: 7/6/2022 12:12:27 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MyESOPsENCDB\karuna')
CREATE USER [MyESOPsENCDB\karuna] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [MyESOPsENCDB\karuna]
GO
