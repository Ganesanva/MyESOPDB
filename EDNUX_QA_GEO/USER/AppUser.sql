USE [EDNUX_QA]
GO
/****** Object:  User [AppUser]    Script Date: 7/6/2022 12:12:27 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'AppUser')
CREATE USER [AppUser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [AppUser]
GO
