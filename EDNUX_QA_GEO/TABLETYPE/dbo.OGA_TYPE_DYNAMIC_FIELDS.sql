/****** Object:  UserDefinedTableType [dbo].[OGA_TYPE_DYNAMIC_FIELDS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[OGA_TYPE_DYNAMIC_FIELDS]
GO
/****** Object:  UserDefinedTableType [dbo].[OGA_TYPE_DYNAMIC_FIELDS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[OGA_TYPE_DYNAMIC_FIELDS] AS TABLE(
	[FIELD_NAME] [varchar](50) NULL,
	[MAPPED_FIELD] [varchar](50) NULL
)
GO
