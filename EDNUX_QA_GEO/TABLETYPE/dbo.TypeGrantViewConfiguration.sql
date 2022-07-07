/****** Object:  UserDefinedTableType [dbo].[TypeGrantViewConfiguration]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TypeGrantViewConfiguration]
GO
/****** Object:  UserDefinedTableType [dbo].[TypeGrantViewConfiguration]    Script Date: 7/6/2022 1:40:55 PM ******/
CREATE TYPE [dbo].[TypeGrantViewConfiguration] AS TABLE(
	[LetterAcceptanceStatus] [varchar](100) NULL,
	[IsViewEnabled] [bit] NULL,
	[IsDownloadEnabled] [bit] NULL
)
GO
