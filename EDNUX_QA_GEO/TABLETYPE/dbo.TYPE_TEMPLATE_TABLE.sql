/****** Object:  UserDefinedTableType [dbo].[TYPE_TEMPLATE_TABLE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_TEMPLATE_TABLE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_TEMPLATE_TABLE]    Script Date: 7/6/2022 1:40:55 PM ******/
CREATE TYPE [dbo].[TYPE_TEMPLATE_TABLE] AS TABLE(
	[MAIP_ID] [int] NULL,
	[Column_Name] [varchar](50) NULL,
	[Column_Type] [varchar](10) NULL,
	[Fields] [varchar](50) NULL,
	[HEADER_TEXT] [varchar](100) NULL
)
GO
