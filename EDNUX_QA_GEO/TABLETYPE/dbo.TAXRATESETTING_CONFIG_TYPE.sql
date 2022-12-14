/****** Object:  UserDefinedTableType [dbo].[TAXRATESETTING_CONFIG_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TAXRATESETTING_CONFIG_TYPE]
GO
/****** Object:  UserDefinedTableType [dbo].[TAXRATESETTING_CONFIG_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TAXRATESETTING_CONFIG_TYPE] AS TABLE(
	[TRSC_ID] [bigint] NULL,
	[MIT_ID] [int] NOT NULL,
	[TAX_HEADING] [nvarchar](250) NOT NULL,
	[TAXRATE_LIVE_EMPLOYEE] [decimal](18, 6) NULL,
	[TAXRATE_SEPRATED_EMPLOYEE] [decimal](18, 6) NULL,
	[RESIDENTIAL_ID] [bigint] NULL,
	[COUNTRY_ID] [bigint] NULL
)
GO
