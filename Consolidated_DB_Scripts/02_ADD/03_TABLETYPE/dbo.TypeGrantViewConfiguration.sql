
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_CUD_OGA_GRANTVIEWSETTINGS')
BEGIN
DROP PROCEDURE PROC_CUD_OGA_GRANTVIEWSETTINGS
END
GO

IF EXISTS(SELECT NAME FROM SYS.TYPES WHERE NAME = 'TypeGrantViewConfiguration')
BEGIN
DROP TYPE TypeGrantViewConfiguration
END
GO

/****** Object:  UserDefinedTableType [dbo].[TypeGrantViewConfiguration]    Script Date: 7/6/2022 1:40:55 PM ******/
CREATE TYPE [dbo].[TypeGrantViewConfiguration] AS TABLE(
	[LetterAcceptanceStatus] [varchar](100) NULL,
	[IsViewEnabled] [bit] NULL,
	[IsDownloadEnabled] [bit] NULL
)
GO


