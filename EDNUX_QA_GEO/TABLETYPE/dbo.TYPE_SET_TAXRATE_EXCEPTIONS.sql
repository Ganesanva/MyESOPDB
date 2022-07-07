/****** Object:  UserDefinedTableType [dbo].[TYPE_SET_TAXRATE_EXCEPTIONS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_SET_TAXRATE_EXCEPTIONS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_SET_TAXRATE_EXCEPTIONS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_SET_TAXRATE_EXCEPTIONS] AS TABLE(
	[MIT_ID] [bigint] NOT NULL,
	[ACTIVE] [tinyint] NULL DEFAULT ((0)),
	[EXCEPTION_FOR] [nvarchar](100) NULL
)
GO
