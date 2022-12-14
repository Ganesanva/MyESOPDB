/****** Object:  StoredProcedure [dbo].[PROC_CheckMultipleExercisingFieldsAvailableOrNot]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CheckMultipleExercisingFieldsAvailableOrNot]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CheckMultipleExercisingFieldsAvailableOrNot]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CheckMultipleExercisingFieldsAvailableOrNot]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT 1
			FROM sys.columns
			WHERE NAME = N'MinNoOfExeOpt'
				AND Object_ID = Object_ID(N'CompanyParameters')
			)
	BEGIN
		ALTER TABLE [DBO].[CompanyParameters] ADD MinNoOfExeOpt VARCHAR(10)
	END

	IF NOT EXISTS (
			SELECT 1
			FROM sys.columns
			WHERE NAME = N'MultipleForExeOpt'
				AND Object_ID = Object_ID(N'CompanyParameters')
			)
	BEGIN
		ALTER TABLE [DBO].[CompanyParameters] ADD MultipleForExeOpt VARCHAR(10)
	END

	IF NOT EXISTS (
			SELECT 1
			FROM sys.columns
			WHERE NAME = N'isExeriseAtOneGo'
				AND Object_ID = Object_ID(N'CompanyParameters')
			)
	BEGIN
		ALTER TABLE [DBO].CompanyParameters ADD isExeriseAtOneGo CHAR(1) DEFAULT 'N'
	END

	IF NOT EXISTS (
			SELECT 1
			FROM sys.columns
			WHERE NAME = N'isExeSeparately'
				AND Object_ID = Object_ID(N'CompanyParameters')
			)
	BEGIN
		ALTER TABLE [DBO].CompanyParameters ADD isExeSeparately CHAR(1) DEFAULT 'N'
	END

	SET NOCOUNT OFF;
END
GO
