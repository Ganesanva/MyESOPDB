/****** Object:  UserDefinedTableType [dbo].[TYPE_SET_COMPANY_EXCEPTIONS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_SET_COMPANY_EXCEPTIONS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_SET_COMPANY_EXCEPTIONS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_SET_COMPANY_EXCEPTIONS] AS TABLE(
	[ID] [bigint] NOT NULL,
	[ACTIVE] [tinyint] NULL DEFAULT ((0)),
	[RESIDENTIAL_ID] [bigint] NULL,
	[COUNTRY_ID] [bigint] NULL,
	[EXCEPTION_FOR] [nvarchar](100) NOT NULL,
	[APPLICABILITY] [tinyint] NULL DEFAULT ((0))
)
GO
