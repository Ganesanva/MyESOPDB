USE [EDNUX_QA]
GO
/****** Object:  User [MyESOPsENCDB\amit]    Script Date: 7/6/2022 12:12:27 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MyESOPsENCDB\amit')
CREATE USER [MyESOPsENCDB\amit] FOR LOGIN [MyESOPsEncDB\Amit] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [MyESOPsENCDB\amit]
GO
